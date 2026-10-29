# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert

# https://github.com/stuartleeks/wsl-notify-send
WSL_NOTIFY_SEND="$WIN_HOME/.local/wsl-bin/wsl-notify-send.exe"

if [[ -e "$WSL_NOTIFY_SEND" ]]; then
    # WSL mode
    alias notify-send='wsl-notify-send.exe --category $WSL_DISTRO_NAME'
elif [[ "$OSTYPE" == darwin* ]]; then
    # macOS mode: minimal notify-send shim. Usage: notify-send [options] TITLE [BODY]
    # Options (--urgency, -i, etc.) are ignored. Text goes in via argv so quotes are safe.
    notify-send() {
        while [[ "$1" == -* ]]; do
            [[ "$1" == -[uitca] ]] && shift  # short options that take a value
            shift
        done
        osascript \
            -e 'on run argv' \
            -e 'if (count of argv) > 1 then' \
            -e 'display notification (item 2 of argv) with title (item 1 of argv)' \
            -e 'else' \
            -e 'display notification (item 1 of argv)' \
            -e 'end if' \
            -e 'end run' \
            -- "$@"
    }
fi

# NOTE: must not be named "done" -- that's a reserved word (closes for/while loops)
alert() {
    local exit_code=$?
    local last_cmd=$(fc -ln -1 | sed -e 's/[;&|][[:space:]]*alert[[:space:]]*$//')
    if [[ -e "$WSL_NOTIFY_SEND" ]]; then
        wsl-notify-send.exe --category "${WSL_DISTRO_NAME}" "Done exit=${exit_code}: ${last_cmd}"
    elif [[ "$OSTYPE" == darwin* ]]; then
        notify-send "Done exit=${exit_code}" "${last_cmd}"
    else
        # TODO test true linux/mac
        command notify-send --urgency=low -i "$( (( exit_code == 0 )) && echo terminal || echo error)" "Done exit=${exit_code}: ${last_cmd}"
    fi
}
