#!/usr/bin/env bash
# One-time personal Git identity setup.
set -euo pipefail

# --- Install gh if missing ---
if ! command -v gh &>/dev/null; then
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
        | sudo tee /etc/apt/sources.list.d/github-cli.list
    sudo apt-get update -y
    sudo apt-get install -y gh
fi

# --- GitHub auth ---
if ! gh auth status &>/dev/null; then
    gh auth login --git-protocol https --web
fi

# --- Git identity from GitHub account ---
gh_name="$(gh api user --jq '.name' 2>/dev/null || true)"
gh_email="$(gh api user/emails --jq '[.[] | select(.primary)][0].email' 2>/dev/null || true)"

current_name="$(git config --global user.name 2>/dev/null || true)"
current_email="$(git config --global user.email 2>/dev/null || true)"

if [[ -n "$current_name" && -n "$current_email" ]]; then
    printf 'Git déjà configuré: %s <%s>\n' "$current_name" "$current_email"
    read -rp 'Remplacer? [y/N] ' answer
    [[ "$answer" =~ ^[Yy]$ ]] || exit 0
fi

# Use GitHub values if available, otherwise prompt
if [[ -n "$gh_name" && -n "$gh_email" ]]; then
    printf 'Identité récupérée depuis GitHub: %s <%s>\n' "$gh_name" "$gh_email"
    read -rp 'Utiliser? [Y/n] ' answer
    if [[ ! "$answer" =~ ^[Nn]$ ]]; then
        git config --global user.name "$gh_name"
        git config --global user.email "$gh_email"
        printf '\nFait. Vérifier avec: git config --global --list\n'
        exit 0
    fi
fi

read -rp 'Name (e.g. Bob Lennon): ' name
[[ -n "$name" ]] || { echo 'Le nom ne peut pas être vide' >&2; exit 1; }

read -rp 'Email (e.g. bob.lennon@example.com): ' email
[[ -n "$email" ]] || { echo "L'adresse courriel ne peut pas être vide" >&2; exit 1; }

git config --global user.name "$name"
git config --global user.email "$email"

printf '\nFait. Vérifier avec: git config --global --list\n'
