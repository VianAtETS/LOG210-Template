#!/usr/bin/env bash
set -euo pipefail

grep -qF '__prompt_pwd' ~/.bashrc || cat >> ~/.bashrc <<'EOF'

__prompt_pwd() {
    local p="${PWD/#$HOME/~}"
    echo "${p#/workspaces/}"
}

PS1="\[\033[01;32m\]LOG210\[\033[00m\] ➜ \[\033[01;34m\]\$(__prompt_pwd)\[\033[00m\] \$ "
EOF
