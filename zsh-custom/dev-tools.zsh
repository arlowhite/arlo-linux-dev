# Language toolchains: fnm (Node), pnpm, juliaup (Julia), Angular CLI, uv, Rust.
# zsh equivalents of the init blocks each installer added to ~/.bashrc.

# This is a bit slower than storing the result, but is always up-to-date

# fnm
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  path=("$FNM_PATH" $path)
  eval "$(fnm env --shell zsh)"
  source <(fnm completions --shell zsh)
fi

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) path=("$PNPM_HOME/bin" $path) ;;
esac
(( $+commands[pnpm] )) && source <(pnpm completion zsh)

# juliaup
path=("$HOME/.julia/bin" $path)
case ":$PATH:" in
  *":$HOME/.juliaup/bin:"*) ;;
  *) path=("$HOME/.juliaup/bin" $path) ;;
esac
[ -f "$HOME/.julia/juliaup/completions/zsh.zsh" ] && source "$HOME/.julia/juliaup/completions/zsh.zsh"

# Angular CLI (installed via pnpm)
(( $+commands[ng] )) && source <(ng completion script)

# uv (~/.local/bin) and Rust (~/.cargo/bin)
. "$HOME/.local/bin/env"
. "$HOME/.cargo/env"
