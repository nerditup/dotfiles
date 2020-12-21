#
# ~/.config/zsh/.zshenv
#

# Export XDG Base Directory Specification variables.
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_BIN_HOME="${XDG_BIN_HOME:-$HOME/.local/bin}"
export XDG_LIB_HOME="${XDG_LIB_HOME:-$HOME/.local/lib}"

# Conform to the XDG Base Directory Specification.
export VIMINIT=":source ${XDG_CONFIG_HOME:=$HOME/.config}/vim/vimrc"
export GNUPGHOME="${XDG_DATA_HOME:=$HOME/.local/share}/gnupg"
export PASSWORD_STORE_DIR="${XDG_DATA_HOME:=$HOME/.local/share}/pass"

# Add XDG_BIN_HOME to PATH.
export PATH="$XDG_BIN_HOME:$PATH"

# GPG
export GPG_TTY=$(tty)
