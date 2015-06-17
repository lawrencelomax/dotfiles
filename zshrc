###################
# Sourcing
###################
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

###################
# Configuration
###################
# Enable $EDITOR Command Line Editing With C-x-e
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

###################
# Aliasing
###################
# jsonpretty will pretty print json stdin
alias jsonpretty='python -m json.tool'
alias tmux_to_pasteboard='tmux showb | pbcopy'

# xcode-simctl stuff
alias simlist='xcrun simctl list'
alias xcode-beta='sudo xcode-select -s /Applications/Xcode-beta.app/'
alias xcode-prod='sudo xcode-select -s /Applications/xcode_6.3.app/'

# mercurial 
alias hu='hg update -r '
alias hum='hg update master'
alias hus='hg update stable'

# Show exit code
RPROMPT='[%?]'
