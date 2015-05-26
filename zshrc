# Source Antigen
source ~/.dotfiles/antigen

# Source Environment Exports
source ~/.dotfiles/env_exports

# Source Powerline
if [[ "$POWERLINE_ENABLED" == "1" ]]; then
  source ~/.powerline/bindings/zsh/powerline.zsh
else
  antigen theme ys
fi

# Enable $EDITOR Command Line Editing With C-x-e
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# Aliases
# jsonpretty will pretty print json stdin
alias jsonpretty='python -m json.tool'
alias tmux_to_pasteboard='tmux showb | pbcopy'
