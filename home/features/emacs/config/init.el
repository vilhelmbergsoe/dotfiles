;;; Core Emacs Settings ----------------------------------------

;; DEBUGGING
;; (add-to-list 'load-path "~/.emacs.d/manual-packages")
;; (require 'dash)

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

(setq-default indent-tabs-mode nil)
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

(use-package avy)

(use-package evil-collection
  :after evil
  :config
  (setq evil-collection-mode-list  ; mainly to remove K->eldoc-doc-buffer
        (remove 'eglot evil-collection-mode-list))
  (setq evil-want-integration t)
  (evil-collection-init)
	:bind (:map evil-normal-state-map
              ("gd" . 'xref-find-definitions)
              ("gD" . 'xref-find-references)
              ("g/" . 'avy-goto-char-timer)
              ("K" . 'eldoc-box-help-at-point)))

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
  ;; (corfu-auto t) ; enable for autocompletion
  (corfu-separator ?\s)
  (corfu-quit-at-boundary nil)
  (corfu-quit-no-match nil)
  (corfu-preview-current nil)
  (corfu-preselect 'prompt)
  (corfu-on-exact-match nil)
  :init
  (global-corfu-mode)
	(corfu-popupinfo-mode)
  :bind (:map corfu-map
              ("C-n" . corfu-next)
              ("C-p" . corfu-previous)
              ("C-h" . corfu-popupinfo-toggle)))

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


;; Project Management
(use-package projectile
  :config
  (projectile-mode +1)
  (setq projectile-project-root-files '(".git/")))

;; Version Control
(use-package magit
  :commands magit-status
  :config
  ;; (remove-hook 'magit-status-sections-hook 'magit-insert-status-headers)
  (remove-hook 'magit-status-sections-hook 'magit-insert-tags-header)
  (remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-pushremote)
  (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-pushremote)
  (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-upstream)
  (remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-upstream-or-recent)
  ;; remove annoying forge topics in status buffer
  (setq forge-add-default-sections nil)
  ;; only refresh active magit buffer
  (setq magit-refresh-status-buffer nil)
  ;; don't prompt to save unsaved buffers
  (setq magit-save-repository-buffers nil))

(use-package forge
  :after magit)

;; Development Tools
(use-package envrc
  :hook (after-init . envrc-global-mode))

(use-package hl-todo
  :hook (prog-mode . hl-todo-mode)
  :config
  (setq hl-todo-keyword-faces
    '(("TODO"   . "#B52634")    ; Green
      ("FIXME"  . "#FF9900")    ; Orange-yellow
      ("DEBUG"  . "#0088FF")    ; Blue
      ("WARN"   . "#FF7F4F")))) ; Warm orange

(use-package vterm
  :ensure t)

(use-package gptel
  :config
  (gptel-make-gemini "Gemini"
    :stream t
    :key (auth-source-pick-first-password :host "gemini.google.com"))
  (gptel-make-anthropic "Claude"
    :stream t
	  :key (auth-source-pick-first-password :host "anthropic.com"))

  ;; --- Filesystem Tools ---

  (gptel-make-tool
   :name "read_file"
   :function (lambda (filepath)
               (unless (file-exists-p filepath)
                 (error "error: file %s does not exist." filepath))
               (with-temp-buffer
                 (insert-file-contents filepath)
                 (buffer-string)))
   :description "Reads the entire content of a specified file."
   :args (list '(:name "filepath" :type string :description "The full path to the file."))
   :category "filesystem")

  (gptel-make-tool
   :name "write_file"
   :function (lambda (filepath content)
               (let ((dir (file-name-directory filepath)))
                 (unless (file-directory-p dir)
                   (make-directory dir t))) ; Create parent directories if needed
               (with-temp-buffer
                 (insert content)
                 (write-file filepath))
               (format "File %s written successfully." filepath))
   :description "Writes (or overwrites) the given content to the specified file. Creates directories if needed."
   :args (list '(:name "filepath" :type string :description "The full path to the file.")
               '(:name "content" :type string :description "The text to write."))
   :category "filesystem")

  (gptel-make-tool
   :name "make_directory"
   :function (lambda (path)
               (make-directory path t) ; Create parent directories if needed
               (format "Directory %s created successfully." path))
   :description "Creates a new directory at the specified path, including parent directories if necessary."
   :args (list '(:name "path" :type string :description "The directory path to create."))
   :category "filesystem")

  (gptel-make-tool
   :name "list_directory"
   :function (lambda (path)
               (unless (file-directory-p path)
                 (error "error: path %s is not a directory or does not exist." path))
               (directory-files path nil "[^.]")) ; List non-hidden files/dirs
   :description "Lists the files and subdirectories within a specified directory."
   :args (list '(:name "path" :type string :description "The directory path to list."))
   :category "filesystem")

  ;; --- Web Tools ---



  (gptel-make-tool
   :name "read_url"
    :function (lambda (url)
                (require 'url) ; Ensure url library is loaded
                (let ((buffer (url-retrieve-synchronously url))
                      (content nil)) ; Initialize content variable
                  (if (and buffer (buffer-live-p buffer))
                      (with-current-buffer buffer
                        (goto-char (or url-http-end-of-headers (point-min))) ; Go past headers
                        (setq content (buffer-substring-no-properties (point) (point-max))) ; Get body content
                        (kill-buffer (current-buffer))
                        ;; Return content wrapped in a plist (JSON object)
                        (list :content content))
                    (error "error: failed to retrieve URL %s" url))))
    :description "Fetches and returns the textual content (body) of a given URL as a JSON object with a 'content' key."
    :args (list '(:name "url" :type string :description "The URL to fetch."))
    :category "web")

  ;; --- Emacs Tools ---

  (gptel-make-tool
   :name "read_buffer"
   :function (lambda (buffer_name)
               (let ((buffer (get-buffer buffer_name)))
                 (unless (buffer-live-p buffer)
                   (error "error: buffer %s is not live." buffer_name))
                 (with-current-buffer buffer
                   (buffer-substring-no-properties (point-min) (point-max)))))
   :description "Returns the entire content of a specified live Emacs buffer."
   :args (list '(:name "buffer_name" :type string :description "The name of the buffer."))
   :category "emacs")

  (gptel-make-tool
   :name "list_buffers"
   :function (lambda ()
               (mapcar #'buffer-name (buffer-list)))
   :description "Returns a list of names of all currently live Emacs buffers."
   :args nil ; No arguments
   :category "emacs")

  (gptel-make-tool
   :name "replace_buffer_content"
   :function (lambda (buffer_name content)
               (let ((buffer (get-buffer buffer_name)))
                 (unless (buffer-live-p buffer)
                   (error "error: buffer %s is not live." buffer_name))
                 (with-current-buffer buffer
                   (erase-buffer)
                   (insert content))
                 (format "Content of buffer %s replaced." buffer_name)))
   :description "Replaces the entire content of a specified buffer with new content. Use with caution."
   :args (list '(:name "buffer_name" :type string :description "The name of the buffer.")
               '(:name "content" :type string :description "The new content for the buffer."))
   :category "emacs")

  ;; --- Misc Tools ---

  (gptel-make-tool
   :name "search_project"
   :function (lambda (query)
               (require 'projectile)
               (let* ((project-root (projectile-project-root))
                      (default-directory (or project-root default-directory))
                      ;; Ensure rg is in PATH. Adjust command if needed.
                      (command (format "rg --no-heading --color never --line-number %s ." (shell-quote-argument query))))
                 (if project-root
                     (shell-command-to-string command)
                   (error "error: Not inside a projectile project."))))
   :description "Searches for a string within the current project using ripgrep (rg). Requires 'rg' to be installed and in PATH."
   :args (list '(:name "query" :type string :description "The string to search for."))
   :category "misc"))

;; Language Support
(use-package eglot
  :ensure nil
  :hook ((prog-mode . eglot-ensure))
  :config
  (add-to-list 'eglot-server-programs
               '(zig-ts-mode . ("zls"))
               '(nix-ts-mode . ("nixd")))
  (add-hook 'eglot-managed-mode-hook (lambda () (eglot-inlay-hints-mode -1))) 
  (setq eglot-autoshutdown t)
  (setq completion-category-overrides '((eglot (styles orderless basic))))
  (setq eldoc-echo-area-use-multiline-p nil
        eglot-confirm-server-initiated-edits nil))

;; (use-package eldoc-box
;;   :config
;;   (setq eldoc-box-cleanup-interval 0.3
;;         eldoc-box-max-pixel-width 800
;;         eldoc-box-max-pixel-height 400)
;;   :bind (:map eldoc-box-hover-mode-map
;;               ("C-n" . eldoc-box-scroll-up)
;;               ("C-p" . eldoc-box-scroll-down)))

(use-package eldoc-box
  :config
  (setq eldoc-box-cleanup-interval 0.3
        eldoc-box-max-pixel-width 800
        eldoc-box-max-pixel-height 400))

(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (setq treesit-extra-load-path '("~/.emacs.d/tree-sitter/"))
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package rust-ts-mode
  :ensure nil)

(use-package zig-ts-mode)

(use-package typescript-ts-mode
  :ensure nil)

(use-package nix-ts-mode)

(use-package just-ts-mode)

(use-package markdown-ts-mode)

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
(defun my/save-last-theme (theme)
  "Save the last selected theme to a file."
  (setq my/last-theme theme)
  (customize-save-variable 'my/last-theme theme))

(defun my/load-last-theme ()
  "Load the last saved theme."
  (when (boundp 'my/last-theme)
    (load-theme my/last-theme t)))

(advice-add 'consult-theme :after (lambda (theme) (my/save-last-theme theme)))

(use-package gruber-darker-theme)
(use-package doom-themes
  :config
  ;; DEFAULT THEME
  ;; (load-theme 'doom-badger t)
  (my/load-last-theme)
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
    "wo" 'delete-other-windows

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
    "pr" 'projectile-remove-known-project
    
    ;; Git
    "gg" 'magit-status
    "ghb" 'magit-blame

		;; ai :o
		"ll" 'gptel
		"lm" 'gptel-menu
		"ls" 'gptel-send
		"la" 'gptel-abort

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

;; Tabs bindings
;; (with-eval-after-load 'magit
;;   (define-key magit-status-mode-map (kbd "M-1") nil)
;;   (define-key magit-status-mode-map (kbd "M-2") nil)
;;   (define-key magit-status-mode-map (kbd "M-3") nil)
;;   (define-key magit-status-mode-map (kbd "M-4") nil))

(global-set-key (kbd "M-C-[") 'tab-bar-move-tab-backward)
(global-set-key (kbd "M-C-]") 'tab-bar-move-tab)

(global-set-key (kbd "M-[") 'tab-previous)
(global-set-key (kbd "M-]") 'tab-next)

(dotimes (i 9)
  (global-set-key (kbd (format "M-%d" (1+ i)))
                  `(lambda () (interactive)
                     (tab-bar-select-tab ,(1+ i)))))
