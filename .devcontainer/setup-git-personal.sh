#!/usr/bin/env bash
# One-time personal Git identity setup.
set -euo pipefail

current_name="$(git config --global user.name 2>/dev/null || true)"
current_email="$(git config --global user.email 2>/dev/null || true)"

if [[ -n "$current_name" && -n "$current_email" ]]; then
    printf 'Git déjà configuré: %s <%s>\n' "$current_name" "$current_email"
    read -rp 'Remplacer? [y/N] ' answer
    [[ "$answer" =~ ^[Yy]$ ]] || exit 0
fi

read -rp 'Name (e.g. Bob Lennon): ' name
[[ -n "$name" ]] || { echo 'Le nom ne peut pas être vide' >&2; exit 1; }

read -rp 'Email (e.g. bob.lennon@example.com): ' email
[[ -n "$email" ]] || { echo "L'adresse courriel ne peut pas être vide" >&2; exit 1; }

git config --global user.name "$name"
git config --global user.email "$email"

printf '\nFait. Vérifier avec: git config --global --list\n'
