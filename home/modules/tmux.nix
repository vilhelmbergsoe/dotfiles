{ pkgs, ... }: {
  programs = {
    tmux = {
      enable = true;

      extraConfig = ''
        # remap prefix from 'C-b' to 'C-a'
        unbind C-b
        set-option -g prefix C-a
        bind-key C-a send-prefix

        # set -g mouse on

        #set -g default-command "$ {SHELL}"

        # switch panes using Alt-arrow without prefix
        bind -n M-h select-pane -L
        bind -n M-l select-pane -R
        bind -n M-k select-pane -U
        bind -n M-j select-pane -D

        ######################
        ### DESIGN CHANGES ###
        ######################

        ## Status bar design
        # status line
        set -g status-justify left
        set -g status-bg default
        set -g status-fg colour12
        set -g status-interval 1

        # window status
        setw -g window-status-format " #F#I:#W#F "
        setw -g window-status-current-format " #F#I:#W#F "
        setw -g window-status-format "#[fg=magenta]#[bg=black] #I #[bg=black]#[fg=colour8] #W "
        setw -g window-status-current-format "#[bg=brightmagenta]#[fg=colour8] #I #[fg=colour8]#[bg=colour14] #W "

        # Info on left (I don't have a session display for now)
        set -g status-left '''''''''

        # loud or quiet?
        set-option -g visual-activity off
        set-option -g visual-bell off
        set-option -g visual-silence off
        set-window-option -g monitor-activity off
        set-option -g bell-action none

        set -g default-terminal "xterm-256color"
        set-option -g terminal-overrides "xterm-256color:Tc"

        setw -g clock-mode-colour colour135

        set -g status-position bottom
        set -g status-bg colour234
        set -g status-fg colour137

        set -g status-left '''''''''
        set -g status-right '#[fg=colour233,bg=colour241,bold] %d/%m #[fg=colour233,bg=colour245,bold] %H:%M:%S '
        set -g status-right-length 50
        set -g status-left-length 20

        setw -g window-status-current-format ' #I#[fg=colour250]:#[fg=colour255]#W#[fg=colour50]#F '

        setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '

        # fix escape time in vim
        set -sg escape-time 0

        # use vi keybindings in scroll mode
        set-window-option -g mode-keys vi
      '';

      plugins = with pkgs; [ ];
    };
  };
}
