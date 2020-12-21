#
# ~/.config/zsh/.zshrc
#

# Handle the style control for the completion system
zstyle :compinstall filename '~/.config/zsh/.zshrc'

# Enable autocompletion
autoload -Uz compinit 
compinit -d "${XDG_DATA_HOME:="${HOME}/.local/share"}/zsh/zcompdump"

# Terminal history settings
HISTFILE="${XDG_DATA_HOME:="${HOME}/.local/share"}/zsh/history"
HISTSIZE=50000
SAVEHIST=50000
# Add more data to the history file.
setopt EXTENDED_HISTORY
# Share history across multiple zsh sessions.
setopt SHARE_HISTORY
# Append to history.
setopt APPEND_HISTORY
# Add commands as they are typed, not at shell exit.
setopt INC_APPEND_HISTORY
# Expire duplicates first.
setopt HIST_EXPIRE_DUPS_FIRST 
# Do not store duplications.
setopt HIST_IGNORE_DUPS
# Ignore duplicates when searching.
setopt HIST_FIND_NO_DUPS
# Removes blank lines from history.
setopt HIST_REDUCE_BLANKS

# Load the prompt theme system.
autoload -Uz promptinit
promptinit

# Configure the left prompt.
PROMPT=' %(!.%F{red}%B.%F{green}%B)%b%f %~ %(!.#.$) '

# Load the git prompt script to show on the right prompt.
setopt PROMPT_SUBST
source ~/.config/zsh/plugin/git_prompt

# Configure which git details to display.
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_SHOWCOLORHINTS=1

# Configure the right prompt.
export RPROMPT=$'$(__git_ps1 "%s")'

# Source the alias file.
source ~/.config/zsh/aliases

# Turn on case insensitive globbing.
setopt NO_CASE_GLOB

# Turn on Auto CD.
setopt AUTO_CD 

# Turn on ZSH correction.
setopt CORRECT
setopt CORRECT_ALL

# Turn on partial completion suggestions.
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix

