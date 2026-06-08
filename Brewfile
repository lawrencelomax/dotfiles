# Brewfile — Homebrew package manifest
#
# Install everything with:
#   brew bundle --file=~/.dotfiles/Brewfile
# (setup offers to install Homebrew and run this for you.)
#
# Check what's missing without installing:
#   brew bundle check --file=~/.dotfiles/Brewfile
#
# Machine- or work-specific packages go in an untracked Brewfile.local (kept
# out of this public repo); setup applies it too if present.

# Taps
# tap "homebrew/cask-fonts"

# Formulae (CLI tools)
# These back the Claude permission allowlist (.claude/settings.defaults.json),
# excluding tools macOS already ships (cat/ls/find/grep/git/patch/nm/otool/
# strings/xcodebuild/man/ping) and ones that come from outside Homebrew (sl/hg/buck/buck2).
brew "jq"          # JSON on the command line (validate uses it for the perms doc check)
brew "dockutil"    # manage Dock items (used by the macos script)
brew "neovim"      # editor; config managed in .config/nvim
brew "tmux"        # terminal multiplexer; config in tmux.conf
brew "tig"         # text-mode git UI
brew "fd"          # fast file find (used by nvim Telescope)
brew "ripgrep"     # fast content search / rg (nvim Telescope live-grep)
brew "tree"        # directory tree listing
brew "pandoc"      # document conversion
brew "poppler"     # PDF utilities incl. pdftotext
brew "imagemagick" # convert / magick / identify
brew "xcodegen"    # Xcode project generation

# Casks (GUI apps)
cask "ghostty"     # terminal — config managed in .config/ghostty
# 1Password and WhatsApp are intentionally NOT here — installed separately,
# not via Homebrew. They're still pinned in the Dock via the macos script.

# Mac App Store apps (requires `mas` and being signed into the App Store)
# brew "mas"
# mas "Xcode", id: 497799835
