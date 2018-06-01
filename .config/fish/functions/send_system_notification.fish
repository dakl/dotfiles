function send_system_notification
    if command --search osascript > /dev/null
        if test (count $argv) -eq 1
            echo "display notification \"\" with title \"$argv[1]\"" | osascript
        else if test (count $argv) -gt 1
            echo "display notification \"$argv[2]\" with title \"$argv[1]\"" | osascript
        end
    end
end
