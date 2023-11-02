#!/bin/zsh
# .zshrc
ZSH_BASE=$HOME/dotfiles # Base directory for ZSH configuration
source $ZSH_BASE/antigen/antigen.zsh # Load Antigen

antigen use oh-my-zsh # Yes, I want to use Oh My ZSH

# oh-my-zsh plugins
antigen bundle aws
antigen bundle bundler
antigen bundle colorize
antigen bundle command-not-found
antigen bundle docker
antigen bundle dotenv
antigen bundle fzf
antigen bundle golang
antigen bundle rails
antigen bundle ripgrep
antigen bundle sdk
antigen bundle ssh-agent
antigen bundle vi-mode
antigen bundle agkozak/zsh-z
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
  export SDKMAN_DIR=$(brew --prefix sdkman-cli)/libexec
  [[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
fi
  

export PATH="${brew_path}/bin:${brew_path}/sbin:$PATH"
eval "$(rbenv init - zsh)"

#nvm
mkdir -p ~/.nvm ~/.nvm-x86
export NVM_DIR="${nvm_path}"

[ -s "${brew_opt_path}/nvm/nvm.sh" ] && . "${brew_opt_path}/nvm/nvm.sh"  # This loads nvm
[ -s "${brew_opt_path}/nvm/etc/bash_completion.d/nvm" ] && . "${brew_opt_path}/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
export PATH="$HOME/.pub-cache/bin":"$ANDROID_SDK_ROOT/platform-tools":"$ANDROID_SDK_ROOT/emulator":"$ANDROID_SDK_ROOT/cmdline-tools/latest/bin":"$PATH"
#
# Add rvm/rbenv to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin:$HOME/.rbenv/shims"

# fzf
if [[ ! "$PATH" == *${brew_opt_path}/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/${brew_opt_path}/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "${brew_opt_path}/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "${brew_opt_path}/fzf/shell/key-bindings.zsh"
# export FZF_BASE='/opt/homebrew/Cellar/fzf/0.42.0'
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_DEFAULT_OPTS='
	--ansi
	--inline-info
	--height 80%
	--reverse
	--preview-window="right:60%"
	--preview "bat -f --tabs 2 --wrap character {}"
	--bind="alt-k:preview-up,alt-p:preview-up"
	--bind="alt-j:preview-down,alt-n:preview-down"
	--bind="ctrl-r:toggle-all"
	--bind="ctrl-s:toggle-sort"
	--bind="F3:toggle-preview-wrap"
	--bind="F4:toggle-preview"
	--bind="ctrl-u:preview-page-up"
	--bind="ctrl-d:preview-page-down"
'
_fzf_comprun() {
  # (EXPERIMENTAL) Advanced customization of fzf options via _fzf_comprun function
  # - The first argument to the function is the name of the command.
  # - You should make sure to pass the rest of the arguments to fzf.
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
    ssh)          fzf "$@" --preview 'dig {}' ;;
    *)            fzf "$@" --preview "bat -f --tabs 2 --wrap character {}";;
  esac
}

unalias z 2> /dev/null
z() {
  [ $# -gt 0 ] && zshz "$*" && return
  cd "$(zshz -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
}

# starship
eval "$(starship init zsh)"

export KUBE_CONFIG_PATH=~/.kube/config
export BAT_THEME="Dracula"

# golang
export GOPATH=$HOME/go
export GOBIN=$HOME/go/bin
export GOROOT=$(brew --prefix golang)/libexec
export PATH=$PATH:$GOBIN:$GOROOT/bin

