# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert

# https://github.com/stuartleeks/wsl-notify-send
WSL_NOTIFY_SEND="$WIN_HOME/.local/wsl-bin/wsl-notify-send.exe"

if [[ -e "$WSL_NOTIFY_SEND" ]]; then
    # WSL mode
    alias notify-send='wsl-notify-send.exe --category $WSL_DISTRO_NAME'
fi

# NOTE: must not be named "done" -- that's a reserved word (closes for/while loops)
alert() {
    local exit_code=$?
    local last_cmd=$(fc -ln -1 | sed -e 's/[;&|]\s*alert\s*$//')
    if [[ -e "$WSL_NOTIFY_SEND" ]]; then
        wsl-notify-send.exe --category "${WSL_DISTRO_NAME}" "Done exit=${exit_code}: ${last_cmd}"
    else
        # TODO test true linux/mac
        command notify-send --urgency=low -i "$( (( exit_code == 0 )) && echo terminal || echo error)" "Done exit=${exit_code}: ${last_cmd}"
    fi
}
