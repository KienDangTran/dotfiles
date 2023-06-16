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

source ~/dotfiles/shell/.aliases

ZSH_COLORIZE_TOOL=chroma
# Default editor
export EDITOR=nvim
# If you come from bash you might have to change your $PATH.
export PATH="$ZSH_BASE/brew/bin:$PATH"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
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
export FORGIT_FZF_DEFAULT_OPTS='
	--ansi
	--inline-info
	--height="80%"
	--preview-window="right:60%"
	--reverse
	--bind="alt-k:preview-up,alt-p:preview-up"
	--bind="alt-j:preview-down,alt-n:preview-down"
	--bind="ctrl-r:toggle-all"
	--bind="ctrl-s:toggle-sort"
	--bind="F3:toggle-preview-wrap"
	--bind="F4:toggle-preview"
	--bind="ctrl-u:preview-page-up"
	--bind="ctrl-d:preview-page-down"
'
unalias z 2> /dev/null
z() {
	[ $# -gt 0 ] && _z "$*" && return
	cd "$(_z -l 2>&1 | fzf --preview 'tree -C $(sed "s/^[^\/]*\//\//g" <<< {})' --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
}

# (EXPERIMENTAL) Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
    ssh)          fzf "$@" --preview 'dig {}' ;;
    *)            fzf "$@" --preview "bat -f --tabs 2 --wrap character {}";;
  esac
}

# starship
eval "$(starship init zsh)"


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
