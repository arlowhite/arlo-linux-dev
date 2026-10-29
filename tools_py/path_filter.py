#!/usr/bin/env python3
import logging
import sys

myname = "arlo-linux-dev/path_filter.py"
# myname = Path(__file__).name

# args / config
path = sys.argv[1]
paths = path.split(":")

try:
    log_level = sys.argv[2]
except:
    log_level = logging.INFO

# setup
logging.basicConfig(stream=sys.stderr, format="▶️  %(message)s", level=log_level)
log = logging.getLogger(__name__)


keep = ["/Microsoft VS Code", "/JetBrains", ".local/wsl-bin"]

remove_count = 0


def include(p: str):
    global remove_count

    # log.debug("include? %s", p)

    # we only care about Windows paths under C:\
    if not p.startswith("/mnt/c/"):
        return True

    # keep the path if
    for match_text in keep:
        if match_text in p:
            log.info("✅ %s", p)
            return True

    log.debug("❌ %s", p)
    remove_count += 1

    return False


new_paths = [p for p in paths if include(p)]

if remove_count > 0:
    log.warning(f"{myname}: removed {remove_count} Windows paths")

# STDOUT will be sourced by zshrc/bashrc
print(f'export PATH="{":".join(new_paths)}"')
