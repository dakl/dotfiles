import warnings
from typing import Iterable, Literal

from fire import Fire
from google.cloud import compute_v1

warnings.filterwarnings(action="ignore", category=UserWarning, module=r"google.auth.*")


class Commands:
    def _print_instance(self, instance):
        n_accelerators = (
            0
            if not instance.guest_accelerators
            else sum([x.accelerator_count for x in instance.guest_accelerators])
        )
        print(f" - {instance.name} - {instance.status} - {n_accelerators} accelerators")

    def ls(
        self,
        project_id: str = "es-playground-dev-c9e7",
        zone: str = "europe-west4-a",
    ) -> Iterable[compute_v1.Instance]:
        instance_client = compute_v1.InstancesClient()
        instance_list = instance_client.list(project=project_id, zone=zone)

        print(f"Instances found in zone {zone}:")
        for instance in instance_list:
            self._print_instance(instance)

    def up(
        self,
        project_id: str = "es-playground-dev-c9e7",
        zone: str = "europe-west4-a",
        name: str = "danielk",
    ):
        instance_client = compute_v1.InstancesClient()
        instance_client.start(project=project_id, zone=zone, instance=name)
        print("ok")

    def down(
        self,
        project_id: str = "es-playground-dev-c9e7",
        zone: str = "europe-west4-a",
        name: str = "danielk",
    ):
        instance_client = compute_v1.InstancesClient()
        instance_client.stop(project=project_id, zone=zone, instance=name)
        print("ok")

    def get(
        self,
        project_id: str = "es-playground-dev-c9e7",
        zone: str = "europe-west4-a",
        name: str = "danielk",
    ):
        instance_client = compute_v1.InstancesClient()
        instance = instance_client.get(project=project_id, zone=zone, instance=name)
        self._print_instance(instance)

    def get_gpu(
        self,
        project_id: str = "es-playground-dev-c9e7",
        zone: str = "europe-west4-a",
        name: str = "danielk",
    ):
        instance_client = compute_v1.InstancesClient()
        instance = instance_client.get(project=project_id, zone=zone, instance=name)
        print(instance.guest_accelerators)

    def set_gpu(
        self,
        gpu_type: Literal["none", "v100", "a100", "t4"] = "none",
        name: str = "danielk",
        zone: str = "europe-west4-a",
        project_id: str = "es-playground-dev-c9e7",
    ):
        instance_client = compute_v1.InstancesClient()
        instance = instance_client.get(project=project_id, zone=zone, instance=name)
        if gpu_type == "none":
            instance.machine_type = 'https://www.googleapis.com/compute/v1/projects/es-playground-dev-c9e7/zones/europe-west4-a/machineTypes/n1-standard-8'
            accelerator_config = None

        elif gpu_type == "v100":
            instance.machine_type = 'https://www.googleapis.com/compute/v1/projects/es-playground-dev-c9e7/zones/europe-west4-a/machineTypes/n1-standard-8'
            accelerator_config = [
                compute_v1.AcceleratorConfig(
                    accelerator_count=1,
                    accelerator_type="projects/es-playground-dev-c9e7/zones/europe-west4-a/acceleratorTypes/nvidia-tesla-v100",
                )
            ]

        elif gpu_type == "a100":
            instance.machine_type = 'https://www.googleapis.com/compute/v1/projects/es-playground-dev-c9e7/zones/europe-west4-a/machineTypes/a2-highgpu-1g'
            accelerator_config = [
                compute_v1.AcceleratorConfig(
                    accelerator_count=1,
                    accelerator_type="projects/es-playground-dev-c9e7/zones/europe-west4-a/acceleratorTypes/nvidia-tesla-a100",
                )
            ]

        elif gpu_type == "t4":
            instance.machine_type = 'https://www.googleapis.com/compute/v1/projects/es-playground-dev-c9e7/zones/europe-west4-a/machineTypes/n1-standard-32'
            accelerator_config = [
                compute_v1.AcceleratorConfig(
                    accelerator_count=1,
                    accelerator_type="projects/es-playground-dev-c9e7/zones/europe-west4-a/acceleratorTypes/nvidia-tesla-t4",
                )
            ]

        instance.guest_accelerators = accelerator_config

        instance_client.update(
            project=project_id, zone=zone, instance=name, instance_resource=instance
        )
        print("ok")


if __name__ == "__main__":
    Fire(Commands)
