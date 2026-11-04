# Dotfiles

Run `./install.sh` to install personal Copilot instructions for VS Code and the
[1up MCP server](https://github.com/github/1up) for Copilot CLI. GitHub Codespaces
runs the installer automatically when this repository is configured as your dotfiles.

## 1up MCP server

The 1up setup is adapted from
[tmelliottjr/dotfiles](https://github.com/tmelliottjr/dotfiles/blob/main/install.sh).
It requires Go, `jq`, and authenticated Git access to the private `github/1up`
repository. Missing tools or an installation failure produce a warning without
preventing the existing VS Code instructions setup.

The installer preserves existing `GOPRIVATE` entries and adds `github.com/github/*`,
then runs `go install github.com/github/1up@latest`. It uses `GOBIN` when set,
otherwise the first `GOPATH` entry's `bin` directory.

It registers the binary in `~/.copilot/mcp-config.json` under `oneup`, preserving
other servers and settings and removing any legacy `1up` entry. The alphabetic
key avoids digit-prefixed tool names rejected by some providers. Invalid JSON
is left unchanged and reported as an error.

The configuration forwards `GITHUB_TOKEN` by environment-variable reference,
without saving its value. Set that variable in the environment where you launch
Copilot CLI with a token that can access the repositories 1up needs.

Re-run `./install.sh` to upgrade 1up, then restart Copilot CLI to load the server.
