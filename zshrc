###################
# Sourcing
###################
# Source Antigen
source ~/.dotfiles/antigen

# Source Environment Exports
source ~/.dotfiles/env_exports

###################
# Configuration
###################
# Enable $EDITOR Command Line Editing With C-x-e
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

###################
# Theming
###################

# Disable VCS Info at prompt, it's slow
zstyle ':vcs_info:*' disable bzr cdv darcs mtn svk tla hg git

# Disable Mercurial Prompt info
LP_ENABLE_HG=0

# Coloring with less
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;016m\E[48;5;220m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

###################
# Aliasing
###################
# jsonpretty will pretty print json stdin
alias jsonpretty='python -m json.tool'
alias tmux_to_pasteboard='tmux showb | pbcopy'

# xcode-simctl stuff
alias simlist='xcrun simctl list'
alias xcode-beta='sudo xcode-select -s /Applications/xcode7_beta6.app/Contents/Developer'
alias xcode-prod='sudo xcode-select -s /Applications/xcode_6.3.app/Contents/Developer'

# mercurial 
alias hu='hg update -r '
alias hum='hg update master'
alias hus='hg update stable'

