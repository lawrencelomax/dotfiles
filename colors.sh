#!/usr/bin/env bash
#
# Terminal 256-Color Reference Display
#
# Purpose: Displays all 256 colors available in 256-color terminals
# Useful for: Choosing color codes for tmux.conf, vim themes, shell prompts, etc.
#
# Usage:
#   ./colors.sh               # Display all 256 colors with their codes
#   ./colors.sh | less -R     # View with paging (preserves colors)
#
# Output format:
#   colour0   (in color 0 - black)
#   colour1   (in color 1 - dark red)
#   ...
#   colour255 (in color 255 - light gray)
#
# ANSI 256-color escape sequence format:
#   \x1b[38;5;${i}m  = Set foreground color to color number i
#     \x1b   = ESC character (escape sequence start)
#     [      = CSI (Control Sequence Introducer)
#     38;5   = Select foreground color mode (38) with 256-color palette (5)
#     ;${i}m = Color number (0-255) + 'm' to end sequence
#
# Color ranges:
#   0-15    = Standard colors (black, red, green, yellow, blue, magenta, cyan, white + bright variants)
#   16-231  = 216 color cube (6×6×6 RGB palette)
#   232-255 = Grayscale ramp (24 shades from dark to light)
#

for i in {0..255} ; do
  printf "\x1b[38;5;${i}mcolour${i}\n"
done
