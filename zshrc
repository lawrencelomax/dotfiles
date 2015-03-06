# Source Antigen
source ~/.dotfiles/antigen

# Source Environment Exports
source ~/.dotfiles/env_exports

# Source Powerline
#if [[ -z "$POWERLINE_ENABLED" ]] && $POWERLINE_ENABLED="1"; then
#  source ~/.powerline/bindings/zsh/powerline.zsh
#else
  antigen theme ys
#fi

# Enable pyenv
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

# Enable rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

