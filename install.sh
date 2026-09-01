#!/usr/bin/env bash
# Installs personal Copilot instructions as a VS Code user-level "instructions" file so
# they apply in every workspace/codespace, not just this repository.
#
# GitHub Codespaces automatically runs this script (from the dotfiles repo configured in
# https://github.com/settings/codespaces) after the container is created. It can also be
# run manually inside any codespace or Remote-* connection.
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source_md="$repo_dir/copilot/copilot-instructions.md"
dest_name="nasquasha-personal.instructions.md"

if [[ ! -f "$source_md" ]]; then
  echo "install.sh: $source_md not found, skipping Copilot instructions install" >&2
  exit 1
fi

# VS Code user data lives in different folders depending on how the editor connects:
# Codespaces uses .vscode-remote, Remote-SSH/Containers use .vscode-server, and a local
# install uses .config/Code (Linux) or Library/Application Support/Code (macOS).
candidate_user_dirs=(
  "$HOME/.vscode-remote/data/User"
  "$HOME/.vscode-server/data/User"
  "$HOME/.config/Code/User"
  "$HOME/.config/Code - Insiders/User"
  "$HOME/Library/Application Support/Code/User"
  "$HOME/Library/Application Support/Code - Insiders/User"
)

installed=0
for user_dir in "${candidate_user_dirs[@]}"; do
  [[ -d "$user_dir" ]] || continue

  prompts_dir="$user_dir/prompts"
  mkdir -p "$prompts_dir"
  dest="$prompts_dir/$dest_name"

  {
    printf -- '---\napplyTo: '"'"'**'"'"'\n---\n\n'
    cat "$source_md"
  } > "$dest"

  echo "install.sh: installed Copilot instructions to $dest"
  installed=1
done

if [[ "$installed" -eq 0 ]]; then
  # No VS Code user data folder exists yet (e.g. script ran before VS Code connected).
  # Fall back to the Codespaces default location so the file is ready once it does.
  fallback_dir="$HOME/.vscode-remote/data/User/prompts"
  mkdir -p "$fallback_dir"
  dest="$fallback_dir/$dest_name"
  {
    printf -- '---\napplyTo: '"'"'**'"'"'\n---\n\n'
    cat "$source_md"
  } > "$dest"
  echo "install.sh: installed Copilot instructions to $dest"
fi
