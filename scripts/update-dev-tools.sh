#!/bin/bash

fnm install v24
fnm install v26
# bump the default alias
fnm default v24
fnm ls

pnpm self-update
pnpm outdated -g
pnpm update -g

uv self update

rustup update

juliaup update
