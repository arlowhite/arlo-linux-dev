# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert

# https://github.com/stuartleeks/wsl-notify-send
WSL_NOTIFY_SEND="$WIN_HOME/.local/wsl-bin/wsl-notify-send.exe"

if [[ -e "$WSL_NOTIFY_SEND" ]]; then
    # WSL mode
    alias alert-last='wsl-notify-send.exe --category "${WSL_DISTRO_NAME}" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
    alias notify-send='wsl-notify-send.exe --category $WSL_DISTRO_NAME "${@}"'
else
    alias alert-last='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi
