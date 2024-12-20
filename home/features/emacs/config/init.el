;;; Core Emacs Settings ----------------------------------------

;; Performance
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))

;; Package System
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                        ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; Basic UI
(setq inhibit-startup-screen t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)
(setq native-comp-async-report-warnings-errors nil)

(setq inhibit-startup-screen t)
(setq initial-buffer-choice t)

(setq initial-scratch-message
      (concat
       ";                __\n"
       ";            .--()°'.'\n"
       ";           '|, . ,'\n"
       ";            !_-(_\\\n"
       "\n"))

;; File Behavior
(setq create-lockfiles nil
      make-backup-files nil
      auto-save-default nil)

(setq-default tab-width 2)

;; Platform Specific (MacOS)
(setq mac-option-key-is-meta nil
      mac-command-key-is-meta t
      mac-command-modifier 'meta
      mac-option-modifier 'none)

;;; Editor Foundation ---------------------------------------

(use-package undo-fu)

(use-package evil
  :init
  (setq evil-want-keybinding nil
        evil-want-C-u-scroll t
        evil-undo-system 'undo-fu)
  :config
  (evil-mode 1))

(use-package origami
  :hook (prog-mode . origami-mode))

(use-package evil-collection
  :after evil
  :config
  (setq evil-want-integration t)
  (evil-collection-init))

(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode))

;; Completion System
(use-package vertico
  :init
  (vertico-mode)
  (setq vertico-count 20))

(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles . (partial-completion))))))

(use-package marginalia
  :init
  (marginalia-mode))

(use-package consult)

(use-package savehist
  :ensure nil
  :init
  (savehist-mode))

;; Code Completion
(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-separator ?\s)
  (corfu-quit-at-boundary nil)
  (corfu-quit-no-match nil)
  (corfu-preview-current nil)
  (corfu-preselect 'prompt)
  (corfu-on-exact-match nil)
  (corfu-scroll-margin 5)
  :init
  (global-corfu-mode))

;; Completion extensions
(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-keyword))

;; Enable for nice completion icons
;; (use-package kind-icon
;;   :after corfu
;;   :custom
;;   (kind-icon-default-face 'corfu-default)
;;   :config
;;   (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

;;; Development Environment ---------------------------------

;; LSP Support
(use-package eglot
  :ensure nil
  :hook ((prog-mode . eglot-ensure))
  :config
  (setq eglot-autoshutdown t)
  (setq completion-category-overrides '((eglot (styles orderless basic))))
  (setq eldoc-echo-area-use-multiline-p nil
        eglot-confirm-server-initiated-edits nil))

;; Documentation Display
(use-package eldoc-box
  :after eglot
  :config
  (setq eldoc-box-cleanup-interval 0.3
        eldoc-box-max-pixel-width 800
        eldoc-box-max-pixel-height 400)
  (eldoc-box-hover-mode 1))

;; Project Management
(use-package projectile
  :config
  (projectile-mode +1)
  (setq projectile-project-root-files '(".git/")))

;; Version Control
(use-package magit
  :commands magit-status
  :config
  ;; don't prompt to save unsaved buffers
  (setq magit-save-repository-buffers nil))

;; Development Tools
(use-package envrc
  :hook (after-init . envrc-global-mode))

(use-package realgud)
(use-package realgud-node-inspect)

(use-package hl-todo
  :hook (prog-mode . hl-todo-mode)
  :config
  (setq hl-todo-keyword-faces
    '(("TODO"   . "#B52634")    ; Green
      ("FIXME"  . "#FF9900")    ; Orange-yellow
      ("DEBUG"  . "#0088FF")    ; Blue
      ("WARN"   . "#FF7F4F")))) ; Warm orange

(use-package gptel
  :config
	(gptel-make-ollama "Ollama"
    :host "localhost:11434"
    :stream t
    :models '(llama3.1:latest))
  (setq
    gptel-model 'claude-3-5-sonnet-20241022
    gptel-backend
    (gptel-make-anthropic "Claude"
      :stream t :key "<redacted>")))

;; Language Support
(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package rust-mode
  :hook (rust-mode . eglot-ensure))

(use-package typescript-mode
  :hook (typescript-mode . eglot-ensure))

(use-package nix-mode)

(use-package markdown-mode)

;;; Keybindings and UI Enhancements ------------------------

;; Which Key
(use-package which-key
  :init
  (setq which-key-sort-order 'which-key-key-order-alpha
        which-key-add-column-padding 1
        which-key-max-display-columns nil
        which-key-min-display-lines 6
        which-key-idle-delay 0.5)
  :config
  (which-key-mode))

;; Theme
(use-package gruber-darker-theme)
(use-package doom-themes
  :config
  (load-theme 'doom-badger t)
  (doom-themes-visual-bell-config))

;; Utility Functions
(defun important-buffer-p (buffer)
  "Return t if BUFFER is an important buffer that shouldn't be killed."
  (or (string-match-p "\\`\\*scratch\\*\\'" (buffer-name buffer))
      (string-match-p "\\`\\*Messages\\*\\'" (buffer-name buffer))
      (string-match-p "\\`\\*dashboard\\*\\'" (buffer-name buffer))
      (string-match-p "\\` \\*Minibuf-[0-9]+\\*\\'" (buffer-name buffer))
      (string-match-p "\\`\\*echo-area\\*\\'" (buffer-name buffer))))

(defun kill-all-buffers ()
  "Kill all buffers except important buffers."
  (interactive)
  (dolist (buffer (buffer-list))
    (unless (important-buffer-p buffer)
      (kill-buffer buffer)))
  (message "Killed all buffers"))

(defun kill-other-buffers ()
  "Kill all buffers except the current one and important buffers."
  (interactive)
  (let ((current (current-buffer)))
    (dolist (buffer (buffer-list))
      (unless (or (eq buffer current)
                  (important-buffer-p buffer))
        (kill-buffer buffer))))
  (message "Killed other buffers"))

;; Global Keybindings
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(evil-global-set-key 'insert (kbd "C-SPC") #'completion-at-point)

;; Evil Global Bindings
(evil-global-set-key 'normal (kbd "gd") 'xref-find-definitions)
(evil-global-set-key 'normal (kbd "gD") 'xref-find-references)
(evil-global-set-key 'normal (kbd "gs/") 'consult-line)
(evil-global-set-key 'normal (kbd "K") 'eldoc-box-help-at-point)

;; Mode-specific Bindings
(with-eval-after-load 'eglot
  (evil-define-key 'normal eglot-mode-map
    (kbd "gd") 'xref-find-definitions
    (kbd "gD") 'xref-find-references
    (kbd "gs/") 'consult-line
    (kbd "K") 'eldoc-box-help-at-point))

;; Leader Key Bindings
(use-package evil-leader
  :config
  (evil-leader/set-leader "SPC")
  (global-evil-leader-mode)

  (which-key-add-key-based-replacements
    "SPC b" "buffers"
    "SPC w" "windows"
    "SPC p" "project"
    "SPC g" "git"
    "SPC h" "help"
    "SPC t" "toggle"
    "SPC TAB" "tabs"
		"SPC l" "ai")

  (evil-leader/set-key
    ;; Files
    "x" 'scratch-buffer
    "." 'find-file
    "SPC" 'project-find-file
    "/" 'consult-ripgrep
    
    ;; Buffers
    "<" 'consult-buffer
    "bk" 'kill-current-buffer
    "bK" 'kill-all-buffers
    "bo" 'kill-other-buffers
    "bn" 'evil-next-buffer
    "bp" 'evil-previous-buffer
    
    ;; Windows
    "wv" 'split-window-right
    "ws" 'split-window-below
    "wh" 'evil-window-left
    "wl" 'evil-window-right
    "wk" 'evil-window-up
    "wj" 'evil-window-down
    "wq" 'delete-window

    ;; Tabs
    "TAB TAB" 'tab-switch
    "TAB n" 'tab-next
    "TAB p" 'tab-previous
    "TAB t" 'tab-new
    "TAB q" 'tab-close
    "TAB b" 'tab-bar-mode

    ;; Code
    "ca" 'eglot-code-actions
    "cf" 'eglot-format-buffer
    "cc" 'compile
    
    ;; Project
    "pf" 'projectile-find-file
    "pp" 'projectile-switch-project
    "pi" 'projectile-clear-known-projects
    "pa" 'projectile-add-known-project
    "pd" 'projectile-remove-known-project
    
    ;; Git
    "gg" 'magit-status
    "ghb" 'magit-blame

		;; ai :o
		"ll" 'gptel
		"ls" 'gptel-send
		"lm" 'gptel-menu

    ;; Toggle features
    "tn" 'display-line-numbers-mode
    "tm" 'toggle-frame-maximized
    "tf" 'toggle-frame-fullscreen

    ;; Help
    "hf" 'describe-function
    "hv" 'describe-variable
    "hk" 'describe-key
    "hb" 'describe-bindings
    "hi" 'info
    "ht" 'consult-theme))
