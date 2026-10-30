alias zshconfig="code $ARLO_LINUX_DEV"
alias ohmyzsh="code ~/.oh-my-zsh"

# git
# usage: git-reset-branch <branch> <target>  (e.g. git-reset-branch deploy/dev main)
git-reset-branch() {
  if [[ $# -ne 2 ]]; then
    echo "usage: git-reset-branch <branch> <target>" >&2
    return 1
  fi
  git branch -f "$1" "$2" && git push --force-with-lease origin "$1"
}
