# Source Antigen
source ~/.dotfiles/antigen

# Source Environment Exports
source ~/.dotfiles/env_exports

# Source Powerline
if [[ -z "$POWERLINE_ENABLED" ]]
  source ~/.powerline/bindings/zsh/powerline.zsh
then
  antigen theme ys
fi
