function fish_right_prompt
    set -l __status $status

    if test $__status = 0
        set items "😄 " "👍 " "😍 " "🖖 " "👊 " "👌 " "🙌 " "😎 "
        #printf '[%s%s%s]' (set_color red) $__status (set_color normal)
    else
        set items "😢 " "💥 " "👿 " "☠️ " "💩 " "🤢 "
    end
    set __item_index (random 1 (count $items))
    echo $items[$__item_index]

    if test $CMD_DURATION
        # Show duration of the last command
        set duration (echo "$CMD_DURATION 1000" | awk '{printf "%.3fs", $1 / $2}')
        echo " in $duration"

        # OS X notification when a command takes longer than notify_duration
        set notify_duration 10000
        set exclude_cmd "bash|less|man|more|ssh|vim|nvim"
        if begin
                test $CMD_DURATION -gt $notify_duration
                and echo $history[1] | grep -vqE "^($exclude_cmd).*"
            end

            # Only show the notification if iTerm or Terminal (active app name matches the string 'Term') is not focused
            echo "
                tell application \"System Events\"
                    set activeApp to name of first application process whose frontmost is true
                    if \"Term\" is not in activeApp then
                        display notification \"Finished in $duration\" with title \"$history[1]\"
                    end if
                end tell
                " | osascript
        end
    end

    # set pushover_notification_duration 1000
    # if test $pushover_user; and test $pushover_key; and test $CMD_DURATION -gt $pushover_notification_duration
    #     curl -s \
    #         --form-string "token=$pushover_key" \
    #         --form-string "user=$pushover_user" \
    #         --form-string "message=$history[1] finished in $duration" \
    #         https://api.pushover.net/1/messages.json > /dev/null
    # end

end
