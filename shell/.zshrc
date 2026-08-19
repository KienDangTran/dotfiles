#!/bin/zsh
# .zshrc
ZSH_BASE=$HOME/dotfiles # Base directory for ZSH configuration
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000
setopt appendhistory

source $ZSH_BASE/antigen/antigen.zsh # Load Antigen

antigen use oh-my-zsh # Yes, I want to use Oh My ZSH

# oh-my-zsh plugins
antigen bundle aws
antigen bundle bundler
antigen bundle colorize
antigen bundle command-not-found
antigen bundle dotenv
antigen bundle fzf
antigen bundle golang
antigen bundle rails
antigen bundle ripgrep
antigen bundle sdk
antigen bundle ssh-agent
antigen bundle vi-mode
antigen bundle z
antigen bundle zsh-interactive-cd
antigen bundle zsh-navigation-tools
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-autosuggestions

# Do OS dependant stuff
case `uname` in
  Darwin)
    # Commands for macOS go here
    antigen bundle macos
  ;;
  Linux)
    # Commands for Linux go here
  ;;
esac

# Set the theme
antigen theme amuse

# And lastly, apply the Antigen stuff
antigen apply

source ~/.aliases

ZSH_COLORIZE_TOOL=chroma

# Default editor
export EDITOR=nvim

case `uname` in
  Darwin)
    if [ "$(sysctl -n sysctl.proc_translated)" = "1" ]; then
      local brew_path="/usr/local/homebrew"
      local brew_opt_path="/usr/local/Homebrew/opt"
      local nvm_path="$HOME/.nvm-x86"

      eval "$(/usr/local/homebrew/bin/brew shellenv)"
      export DOCKER_DEFAULT_PLATFORM=linux/amd64
    else
      local brew_path="/opt/homebrew"
      local brew_opt_path="/opt/homebrew/opt"
      local nvm_path="$HOME/.nvm"

      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    export PATH="${brew_path}/bin:${brew_path}/sbin:$PATH"

  ;;
  Linux)
    # Commands for Linux go here
  ;;
esac

autoload -U add-zsh-hook

unalias z 2> /dev/null
z() {
  [ $# -gt 0 ] && zshz "$*" && return
  cd "$(zshz -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
}

# starship
eval "$(starship init zsh)"

export KUBE_CONFIG_PATH=~/.kube/config
export BAT_THEME="Dracula"

autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit
compinit


# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

path=('/home/kien/.juliaup/bin' $path)
export PATH
# Tab completion for juliaup and julia channel selection
[ -f "/home/kien/.julia/juliaup/completions/zsh.zsh" ] && source "/home/kien/.julia/juliaup/completions/zsh.zsh"

# <<< juliaup initialize <<<
