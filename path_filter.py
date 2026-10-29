#!/usr/bin/env python3

import sys

myname = "tools/path_filter"

path = sys.argv[1]
paths = path.split(":")

keep = ["/Microsoft VS Code", "/JetBrains", ".local/wsl-bin"]

remove_count = 0


def log(*msg: str) -> None:
    """
    print to stderr, which won't be sourced by bashrc/zshrc
    """
    print("▶️ ", *msg, file=sys.stderr)


def include(p: str):
    global remove_count

    # log("include?", p)

    # we only care about Windows paths under C:\
    if not p.startswith("/mnt/c/"):
        return True

    # keep the path if
    for match_text in keep:
        if match_text in p:
            log("Keeping:", p)
            return True

    log(f'echo "Remove: {p}"')
    remove_count += 1

    return False


new_paths = [p for p in paths if include(p)]

if remove_count > 0:
    log(f'echo "{myname}: removed {remove_count} Windows paths"')

# STDOUT will be sourced by zshrc/bashrc
print(f'export PATH="{":".join(new_paths)}"')
