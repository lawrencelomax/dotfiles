# Remap prefix to Control + a
set -g prefix C-a
unbind C-b
bind C-a send-prefix

# Enable UTF8
set status-utf8 on
set utf8 on

# 256 Color
set -g default-terminal "screen-256color"

# Put the Status Bar on the Top
set-option -g status-position top

# Force a reload of the config file
unbind r
bind r source-file ~/.tmux.conf

# Quick pane cycling
unbind ^A
bind ^A select-pane -t :.+

# Nesting sessions with double prefix
bind-key b send-prefix
