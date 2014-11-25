# Remap prefix to Control + a
set -g prefix C-a
unbind C-b
bind C-a send-prefix

# Force a reload of the config file
unbind r
bind r source-file ~/.tmux.conf

# Quick pane cycling
unbind ^A
bind ^A select-pane -t :.+

# Nesting sessions with double prefix
bind-key b send-prefix
