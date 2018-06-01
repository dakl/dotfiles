function fish_right_prompt
    set -l __status $status
    set -l items
    set -l status_color

    if test $__status = 0
        #set items "😄 " "👍 " "😍 " "🖖 " "👊 " "👌 " "🙌 " "😎 "
        set items "y " " y" "Y " " Y"
        set status_color "green"
        set status_message "succeeded"
    else
        #set items "😢 " "💥 " "👿 " "☠️ " "💩 " "🤢 "
        set items "n " " n" "N " " N"
        set status_color "red"
        set status_message "failed"
    end

    set __item_index (python -c "import random, sys; print(random.randint(1, int(sys.argv[1])))" (count $items))

    set_color $status_color    
    echo $items[$__item_index]
    set_color normal

    if test $CMD_DURATION
        # Show duration of the last command
        set -l duration (echo "$CMD_DURATION 1000" | awk '{printf "%.3fs", $1 / $2}')
        echo " in $duration"
        set -l cmd $history[1] 

        # OS X notification when a command takes longer than notify_duration
        set -l notify_duration 10000
        set -l exclude_cmd "bash|less|man|more|ssh|vim|nvim"
        if begin
                test $CMD_DURATION -gt $notify_duration
                and echo $cmd | grep -vqE "^($exclude_cmd).*"
            end
            set -l notification_message "$cmd $status_message after $duration."
            set -l title "Command $status_message"
            send_system_notification $title $notification_message
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
