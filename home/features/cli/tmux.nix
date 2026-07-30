{ pkgs, ... }: {
  programs = {
    tmux = {
      enable = true;
      shell = "/bin/zsh";

      plugins = with pkgs; [ tmuxPlugins.yank ];

      extraConfig = ''
        # Prefix
        unbind C-b
        set -g prefix C-a
        bind-key C-a send-prefix
         
        set -g default-command "$\{SHELL\}"
        set -g history-limit 100000
        set -g extended-keys on
        set -sg escape-time 0
        set -g mode-keys vi
         
        set -g default-terminal "tmux-256color"
        set -ga terminal-overrides ",xterm*:Tc,*256col*:Tc,alacritty:Tc"
         
        # Pane navigation without prefix
        bind -n M-h select-pane -L
        bind -n M-l select-pane -R
        bind -n M-k select-pane -U
        bind -n M-j select-pane -D
         
        # Quiet
        set -g visual-activity off
        set -g visual-bell off
        set -g visual-silence off
        set -g bell-action none
        setw -g monitor-activity off
         
        # Status bar: no hard-coded background, inherits the terminal theme
        set -g status-position bottom
        set -g status-justify left
        set -g status-interval 5
        set -g status-style "bg=default,fg=default"
         
        set -g status-left ""
        set -g status-left-length 20
        set -g status-right-length 50
        set -g status-right "#[fg=blue]%d/%m #[fg=cyan]%H:%M "
         
        setw -g window-status-style "fg=default"
        setw -g window-status-format " #[fg=blue]#I#[fg=default]:#W#F "
        setw -g window-status-current-style "fg=magenta,bold"
        setw -g window-status-current-format " #I:#W#F "
        setw -g window-status-separator ""
         
        # Borders and messages
        set -g pane-border-style "fg=default"
        set -g pane-active-border-style "fg=magenta"
        set -g message-style "bg=default,fg=default,reverse"
        setw -g clock-mode-colour blue
      '';
    };
  };
}
