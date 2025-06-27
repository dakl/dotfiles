from textual.app import App, ComposeResult
from textual.containers import Container, Horizontal, Vertical, Grid
from textual.widgets import (
    Button,
    Header,
    Footer,
    Static,
    Input,
    Select,
    ListView,
    ListItem,
    Label,
)
from textual.screen import ModalScreen
from textual.events import Key
from vm import Commands
import io
import json
import os
from contextlib import redirect_stdout
from typing import Dict


class GPUSelector(ModalScreen):
    def __init__(self):
        super().__init__()
        self.gpu_types = ["v100", "a100", "t4", "l4"]
        self.gpu_counts = [1, 2, 4, 8]
        self.selected_row = 0
        self.selected_col = 0
        self.grid_selected = True

    def compose(self) -> ComposeResult:
        yield Container(
            Static("Select GPU Configuration", classes="title"),
            Static(
                "Use arrow keys to navigate, Enter to select, Esc to cancel", classes="instructions"
            ),
            Grid(
                *[
                    Button(
                        f"{count} × {gpu_type.upper()}",
                        id=f"gpu_{gpu_type}_{count}",
                        classes="gpu_button",
                    )
                    for gpu_type in self.gpu_types
                    for count in self.gpu_counts
                ],
                id="gpu_grid",
            ),
            Button("NO GPU", id="gpu_none", classes="gpu_button none", variant="primary"),
            id="gpu_modal",
        )

    def on_mount(self) -> None:
        self.update_selection()

    def update_selection(self):
        none_button = self.query_one("#gpu_none")
        if not self.grid_selected:
            none_button.add_class("selected")
        else:
            none_button.remove_class("selected")
            for i, gpu_type in enumerate(self.gpu_types):
                for j, count in enumerate(self.gpu_counts):
                    button = self.query_one(f"#gpu_{gpu_type}_{count}")
                    if i == self.selected_row and j == self.selected_col:
                        button.add_class("selected")
                    else:
                        button.remove_class("selected")

    def on_key(self, event: Key) -> None:
        if event.key == "escape":
            self.dismiss(None)
        elif event.key == "enter":
            if self.grid_selected:
                gpu_type = self.gpu_types[self.selected_row]
                count = self.gpu_counts[self.selected_col]
                self.dismiss((gpu_type, count))
            else:
                self.dismiss(("none", 1))
        elif (
            event.key == "down"
            and self.grid_selected
            and self.selected_row == len(self.gpu_types) - 1
        ):
            self.grid_selected = False
            self.update_selection()
        elif event.key == "up" and not self.grid_selected:
            self.grid_selected = True
            self.selected_row = len(self.gpu_types) - 1
            self.update_selection()
        elif self.grid_selected:
            if event.key == "up":
                self.selected_row = max(0, self.selected_row - 1)
                self.update_selection()
            elif event.key == "down":
                self.selected_row = min(len(self.gpu_types) - 1, self.selected_row + 1)
                self.update_selection()
            elif event.key == "left":
                self.selected_col = max(0, self.selected_col - 1)
                self.update_selection()
            elif event.key == "right":
                self.selected_col = min(len(self.gpu_counts) - 1, self.selected_col + 1)
                self.update_selection()


class VMListItem(ListItem):
    def __init__(self, vm_name: str, vm_status: str, is_favorite: bool = False):
        super().__init__()
        self._name = vm_name
        self._status = vm_status
        self._is_favorite = is_favorite

    @property
    def name(self) -> str:
        return self._name

    @property
    def status(self) -> str:
        return self._status

    @property
    def is_favorite(self) -> bool:
        return self._is_favorite

    @is_favorite.setter
    def is_favorite(self, value: bool) -> None:
        self._is_favorite = value

    def compose(self) -> ComposeResult:
        star = "★" if self._is_favorite else "☆"
        yield Label(f"{star} {self._name} - {self._status}")


class VMApp(App):
    CSS = """
    Screen {
        align: center middle;
    }
    
    Container {
        width: 80%;
        height: 90%;
        border: solid green;
    }
    
    #buttons {
        height: auto;
        margin: 1;
    }
    
    #status {
        height: auto;
        margin: 1;
        border: solid blue;
        padding: 1;
    }
    
    #controls {
        height: auto;
        margin: 1;
    }

    #vm_list {
        height: 40%;
        border: solid yellow;
        margin: 1;
    }

    #legend {
        height: auto;
        margin: 1;
        text-align: center;
        color: white;
        background: #333333;
        padding: 1;
        border: solid #666666;
    }

    #gpu_modal {
        width: 40%;
        height: auto;
        background: #111111;
        border: solid #666666;
        padding: 2;
    }

    .title {
        text-align: center;
        margin-bottom: 1;
    }

    .instructions {
        text-align: center;
        color: #888888;
        margin-bottom: 1;
    }

    #gpu_grid {
        grid-size: 4 4;
        grid-gutter: 1 1;
        margin: 1;
        height: auto;
        align: center middle;
    }

    .gpu_button {
        width: 100%;
        height: 100%;
        min-height: 1;
        padding: 0 1;
        content-align: center middle;
        text-align: center;
        border: none;
        background: #222222;
        color: #ffffff;
    }

    .gpu_button.selected {
        background: #444444;
        border: solid $accent;
    }

    .gpu_button.none {
        margin-top: 1;
        min-height: 3;
        background: #222222;
        width: 100%;
        color: #ffffff;
        border: solid #333333;
    }

    .gpu_button.none.selected {
        background: #444444;
        border: solid $accent;
    }
    """

    def __init__(self):
        super().__init__()
        self.vm = Commands()
        self.favorites_file = os.path.expanduser("~/.vm.json")
        self.favorites = self.load_favorites()
        self.vm_list = []

    def load_favorites(self) -> Dict[str, bool]:
        if os.path.exists(self.favorites_file):
            with open(self.favorites_file, "r") as f:
                return json.load(f)
        return {}

    def save_favorites(self):
        with open(self.favorites_file, "w") as f:
            json.dump(self.favorites, f)

    def _print_instance(self, instance):
        n_accelerators = 0
        accelerator_type = "none"
        if instance.guest_accelerators:
            n_accelerators = sum([x.accelerator_count for x in instance.guest_accelerators])
            # The type looks like "projects/.../acceleratorTypes/nvidia-tesla-v100"
            # We want to extract just "v100"
            accelerator_path = instance.guest_accelerators[0].accelerator_type
            accelerator_type = accelerator_path.split("/")[-1].split("-")[-1]

        status = self.query_one("#status")
        status.update(
            f" - {instance.name}\n   Status: {instance.status}\n   GPU: {n_accelerators}× {accelerator_type.upper()}"
        )

    def compose(self) -> ComposeResult:
        yield Header()
        with Container():
            with Vertical():
                yield Static("VM Management", id="title")
                with Horizontal(id="buttons"):
                    yield Button("List VMs", id="list")
                    yield Button("Start VM", id="start")
                    yield Button("Stop VM", id="stop")
                    yield Button("Get VM Info", id="info")
                yield ListView(id="vm_list")
                with Horizontal(id="controls"):
                    yield Input(placeholder="VM Name", id="vm_name")
                yield Static("", id="status")
                yield Static(
                    "↑↓: navigate | f: favorite | s: start | x: stop | i: info | g: set GPU | q: quit",
                    id="legend",
                )
        yield Footer()

    def on_mount(self) -> None:
        self.query_one("#vm_name").value = "danielk"
        self.refresh_vm_list()

    def refresh_vm_list(self):
        output = io.StringIO()
        with redirect_stdout(output):
            self.vm.ls()

        vm_list = self.query_one("#vm_list")
        vm_list.clear()

        vms = []
        for line in output.getvalue().split("\n"):
            if line.startswith(" - "):
                parts = line[3:].split(" - ")
                if len(parts) >= 2:
                    name = parts[0].strip()
                    status = parts[1].strip()
                    is_favorite = self.favorites.get(name, False)
                    vms.append((name, status, is_favorite))

        # Sort VMs with favorites first
        vms.sort(key=lambda x: (not x[2], x[0]))  # Sort by favorite status then name

        for name, status, is_favorite in vms:
            vm_list.append(VMListItem(name, status, is_favorite))

    def on_button_pressed(self, event: Button.Pressed) -> None:
        if event.button.id == "list":
            self.refresh_vm_list()
        else:
            vm_name = self.query_one("#vm_name").value
            status = self.query_one("#status")

            output = io.StringIO()
            with redirect_stdout(output):
                if event.button.id == "start":
                    self.vm.up(name=vm_name)
                elif event.button.id == "stop":
                    self.vm.down(name=vm_name)
                elif event.button.id == "info":
                    instance = self.vm.get(name=vm_name)
                    self._print_instance(instance)
                    return

            status.update(output.getvalue())
            self.refresh_vm_list()

    def on_list_view_selected(self, event: ListView.Selected) -> None:
        if isinstance(event.item, VMListItem):
            self.query_one("#vm_name").value = event.item.name

    def on_key(self, event: Key) -> None:
        if event.key == "q":
            self.exit()
        elif event.key == "f":
            vm_list = self.query_one("#vm_list")
            if vm_list.highlighted_child:
                item = vm_list.highlighted_child
                if isinstance(item, VMListItem):
                    item.is_favorite = not item.is_favorite
                    self.favorites[item.name] = item.is_favorite
                    self.save_favorites()
                    self.refresh_vm_list()
        elif event.key == "g":
            self.push_screen(GPUSelector(), self.handle_gpu_selection)
        elif event.key in ["s", "x", "i"]:
            vm_name = self.query_one("#vm_name").value
            status = self.query_one("#status")

            output = io.StringIO()
            with redirect_stdout(output):
                if event.key == "s":
                    self.vm.up(name=vm_name)
                elif event.key == "x":
                    self.vm.down(name=vm_name)
                elif event.key == "i":
                    self.vm.get(name=vm_name)

            status.update(output.getvalue())
            self.refresh_vm_list()

    async def handle_gpu_selection(self, result):
        if result is not None:
            gpu_type, gpu_count = result
            vm_name = self.query_one("#vm_name").value
            status = self.query_one("#status")

            output = io.StringIO()
            with redirect_stdout(output):
                self.vm.set_gpu(gpu_type=gpu_type, count=gpu_count, name=vm_name)

            status.update(output.getvalue())
            self.refresh_vm_list()


if __name__ == "__main__":
    app = VMApp()
    app.run()
