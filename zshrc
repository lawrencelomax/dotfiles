###################
# LiquidPrompt
###################
# Disable Mercurial support in LiquidPrompt (HG = Mercurial version control)
# Mercurial VCS status checking can slow down the prompt
export LP_ENABLE_HG=0

# Disable battery status display in LiquidPrompt (BATT = Battery)
# Not needed for desktop/workstation setups without battery monitoring
export LP_ENABLE_BATT=0

###################
# Sourcing
###################
# Source Antigen plugin manager for zsh
# Antigen is the zsh plugin manager (declares and loads plugins)
source ~/.dotfiles/antigen

# Source environment variable exports (PATH, EDITOR, TERM, etc.)
source ~/.dotfiles/env_exports

###################
# Configuration
###################

# Enable command-line editing in $EDITOR with Ctrl-x Ctrl-e
# Pressing C-x C-e opens current command line in your editor (nvim)
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# Prevent tmux/terminal from auto-renaming window titles
# Allows manual window naming to persist
export DISABLE_AUTO_TITLE="true"

###################
# Theming
###################

# Disable all VCS (Version Control System) info in zsh prompt
# VCS status checking (git, hg, etc.) can significantly slow down prompt rendering
# LiquidPrompt handles VCS display more efficiently
zstyle ':vcs_info:*' disable bzr cdv darcs mtn svk tla hg git


# Colorize output in less/man pages using ANSI escape codes
# These TERMCAP variables control how less displays various text styles:
export LESS_TERMCAP_mb=$'\E[01;31m'                # begin blinking (bold red)
export LESS_TERMCAP_md=$'\E[01;38;5;74m'           # begin bold (bold cyan/blue)
export LESS_TERMCAP_me=$'\E[0m'                    # end mode (reset all)
export LESS_TERMCAP_se=$'\E[0m'                    # end standout-mode (reset)
export LESS_TERMCAP_so=$'\E[38;5;016m\E[48;5;220m' # begin standout-mode (black on yellow, for search/info)
export LESS_TERMCAP_ue=$'\E[0m'                    # end underline (reset)
export LESS_TERMCAP_us=$'\E[04;38;5;146m'          # begin underline (underlined gray/green)

###################
# Aliasing
###################

# Git shortcuts (the oh-my-zsh git plugin was removed; these are the handful
# worth keeping). Names avoid gsl/gsr/gss/gsi/gnr, which are used by other
# PATH-based shims on this setup.
alias gst='git status'
alias gd='git diff'
alias gdc='git diff --cached'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -v'
alias gcm='git commit -m'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch'
alias gp='git push'
alias gl='git pull'
alias gf='git fetch'
alias glog='git log --oneline --graph --decorate'

# JSON pretty-printing from stdin
# Usage: echo '{"key":"value"}' | jsonpretty
alias jsonpretty='python -m json.tool'

# Copy tmux scrollback buffer to macOS clipboard
# Usage: tmux_to_pasteboard
alias tmux_to_pasteboard='tmux showb | pbcopy'

# iOS Simulator and Xcode tooling
# simlist - List all available iOS simulators
# Uses xcrun to invoke simctl (iOS Simulator control tool)
alias simlist='xcrun simctl list'

# Switch between different Xcode versions
# Useful when testing with beta vs stable Xcode releases
# Note: Paths are version-specific and may need updating
alias xcode-beta='sudo xcode-select -s /Applications/xcode7_beta6.app/Contents/Developer'
alias xcode-prod='sudo xcode-select -s /Applications/xcode_6.3.app/Contents/Developer'

# Mercurial (hg) version control shortcuts
# hu - Update working directory to specific revision
# Usage: hu abc123 (short for 'hg update -r abc123')
alias hu='hg update -r '

# hum - Update to master branch
alias hum='hg update master'

# hus - Update to stable branch
alias hus='hg update stable'

# hg-changes - Show file change statistics for a specific revision
# Usage: hg-changes abc123
function hg-changes() { hg diff -c $1 --stat }

# Text manipulation utilities
# firstword - Extract first word from each line
# Usage: echo "hello world" | firstword  => "hello"
alias firstword='cut -f 1 -d " "'

# Git branch cleanup - Remove all local branches that have been deleted from origin
# This complex one-liner:
# 1. Switches to master branch
# 2. Lists all local branches (excluding master) to /tmp/gitlocal.txt
# 3. Lists all remote branches (stripping 'origin/' prefix) to /tmp/gitremote.txt
# 4. Finds local branches not in remote list using grep -Fxv
# 5. Deletes those local branches with 'git branch -d'
alias gitpruneall="git checkout master && git branch -l | sed 's/* master//' > /tmp/gitlocal.txt && git branch -r  | sed 's/origin\///' > /tmp/gitremote.txt && grep -Fxv -f /tmp/gitremote.txt /tmp/gitlocal.txt | xargs git branch -d"

# Date/time helpers
# unixtime - Print current Unix timestamp (seconds since epoch)
# Usage: unixtime  => 1735479600
alias unixtime='date +%s'

###################
# Local overrides
###################
# Source machine-specific config last, if present, so it can extend or override
# anything above. Keep per-host/work settings — extra PATHs, local tooling,
# secrets — in ~/.zshrc.local (never in this repo). The guard makes this a no-op
# on fresh clones and on hosts without a local file.
[[ -r ~/.zshrc.local ]] && source ~/.zshrc.local
