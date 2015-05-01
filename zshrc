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

# Aliases
# jsonpretty will pretty print json stdin
alias jsonpretty='python -m json.tool'
