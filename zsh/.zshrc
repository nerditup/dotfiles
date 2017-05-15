# Handle the style control for the completion system
zstyle :compinstall filename '/home/csloggett/.zshrc'
# Handle git auto completion (requires the git-completion.zsh script from git source)
zstyle ':completion:*:*:git:*' script '/home/csloggett/.git-completion.zsh'

# Enable autocompletion
autoload -Uz compinit 
compinit

# Terminal history settings
HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=5000

# Set the Zsh Line Editor mode to vi
bindkey -v

# Load the prompt theme system
autoload -Uz promptinit
promptinit

# Configure the Left Prompt
PROMPT=' %(!.%F{red}%B.%F{green}%B)→%b%f %~ %(!.#.$) '

# Load the git prompt script to show on the right prompt
setopt prompt_subst
. /home/csloggett/.git-prompt.sh

# Configure the Right Prompt
export RPROMPT=$'$(__git_ps1 "%s")'
