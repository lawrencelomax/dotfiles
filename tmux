# Remap prefix to Control + a
set -g prefix C-a
unbind C-b
bind C-a send-prefix

# Nesting sessions with double prefix
bind-key a send-prefix

# Enable UTF8
set status-utf8 on
set utf8 on

# 256 Color
set -g default-terminal "screen-256color"

# Put the Status Bar on the Top
set-option -g status-position top

# Change the default bar color
set -g status-bg colour44

# Force a reload of the config file
unbind r
bind r source-file ~/.tmux.conf

# Quick pane cycling
unbind ^A
bind ^A select-pane -t :.+

