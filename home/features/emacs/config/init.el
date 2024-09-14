;;; Startup
;;; PACKAGE LIST
(setq package-archives 
      '(("melpa" . "https://melpa.org/packages/")
        ("elpa" . "https://elpa.gnu.org/packages/")))

;;; BOOTSTRAP USE-PACKAGE
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))

;;; UNDO
;; Vim style undo not needed for emacs 28
(use-package undo-fu)

;;; Vim Bindings
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

;;; Vim Bindings Everywhere else
(use-package evil-collection
  :after evil
  :config
  (setq evil-want-integration t)
  (evil-collection-init))

;;; Frame and Appearance
(use-package doom-themes
  :config
  (load-theme 'doom-one t) ; Change 'doom-one' to your preferred theme
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

(use-package gruber-darker-theme
  :config
  (load-theme 'gruber-darker t))

(tool-bar-mode -1)  ;; Disable the toolbar
(menu-bar-mode -1)  ;; Disable the menu bar
(scroll-bar-mode -1)  ;; Disable the scroll bar
(setq inhibit-startup-screen t)  ;; Disable the startup screen
(setq display-line-numbers-type 'relative) ;; Set relative line numbers

(global-display-line-numbers-mode 1)
(setq display-line-numbers 'relative)

;;; Font Size Increase/Decrease
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

;;; Keybinding suggestions
(use-package which-key
  :ensure t
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.5))

;;; Space Keybinding Leader
(use-package evil-leader
  :config
  (evil-leader/set-leader "SPC")
  (global-evil-leader-mode nil)

  (evil-leader/set-key
    "x" 'scratch-buffer
    "." 'find-file
    "SPC" 'projectile-find-file
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

    "g C-g" 'count-words
  ))

;;; Enable vertico
(use-package vertico
  :init
  (vertico-mode)

  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

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

(use-package marginalia :defer t :ensure t
  :init
  (marginalia-mode))

(use-package consult :ensure t :defer t)

;;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

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
  :init
  (setq lsp-keymap-prefix "C-c l"))

(use-package lsp-ui
  :ensure t
  :after lsp-mode
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-sideline-enable t
        lsp-ui-peek-enable t))

;;; Language support

(use-package rustic
  :ensure t
  :after lsp-mode
  :config
  (setq lsp-rust-analyzer-server-command '("rust-analyzer"))
  (add-hook 'rust-mode-hook #'lsp-deferred))

(use-package zig-mode
  :ensure t
  :after lsp-mode
  :config
  (add-hook 'zig-mode-hook #'lsp-deferred))

