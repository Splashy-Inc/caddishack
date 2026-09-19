#!/bin/sh
printf '\033c\033]0;%s\a' CaddiShack
base_path="$(dirname "$(realpath "$0")")"
"$base_path/CaddiShack.x86_64" "$@"
