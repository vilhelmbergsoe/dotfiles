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
                         ("elpa" . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
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
  :config
  (marginalia-mode))

(use-package consult)

(use-package embark
  :ensure t

  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ;; ("C-;" . embark-dwim)        ;; good alternative: M-.
   ))

(use-package embark-consult
  :ensure t ; only need to install it, embark loads it after consult if found
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

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
  (remove-hook 'magit-refs-sections-hook 'magit-insert-tags)
  (remove-hook 'magit-status-sections-hook 'magit-insert-tags-header)
  (remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-pushremote)
  (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-pushremote)
  (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-upstream)
  (remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-upstream-or-recent)
  ;; remove annoying forge topics in status buffer
  (setq forge-add-default-sections nil)
  ;; (should) fix evil binding issue: (https://github.com/emacs-evil/evil-collection/issues/543)
  (setq forge-add-default-bindings nil)
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
    '(("TODO"   . "#B52634")    ; Red
      ("FIXME"  . "#FF9900")    ; Orange-yellow
      ("DEBUG"  . "#0088FF")    ; Blue
      ("NOTE"  . "#008812")     ; Green
      ("WARN"   . "#FF7F4F")))) ; Warm orange

(use-package gptel
  :config
  (gptel-make-gemini "Gemini"
    :stream t
    :key (auth-source-pick-first-password :host "gemini.google.com"))
  (gptel-make-anthropic "Claude"
    :stream t
	  :key (auth-source-pick-first-password :host "anthropic.com"))
  (gptel-make-tool
    :name "eval_elisp"
    :function (lambda (elisp_code)
                (let ((result "<no result>")
                    (timeout 2))
                (condition-case err
                    (setq result
                            (with-timeout (timeout (error "Evaluation timed out"))
                            (prin1-to-string (eval (read elisp_code)))))
                    (error (setq result (format "Error: %s" err))))
                result))
    :description "Evaluate Emacs Lisp code and return the result (2s timeout)."
    :args (list '(:name "elisp_code" :type string :description "Code to eval."))
    :category "emacs"))
;; magit commit message generation
(use-package gptel-magit
  :ensure t
  :hook (magit-mode . gptel-magit-install))

;; Language Support
(use-package eglot
  :ensure nil
  :hook ((prog-mode . eglot-ensure))
  :config
  (add-to-list 'eglot-server-programs '(rust-ts-mode . ("rust-analyzer")))
  (add-to-list 'eglot-server-programs '(zig-ts-mode . ("zls")))
  (add-to-list 'eglot-server-programs '(nix-ts-mode . ("nixd")))
  (add-hook 'eglot-managed-mode-hook (lambda () (eglot-inlay-hints-mode -1))) 
  (fset #'jsonrpc--log-event #'ignore)
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
(use-package ef-themes)
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

;; Kill buffer of exit'ed ansi-term process
(defadvice term-sentinel (around my-advice-term-sentinel (proc msg))
  (if (memq (process-status proc) '(signal exit))
      (let ((buffer (process-buffer proc)))
        ad-do-it
        (kill-buffer buffer))
    ad-do-it))
(ad-activate 'term-sentinel)

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
    "pi" 'projectile-cleanup-known-projects
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

    ;; Nix utility
    "ni" 'nix-env-activate-packages
    "nr" 'nix-env-reset

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

(global-set-key (kbd "M-g i") 'consult-imenu)

(dotimes (i 9)
  (global-set-key (kbd (format "M-%d" (1+ i)))
                  `(lambda () (interactive)
                     (tab-bar-select-tab ,(1+ i)))))

;; Nix utility
(defvar nix-env-original-path (getenv "PATH")
  "The original value of the `PATH` environment variable.")

(defvar nix-env-original-exec-path exec-path
  "The original value of Emacs's `exec-path`.")

(defvar nix-env-active-paths nil
  "A list of directory paths currently injected by `nix-env-activate-packages`.")

(defun nix-env-activate-packages (packages)
  "Activate a Nix development environment for PACKAGES.
PACKAGES is a list of Nix package names (e.g., '(\"cowsay\" \"rust-analyzer\")).
This function fetches the environment using `nix print-dev-env`, updates
Emacs's `exec-path` and the `PATH` environment variable.
Any previously active Nix environments are reset first.

Example: (nix-env-activate-packages '(\"cowsay\" \"rust-analyzer\"))"
  (interactive
   (list (split-string
          (read-string "Nix packages (space-separated): " "")
          " " t)))

  (message "nix-env: Activating packages: %s..." (string-join packages " "))

  ;; Clean up any previous environment injection.
  (when nix-env-active-paths
    (message "nix-env: Cleaning up previous environment")
    (nix-env-reset))

  ;; Construct and run the Nix command.
  (let* ((nix-expr
          (format "with import <nixpkgs> {}; mkShell { buildInputs = [ %s ]; }"
                  (string-join packages " ")))
         (cmd (format "NIXPKGS_ALLOW_UNFREE=1 nix print-dev-env --impure --expr '%s'" nix-expr))
         (command-output nil))


    ;; Capture stdout and stderr, checking for non-zero exit.
    (with-temp-buffer
      (setq exit-code (process-file-shell-command cmd nil (current-buffer) t))
      (setq command-output (buffer-string))) ; Get the entire output string

    (unless (zerop exit-code)
      ;; If failed, create a new persistent buffer to display the output.
      (let ((failure-buffer (get-buffer-create "*Nix-Env Command Output*")))
        (with-current-buffer failure-buffer
          ;; Temporarily make writable before modifying
          (setq-local buffer-read-only nil)
          (erase-buffer) ; Clear any previous content
          (insert (format "nix-env: 'nix print-dev-env' failed with exit code %s.\n\n" exit-code))
          (insert (format "Command executed:\n%s\n\n" cmd))
          (insert "Full command output:\n")
          (insert command-output)
          (setq-local buffer-read-only t) ; Set back to read-only
          (goto-char (point-min)) ; Go to start for easy viewing
          (view-mode 1)) ; Enable view-mode for 'q' to kill buffer

        ;; Pop the failure buffer to a window, preferably without splitting.
        (pop-to-buffer failure-buffer)
        (error "nix-env: Command failed. See buffer '%s' for details." (buffer-name failure-buffer))))

    ;; Parse Nix output to extract the PATH.
    (let* ((env-lines (split-string command-output "\n"))
           (path-line (seq-find (lambda (line) (string-prefix-p "PATH='" line)) env-lines))
           (extracted-paths nil))

      (unless path-line
        (error "nix-env: Failed to extract PATH from output.
Command: %s
Output:\n%s"
               cmd command-output))

      ;; Extract and split the path string.
      (setq extracted-paths
            (split-string
             (string-trim (replace-regexp-in-string "^PATH='\\|'$" "" path-line))
             path-separator))

      ;; Reverse paths to maintain Nix's intended precedence when prepending.
      (setq nix-env-active-paths (reverse extracted-paths))

      ;; Apply new PATH entries.
      (dolist (path-entry nix-env-active-paths)
        (add-to-list 'exec-path path-entry)
        (setenv "PATH" (concat path-entry path-separator (getenv "PATH"))))

      (message "nix-env: Activated packages: %s" (string-join packages " ")))))

(defun nix-env-reset ()
  "Restore `exec-path` and `PATH` to their original values.
Clears any Nix environment injected by `nix-env-activate-packages`."
  (interactive)
  ;; (message "nix-env: Restoring original environment...")
  (setq exec-path nix-env-original-exec-path)
  (setenv "PATH" nix-env-original-path)
  (setq nix-env-active-paths nil)
  (message "nix-env: Original environment restored"))
