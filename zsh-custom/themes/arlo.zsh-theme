# Based on robbyrussell, plus AWS_PROFILE / CONFIG_FILE_NAME when set

prompt_env_info() {
  local out=""
  [[ -n "$AWS_PROFILE" ]] && out+="%{$fg_bold[blue]%}aws:(%{$fg[yellow]%}${AWS_PROFILE}%{$fg_bold[blue]%})%{$reset_color%} "
  [[ -n "$CONFIG_FILE_NAME" ]] && out+="%{$fg_bold[blue]%}cfg:(%{$fg[magenta]%}${CONFIG_FILE_NAME}%{$fg_bold[blue]%})%{$reset_color%} "
  echo -n "$out"
}

PROMPT="%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg[cyan]%}%c%{$reset_color%}"
PROMPT+=' $(git_prompt_info)$(prompt_env_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
