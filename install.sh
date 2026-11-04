#!/usr/bin/env bash
# Installs personal Copilot instructions for VS Code and the 1up MCP server for Copilot CLI.
#
# GitHub Codespaces automatically runs this script (from the dotfiles repo configured in
# https://github.com/settings/codespaces) after the container is created. It can also be
# run manually inside any codespace or Remote-* connection.
set -euo pipefail

register_1up_mcp() {
  local bin_path="$1"
  local config="$HOME/.copilot/mcp-config.json"
  local config_json='{}'
  local tmp

  if [[ -s "$config" ]]; then
    config_json="$(cat "$config")"
  fi
  mkdir -p "$HOME/.copilot"
  tmp="$(mktemp "$HOME/.copilot/mcp-config.json.XXXXXX")"

  # A digit-prefixed server key produces tool names rejected by some providers.
  if jq --arg cmd "$bin_path" '
      .mcpServers //= {}
      | del(.mcpServers["1up"])
      | .mcpServers.oneup = {
          type: "local",
          command: $cmd,
          args: [],
          env: { GITHUB_TOKEN: "${GITHUB_TOKEN}" },
          tools: ["*"]
        }
    ' <<< "$config_json" > "$tmp"; then
    mv "$tmp" "$config"
    echo "install.sh: registered 1up MCP server in $config"
  else
    rm -f "$tmp"
    echo "install.sh: could not update $config; existing configuration preserved" >&2
    return 1
  fi
}

install_1up() {
  local dependency
  for dependency in go jq; do
    if ! command -v "$dependency" >/dev/null 2>&1; then
      echo "install.sh: $dependency not found, skipping 1up MCP server" >&2
      return
    fi
  done

  local goprivate gobin
  goprivate="$(go env GOPRIVATE)"
  case ",$goprivate," in
    *",github.com/github/*,"*) ;;
    *)
      # Private modules must bypass the public Go proxy and checksum database.
      go env -w GOPRIVATE="${goprivate:+$goprivate,}github.com/github/*"
      ;;
  esac

  gobin="$(go env GOBIN)"
  if [[ -z "$gobin" ]]; then
    gobin="$(go env GOPATH)"
    gobin="${gobin%%:*}/bin"
  fi

  echo "install.sh: installing 1up MCP server"
  if go install github.com/github/1up@latest; then
    register_1up_mcp "$gobin/1up"
  else
    echo "install.sh: 1up installation failed; check Go and access to github/1up" >&2
  fi
}

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

install_1up
