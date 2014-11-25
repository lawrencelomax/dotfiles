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

# Smart pane switching with awareness of vim splits
is_vim='echo "#{pane_current_command}" | grep -iqE "(^|\/)g?(view|n?vim?)(diff)?$"'
bind -n C-h if-shell "$is_vim" "send-keys C-h" "select-pane -L"
bind -n C-j if-shell "$is_vim" "send-keys C-j" "select-pane -D"
bind -n C-k if-shell "$is_vim" "send-keys C-k" "select-pane -U"
bind -n C-l if-shell "$is_vim" "send-keys C-l" "select-pane -R"
bind -n C-\ if-shell "$is_vim" "send-keys C-\\" "select-pane -l"

# Force a reload of the config file
unbind r
bind r source-file ~/.tmux.conf

# Quick pane cycling
unbind ^A
bind ^A select-pane -t :.+

