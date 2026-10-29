# arlo-linux-dev

My Linux dev environment config. It holds the zsh setup on top of [oh-my-zsh](https://ohmyz.sh/): the `.zshrc`, a custom prompt theme and shell aliases.

## Contents

```
zshrc                        # symlinked to ~/.zshrc
path_filter.py               # strips Windows dirs from PATH on WSL (sourced by zshrc)
tools/                       # Rust crate for tools/scripts (one binary per src/bin/*.rs)
zsh-custom/                  # oh-my-zsh ZSH_CUSTOM directory
├── dev-tools.zsh            # fnm, pnpm, juliaup, ng, uv, Rust PATH setup and completions
├── wsl.zsh                  # WSL settings (DOCKER_HOST)
├── reefguide.zsh            # ReefGuide env vars and aliases (rg-*)
└── themes/
    └── arlo.zsh-theme       # robbyrussell + AWS_PROFILE / CONFIG_FILE_NAME
```

Every `*.zsh` file in `zsh-custom/` is loaded automatically by oh-my-zsh, in alphabetical order.

## Setup on a new machine

1. Install zsh and make it your default shell:

   ```sh
   sudo apt install zsh git
   chsh -s "$(which zsh)"
   ```

2. Install oh-my-zsh:

   ```sh
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

3. Clone this repo anywhere (`zshrc` locates itself); `~/code/arlo-linux-dev` is used below:

   ```sh
   mkdir -p ~/code
   git clone <repo-url> ~/code/arlo-linux-dev
   ```

4. Replace the `~/.zshrc` the installer created with a symlink to the one in this repo:

   ```sh
   mv ~/.zshrc ~/.zshrc.pre-arlo-linux-dev
   ln -s ~/code/arlo-linux-dev/zshrc ~/.zshrc
   ```

5. Open a new terminal, or run `exec zsh`.

## Rust tools

`tools/` is a Cargo crate; each file in `tools/src/bin/` builds to its own binary. `path_filter` is a Rust port of `path_filter.py`.

```sh
cd tools && cargo build --release   # binaries land in tools/target/release/
```

## Prompt

The `arlo` theme is robbyrussell plus two extra segments. Each one shows only while its variable is set:

```
➜  infra git:(main) aws:(reefguide) cfg:(dev.json)
```

| Segment   | Variable           |
| --------- | ------------------ |
| `aws:(…)` | `AWS_PROFILE`      |
| `cfg:(…)` | `CONFIG_FILE_NAME` |

The prompt updates as soon as you `export` or `unset` either variable. To show another variable, add a line to `prompt_env_info` in [`zsh-custom/themes/arlo.zsh-theme`](zsh-custom/themes/arlo.zsh-theme).

## Adding config

- **Aliases, functions, env vars:** add a new `zsh-custom/<name>.zsh` file. It is loaded on the next shell start.
- **Third-party plugins**, for example `zsh-autosuggestions`: clone them into `zsh-custom/plugins/<name>` (or add them as a git submodule), then add the name to `plugins=(...)` in `zshrc`. Plugins in `~/.oh-my-zsh/custom/plugins` are no longer picked up.
- **Secrets:** don't commit them. Put them in an untracked file such as `~/.zshrc.local`, and source it from `zshrc`:

  ```sh
  [[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
  ```
