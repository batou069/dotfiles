# ~/.zshenv
# Sourced on all shells. Used for setting environment variables and the path.

# Environment Variables
export NVIM_THEME=catppuccin
export VISUAL=nvim
export EDITOR=nvim
export NVIM_APPNAME=lazyvim
export TERM="xterm-256color"
export BAT_THEME="Catppuccin Mocha"
export STARSHIP_CONFIG=~/.config/starship.toml

# Custom Directories & Aliases
export AIC="$HOME/git/c/"
export AIP="$HOME/git/py/"
export CONF="$HOME/.config/"
export GIT="$HOME/git/"
export REPOS="$HOME/apps/"
export OBSIDIAN="$HOME/Obsidian/"
export DOTFILES="$HOME/.dotfiles/"
export STARSHIP_CONFIG=~/.config/starship.toml

# Go Path (GOPATH is fine, GOROOT is handled by Nix)
export GOPATH="$HOME/go"

# Bat Directories
export BAT_CONFIG_PATH="$HOME/.config/bat/config"
export BAT_CONFIG_DIR="$HOME/.config/bat"

# Source personal environment variables if the file exists
[[ -f "$HOME/.env" ]] && source "$HOME/.env"
