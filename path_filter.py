#!/usr/bin/python3

import sys

myname='tools/path_filter'

path = sys.argv[1]
paths = path.split(':')

keep = [
    '/Microsoft VS Code',
    '/JetBrains'
]

remove_count = 0

def include(p):
    global remove_count
    if p.startswith('/mnt/c/'):
        for text in keep:
            if text in p:
                return True

        # print(f'echo "Remove: {p}"')
        remove_count += 1

        return False

    else:
        return True


new_paths = [p for p in paths if include(p)]

if remove_count > 0:
    print(f'echo "{myname}: removed {remove_count} Windows paths"')

print(f'export PATH="{":".join(new_paths)}"')
