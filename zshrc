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
# Antigen manages zsh plugins similar to how Vundle manages vim plugins
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

# simrecord - Record video from running iOS simulator
# fbsimctl = Facebook's iOS Simulator control tool (more features than Apple's simctl)
# Records video, then extracts path to the video file from diagnostics
alias simrecord='fbsimctl --debug-logging record start -- listen -- record stop > /dev/null && fbsimctl --state=booted diagnose | grep video | awk '\''{print $NF}'\'''

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

# hg-pick-rev - Interactively pick files to revert from a specific revision
# Uses 'fpp' (Facebook PathPicker) for interactive file selection
# Usage: hg-pick-rev abc123
function hg-pick-rev() { hg-changes $1 | fpp -nfc -c "hg revert -r $1" }

# hg-pick-prev - Pick files to revert from current/previous commit
# Uses '.' to reference the current commit
alias hg-pick-prev='hg-pick-rev .'

# Sapling (sl) - Meta's fork of Mercurial with improved UX
# sle - "Sapling List and Edit" - Open all uncommitted changed files in editor
# Useful for quickly reviewing and editing all working directory changes
sle() {
  local -a files
  files=( ${(f)"$(sl status --no-status 2>/dev/null)"} )
  if (( ${#files} )); then
    $EDITOR $files
  else
    echo "No uncommitted changes"
  fi
}

# slec - "Sapling List and Edit Commit" - Open all files from current commit in editor
# Useful for reviewing what was changed in the latest commit
slec() {
  local -a files
  files=( ${(f)"$(sl status --no-status --change . 2>/dev/null)"} )
  if (( ${#files} )); then
    $EDITOR $files
  else
    echo "No changes in current commit"
  fi
}

# Python codemod for removing unused imports
# Uses libcst (LibCST = Concrete Syntax Tree library) from fbcode
# RemoveUnusedImportsWithGlean queries Meta's code indexer to detect unused imports
# Must be run from within an hg repository (uses 'hg root' to find repo)
alias remove_unused_imports='$(hg root)/fbcode/python/libcst/libcst codemod remove_unused_imports.RemoveUnusedImportsWithGlean'

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
