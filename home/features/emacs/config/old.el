;;; BASICS

;;; PACKAGE LIST
(setq package-archives 
      '(("melpa" . "https://melpa.org/packages/")
        ("elpa" . "https://elpa.gnu.org/packages/")))

;;; PERFORMANCE
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb

;;; SETUP USE-PACKAGE
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))

;;; SANE
(setq create-lockfiles nil) ;; annoying #filename# files

;;; KEYBOARD

;;; Evil mode
(use-package evil
  :init
  ;; allows for using cgn
  ;; (setq evil-search-module 'evil-search)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  ;; no vim insert bindings
  (setq evil-undo-system 'undo-fu)
  :config
  (evil-mode 1))

(use-package undo-fu)

(use-package evil-collection
  :after evil
  :config
  (setq evil-want-integration t)
  (evil-collection-init))

(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

(use-package evil-leader
  :config
  (evil-leader/set-leader "SPC")
  (global-evil-leader-mode nil)

  (evil-leader/set-key
    "x" 'scratch-buffer
    "." 'find-file

    "SPC" 'projectile-find-file
    "pf" 'projectile-find-file
    "pp" 'projectile-switch-project

    "ca" 'lsp-execute-code-action

    "bk" 'kill-current-buffer

    "ht" 'load-theme
    "hb" 'embark-bindings

    ;; evil window
    "wh" 'evil-window-left
    "wl" 'evil-window-right
    "wk" 'evil-window-up
    "wj" 'evil-window-down

    "wH" 'evil-window-move-far-left
    "wL" 'evil-window-move-far-right
    "wK" 'evil-window-move-very-top
    "wJ" 'evil-window-move-very-bottom

    "wv" 'evil-window-vsplit
    "ws" 'evil-window-split
    "ww" 'evil-window-next
    "wq" 'evil-quit

    "gg" 'magit-status ;; magit
    "op" 'neotree-toggle ;; neotree

    "gd" 'lsp-find-definition
    "gD" 'lsp-find-references

    "/"  'consult-ripgrep

    "<"  'consult-buffer

    "g C-g" 'count-words
  ))

(evil-define-key 'normal 'global (kbd "K") #'lsp-ui-doc-glance)
(evil-define-key 'insert global-map (kbd "C-SPC") #'company-complete)

;;; MAC COMMAND META
(setq mac-option-key-is-meta nil
      mac-command-key-is-meta t
      mac-command-modifier 'meta
      mac-option-modifier 'none)

;;; Frame and Appearance
(use-package doom-themes
  :config
  (load-theme 'doom-xcode t)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))
(use-package gruber-darker-theme)


(tool-bar-mode -1)  ;; Disable the toolbar
(menu-bar-mode -1)  ;; Disable the menu bar
(scroll-bar-mode -1)  ;; Disable the scroll bar
(setq inhibit-startup-screen t)  ;; Disable the startup screen
(setq display-line-numbers-type 'relative) ;; Set relative line numbers
(setq initial-buffer-choice t)     ;; Open the *scratch* buffer by default

(setq initial-scratch-message
      (concat
       ";                __\n"
       ";            .--()°'.'\n"
       ";           '|, . ,'\n"
       ";            !_-(_\\\n"
       "; \n"
       "; Welcome back! Let's get to work..."))

(global-display-line-numbers-mode 1)
(setq display-line-numbers 'relative)


;;; Keybinding suggestions
(use-package which-key
  :ensure t
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.5))


;;; Enable vertico
(use-package vertico
  :init
  (vertico-mode)

  ;; Show more candidates
  (setq vertico-count 20))

(use-package vertico-prescient :ensure t
  :config
  (setq prescient-filter-method  '(literal regexp fuzzy initialism))
  (vertico-prescient-mode +1))

(use-package embark :ensure t :defer t
  ;; :bind
  ;; (("C-c e" . embark-act)
  ;;  ("C-h b" . embark-bindings))
  :init
  (setq prefix-help-command #'embark-prefix-help-command)
  (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  :config
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult :ensure t :defer t)

(use-package marginalia :defer t :ensure t
  :init
  (marginalia-mode))

(use-package consult :ensure t :defer t)

; ;;; Persist history over Emacs restarts. Vertico sorts by history position.
; (use-package savehist
;   :init
;   (savehist-mode))

;;; Evil Commentary
(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode))

;;; Enable Projectile
(use-package projectile :defer t :ensure t
  :init
  (setq projectile-project-root-files '(".git/"))
  (projectile-mode 1))

;;; Magit
(use-package magit :defer t :ensure t)

(use-package neotree :defer t :ensure t)

(use-package all-the-icons :defer t :ensure t)
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))

;;; Markdown
(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "pandoc"))

;;; Direnv
(use-package direnv
 :config
 (direnv-mode))

;;; LSP
(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook ((prog-mode . lsp-deferred))  ; Enable LSP for programming modes
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (setq lsp-enable-snippet nil  ;; Disable snippet support if not needed
        lsp-headerline-breadcrumb-enable t))

(use-package lsp-ui
  :ensure t
  :after lsp-mode
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-sideline-enable t
        lsp-ui-peek-enable t))

; (use-package company
;   :ensure t
;   :config
;   (global-company-mode))
(use-package company
  :ensure t
  :hook (prog-mode . company-mode)
  :config
  (global-company-mode)
  (setq company-minimum-prefix-length 1
        company-idle-delay 0.2))  ;; Quick suggestions

(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-install 'prompt)
  :config
  (global-treesit-auto-mode))

;;; Language support

;;; RUST
(use-package rustic
  :ensure t
  :after lsp-mode
  :config
  (setq lsp-rust-analyzer-server-command '("rust-analyzer"))
  (add-hook 'rust-mode-hook #'lsp-deferred))

;;; NIX
(use-package nix-mode
  :ensure t
  :mode "\\.nix\\'")

(use-package typescript-mode
  :ensure t)

