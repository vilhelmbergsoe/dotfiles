;;; init.el --- My Emacs Configuration -*- lexical-binding: t; -*-

;; PACKAGE MANAGEMENT & BOOTSTRAP
(require 'package)
(setq package-archives
      '(("melpa"  . "https://melpa.org/packages/")
        ("elpa"   . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; PERFORMANCE
(setq gc-cons-threshold         most-positive-fixnum
      read-process-output-max   (* 1024 1024))

;; https://jackjamison.net/blog/emacs-garbage-collection/
(defun my-minibuffer-setup-hook ()
  (setq gc-cons-threshold most-positive-fixnum))
(defun my-minibuffer-exit-hook ()
  (setq gc-cons-threshold (* 100 1024 1024)))

(add-hook 'minibuffer-setup-hook #'my-minibuffer-setup-hook)
(add-hook 'minibuffer-exit-hook #'my-minibuffer-exit-hook)

(run-with-idle-timer 1.2 t 'garbage-collect)

;; UI
(setq inhibit-startup-screen    t
      initial-buffer-choice     t
      native-comp-async-report-warnings-errors nil)
(tool-bar-mode   -1)
(menu-bar-mode   -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)
(with-eval-after-load 'display-line-numbers
  (setq display-line-numbers-type 'relative))
;; Relative numbers make magit's big buffers laggy; disable there.
(dolist (hook '(magit-mode-hook magit-section-mode-hook))
  (add-hook hook (lambda () (display-line-numbers-mode -1))))
(setq initial-scratch-message
      (concat
       ";                __\n"
       ";            .--()°'.'\n"
       ";           '|, . ,'\n"
       ";            !_-(_\\\n\n"))

;; FILE BEHAVIOR
(setq create-lockfiles   nil
      make-backup-files   nil
      auto-save-default   nil
      indent-tabs-mode    nil
      tab-width           2)

;; MAC KEY MODIFIERS
(when (eq system-type 'darwin)
  (setq mac-option-key-is-meta nil
        mac-command-key-is-meta t
        mac-command-modifier  'meta
        mac-option-modifier   'none))

;; EDITOR FOUNDATION
(use-package undo-fu
  :ensure t
  :defer t)

(use-package origami
  :ensure t
  :hook (prog-mode . origami-mode))

(use-package avy
  :ensure t
  :defer t)

;; EVIL
;; NOTE: Instant ESC in minibuffer relies on the way I've setup evil / evil-collection
(use-package evil
  :init
  (setq evil-want-keybinding nil
        evil-want-C-u-scroll t
        evil-undo-system 'undo-fu)
  :config
  (evil-mode 1))

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
  :ensure t
  :config
  (evil-commentary-mode))

;; COMPLETION FRAMEWORK
(use-package vertico
  :ensure t
  :init (vertico-mode)
  :custom (vertico-count 20))

(use-package orderless
  :ensure t
  :custom
  (completion-styles            '(orderless basic)
   completion-category-defaults  nil
   completion-category-overrides '((file (styles . (partial-completion))))))

(use-package marginalia
  :ensure t
  :after vertico
  :config (marginalia-mode))

(use-package consult
  :ensure t)

(use-package embark
  :ensure t
  :bind (("C-." . embark-act)))

(use-package embark-consult
  :ensure t
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))

(use-package savehist
  :ensure nil
  :init (savehist-mode))

(use-package corfu
  :ensure t
  :hook (prog-mode . corfu-mode)
  :custom
  (corfu-separator         ?\s)
  (corfu-quit-at-boundary  t)
  (corfu-quit-no-match     nil)
  (corfu-preview-current   nil)
  (corfu-preselect         'prompt)
  (corfu-on-exact-match    nil)
  :bind (:map corfu-map
              ("C-n" . corfu-next)
              ("C-p" . corfu-previous)
              ("C-h" . corfu-popupinfo-toggle))
  :config
  (corfu-popupinfo-mode))

(use-package cape
  :ensure t
  :after corfu
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  (add-to-list 'completion-at-point-functions #'tags-completion-at-point-function))

;; KIND-ICON (commented out for later)
;; (use-package kind-icon
;;   :after corfu
;;   :custom
;;   (kind-icon-default-face 'corfu-default)
;;   :config
;;   (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

;; PROJECT MANAGEMENT
(use-package projectile
  :ensure t
  :config
  (projectile-mode +1)
  (setq projectile-project-root-files '(".git/")))

;; VERSION CONTROL
(use-package magit
  :ensure t
  :commands magit-status
  :config
  (remove-hook 'magit-refs-sections-hook   'magit-insert-tags)
  (remove-hook 'magit-status-sections-hook 'magit-insert-tags-header)
  (remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-pushremote)
  (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-pushremote)
  (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-upstream)
  (remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-upstream-or-recent)
  (setq forge-add-default-sections nil
        forge-add-default-bindings nil
        magit-refresh-status-buffer nil
        magit-save-repository-buffers nil))

(use-package fl
  :ensure t
  :after magit)

;; (use-package forge
;;   :ensure t
;;   :after magit
;;   :config
;;   (setq forge-add-pullreq-refspec nil))

(use-package majutsu
  :ensure t
  :commands (majutsu majutsu-log majutsu-dispatch)
  :config
  (require 'majutsu)
  (require 'majutsu-evil)
  (evil-define-key* 'normal majutsu-mode-map (kbd "g G") #'majutsu-git-transient))

;; DEVELOPMENT TOOLS
(use-package envrc
  :ensure t
  :hook (after-init . envrc-global-mode))

(use-package hl-todo
  :ensure t
  :hook (prog-mode . hl-todo-mode)
  :custom
  (hl-todo-keyword-faces
   '(("TODO"  . "#B52634")
     ("FIXME" . "#FF9900")
     ("DEBUG" . "#0088FF")
     ("NOTE"  . "#008812")
     ("WARN"  . "#FF7F4F"))))

(use-package gptel
  :ensure t
  :config
  (setq gptel-expert-commands t)
  (setq gptel-include-reasoning nil)
  (setq gptel-use-tools t)
  (setq gptel-default-mode 'org-mode)
  (setq gptel-backend
        (gptel-make-gemini "Gemini"
          :stream t
          :key    (auth-source-pick-first-password :host "gemini.google.com"))
        gptel-model 'gemini-flash-latest)
  (gptel-make-openai "OpenRouter"
    :host "openrouter.ai"
    :endpoint "/api/v1/chat/completions"
    :stream t
    :key (auth-source-pick-first-password :host "api.openrouter.ai") 
    :models '(deepseek/deepseek-v4-flash deepseek/deepseek-v4-pro))
  (gptel-make-deepseek "DeepSeek"
    :stream t
    :key (auth-source-pick-first-password :host "api.deepseek.com"))
    (gptel-make-gh-copilot "Copilot")
  (gptel-make-openai "llama-cpp"
    :stream t
    :protocol "http"
    :host "localhost:8080"
    :models '(test))
  (gptel-make-anthropic "Claude"
    :stream t
    :key    (auth-source-pick-first-password :host "anthropic.com"))
  (add-hook 'gptel-mode-hook #'visual-line-mode))

(use-package gptel-agent
  :ensure t
  :config
  (add-to-list 'gptel-agent-dirs (expand-file-name "gptel-agents" user-emacs-directory)))

(with-eval-after-load 'gptel
  (gptel-make-tool
   :name "StatAnalysis"
   :async t
   :confirm nil
   :include nil
   :function (lambda (callback data code)
               (let* ((data-path (when (and data (not (string-empty-p data)))
                                   (expand-file-name data)))
                      (script (make-temp-file "stat-" nil ".py"))
                      (out-buf (generate-new-buffer " *stat-output*")))
                 (with-temp-file script
                   (if data-path
                       (insert (format "import pandas as pd, scipy.stats as stats, statsmodels.api as sm, numpy as np
df = pd.read_csv('%s')
%s" data-path code))
                     (insert (format "import pandas as pd, scipy.stats as stats, statsmodels.api as sm, numpy as np
%s" code))))
                 (let ((default-directory temporary-file-directory))
                   (make-process
                    :name "gptel-stat"
                    :buffer out-buf
                    :command (list "nix-shell" "-p" "python3Packages.pandas" "python3Packages.scipy" "python3Packages.statsmodels" "--run" (format "python3 %s" script))
                    :sentinel (lambda (proc _ev)
                                (when (eq (process-status proc) 'exit)
                                  (let ((exit-status (process-exit-status proc))
                                        (res (with-current-buffer (process-buffer proc) (buffer-string))))
                                    (kill-buffer (process-buffer proc))
                                    (delete-file script)
                                    (if (zerop exit-status)
                                        (funcall callback res)
                                      (funcall callback (format "Statistical analysis failed (exit code %d):\n%s" exit-status res))))))))))
   :description "Run statistical analysis or data processing. Sandboxed in /tmp. This is the ONLY PERMITTED way to process data. If 'data' path is provided, it is loaded into 'df'. PRINT results to STDOUT. NEVER create files in the project directory; use /tmp for all intermediate artifacts."
   :args '((:name "data" :type string) (:name "code" :type string)))

  (gptel-make-tool
   :name "PlotData"
   :async t
   :confirm nil
   :include nil
   :function (lambda (callback data code)
               (let* ((data-path (when (and data (not (string-empty-p data)))
                                   (expand-file-name data)))
                      (png (make-temp-file "plot-" nil ".png"))
                      (script (make-temp-file "plot-script-" nil ".py"))
                      (out-buf (generate-new-buffer " *plot-output*")))
                 (with-temp-file script
                   (insert (format "import pandas as pd, seaborn as sns, matplotlib.pyplot as plt, numpy as np
sns.set_theme()
%s
%s
plt.savefig('%s', bbox_inches='tight')"
                                   (if data-path (format "df = pd.read_csv('%s')" data-path) "")
                                   code png)))
                 (let ((default-directory temporary-file-directory))
                   (make-process
                    :name "gptel-plot"
                    :buffer out-buf
                    :command (list "nix-shell" "-p" "python3Packages.pandas" "python3Packages.seaborn" "python3Packages.matplotlib" "python3Packages.numpy" "--run" (format "python3 %s" script))
                    :sentinel (lambda (proc _ev)
                                (when (eq (process-status proc) 'exit)
                                  (let ((exit-status (process-exit-status proc))
                                        (out (with-current-buffer (process-buffer proc) (buffer-string))))
                                    (kill-buffer (process-buffer proc))
                                    (delete-file script)
                                    (if (and (zerop exit-status) (file-exists-p png))
                                        (funcall callback png)
                                      (funcall callback (format "Plotting failed (exit code %d):\n%s" exit-status out))))))))))
   :description "Plot CSV data to a PNG. Returns the path. Display EXACTLY as [[file:/path/to/plot.png]] without any quotes, code blocks, or extra formatting. Use this tool for all visualization. It is sandboxed in /tmp. NEVER use manual bash scripts for plotting."
   :args '((:name "data" :type string) (:name "code" :type string)))

  (add-hook 'gptel-post-response-functions
            (lambda (beg end)
              (when (derived-mode-p 'org-mode)
                (org-display-inline-images nil nil beg end)))))

(use-package vterm
  :hook (vterm-mode . (lambda () (display-line-numbers-mode -1))))

;; LANGUAGE SUPPORT
(use-package eglot
  :ensure t
  ;; NOTE: Automatically start language server on file enter
  ;; :hook (prog-mode . eglot-ensure)
  :custom
  (eglot-autoshutdown                         t)
  (completion-category-overrides              '((eglot (styles orderless basic))))
  (eldoc-echo-area-use-multiline-p            nil)
  (eglot-confirm-server-initiated-edits       nil)
  :config
  (add-to-list 'eglot-server-programs '(rust-ts-mode . ("rust-analyzer")))
  (add-to-list 'eglot-server-programs '(zig-ts-mode  . ("zls")))
  (add-to-list 'eglot-server-programs '(nix-ts-mode  . ("nixd")))
  (add-to-list 'eglot-server-programs '((neocaml-mode :language-id "ocaml") . ("ocamllsp")))
  (add-hook 'eglot-managed-mode-hook (lambda () (eglot-inlay-hints-mode -1)))
  (fset #'jsonrpc--log-event #'ignore))

(use-package eldoc-box
  :ensure t
  :after eglot
  :custom
  (eldoc-box-cleanup-interval    0.3)
  (eldoc-box-max-pixel-width     800)
  (eldoc-box-max-pixel-height    400)
  ;; down-up are reversed for some reason
  :bind (("M-p" . eldoc-box-scroll-down)
         ("M-n" . eldoc-box-scroll-up)))

(with-eval-after-load 'eglot
  (add-hook 'eglot-managed-mode-hook
            (lambda ()
              (flymake-mode -1)
              (flycheck-mode 1))))

(use-package flycheck
  :defer t
  :hook (prog-mode . flycheck-mode)
  :config
  ;; tiny shim instead of flycheck-eglot:
  (add-hook 'eglot-managed-mode-hook #'flycheck-mode))

(use-package treesit-auto
  :ensure t
  :defer t
  :custom
  (treesit-auto-install 'prompt)
  :config
  (setq treesit-extra-load-path '("~/.emacs.d/tree-sitter/"))
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(let ((alist
       '(("\\.ts\\'"   . typescript-ts-mode)
         ("\\.tsx\\'"  . typescript-ts-mode)
         ("\\.js\\'"   . js-ts-mode)
         ("\\.jsx\\'"  . js-jsx-ts-mode)
         ("\\.py\\'"   . python-mode)
         ("\\.rs\\'"   . rust-ts-mode)
         ("\\.c\\'"    . c-ts-mode)
         ("\\.cpp\\'"  . c++-ts-mode)
         ("\\.h\\'"    . c-ts-mode)
         ("\\.hpp\\'"  . c++-ts-mode)
         ("\\.zig\\'"  . zig-ts-mode)
         ("\\.nix\\'"  . nix-ts-mode)
         ("\\.just\\'" . just-ts-mode)
         ("\\.el\\'"   . emacs-lisp-mode)
         ("\\.go\\'"   . go-ts-mode)
         ("\\.java\\'" . java-ts-mode)
         ("\\.php\\'"  . php-ts-mode)
         ("\\.lua\\'"  . lua-ts-mode)
         ("\\.sh\\'"   . sh-mode)
         ("\\.rb\\'"   . ruby-mode)
         ("\\.md\\'"   . gfm-mode)
         ("\\.typ\\'"  . typst-ts-mode)
         ("\\.tex\\'"  . tex-mode)
         ("\\.org\\'"  . org-mode)
         ("\\.json\\'" . json-ts-mode)
         ("\\.yaml\\'" . yaml-ts-mode)
         ("\\.yml\\'"  . yaml-ts-mode)
         ("\\.html?\\'" . html-mode)
         ("\\.css\\'"  . css-ts-mode))))
  (dolist (entry alist)
    (add-to-list 'auto-mode-alist entry)))

(use-package dumb-jump
  :ensure t
  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
  ;; NOTE: dumb-jump will default to git-grep if in a git repo, which
  ;; is faster but not always as good as ripgrep, so we force it
  ;; (setq dumb-jump-prefer-searcher 'rg)
  (setq dumb-jump-force-searcher 'rg))

;; MAJOR/MINOR-MODE STUBS (built-in or ts-modes)
;; (use-package rust-ts-mode       :ensure t :defer t)
;; (use-package typescript-ts-mode :ensure t :defer t)
;; (use-package zig-ts-mode        :ensure t :defer t)
(use-package nix-ts-mode        :ensure t :defer t)
(use-package just-ts-mode       :ensure t :defer t)
(use-package typst-ts-mode      :ensure t :defer t)
(use-package ocaml-eglot        :ensure t :defer t
  :after neocaml
  :hook
  (neocaml-mode . ocaml-eglot)
  (ocaml-eglot . eglot-ensure))
(use-package neocaml            :ensure f :defer t
  :vc (:url "https://github.com/bbatsov/neocaml" :rev :newest))
(use-package markdown-mode      :ensure t :defer t
  :init (setq markdown-command "pandoc --from=markdown --to=html5 --mathml"))

(use-package tex
  :ensure auctex
  :defer t
  :config
  (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq TeX-command-default "LaTeXmk")
  (setq TeX-view-program-selection '((output-pdf "PDF Tools"))))

(use-package org
  :ensure nil
  :defer t
  :init
  (setq org-modules '(org-babel org-habit)))

;; NOTE: installed through nix
(use-package pdf-tools
  :ensure t
  :defer t
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :config
  (add-hook 'pdf-view-mode-hook #'auto-revert-mode)
  (add-hook 'pdf-view-mode-hook (lambda () (display-line-numbers-mode -1))))

;; KEYBINDINGS & UTILITIES
(use-package which-key
  :ensure t
  :custom
  (which-key-sort-order             'which-key-key-order-alpha)
  (which-key-add-column-padding     1)
  (which-key-max-display-columns    nil)
  (which-key-min-display-lines      6)
  (which-key-idle-delay             0.5)
  :config
  (which-key-mode))

(use-package evil-leader
  :ensure t
  :config
  (global-evil-leader-mode)
  (evil-leader/set-leader "SPC")
  (which-key-add-key-based-replacements
   "SPC b" "buffers"    "SPC w" "windows"
   "SPC p" "project"    "SPC g" "git"
   "SPC h" "help"       "SPC t" "toggle"
   "SPC l" "ai"         "SPC TAB" "tabs")
  (evil-leader/set-key
   ;; files & project
   "."   'find-file       "SPC"   'project-find-file
   "/"   'consult-ripgrep
   ;; buffers
   "<"   'consult-buffer    "bk"    'kill-current-buffer
   "bK"  'kill-all-buffers  "bo"    'kill-other-buffers
   "bn"  'evil-next-buffer  "bp"    'evil-previous-buffer
   "bs"  'save-some-buffers "b/"    'consult-line-multi
   "x" 'scratch-buffer
   ;; windows
   "wv"  'split-window-right "ws" 'split-window-below
   "wh"  'evil-window-left   "wl" 'evil-window-right
   "wk"  'evil-window-up     "wj" 'evil-window-down
   "wq"  'delete-window      "wo" 'delete-other-windows
   "w+"  'enlarge-window     "w>"  'enlarge-window-horizontally
   "w-"  'shrink-window      "w<"  'shrink-window-horizontally
   "w="  'balance-windows
   
   ;; tabs
   "TAB TAB" 'tab-switch   "TAB n" 'tab-next
   "TAB p"   'tab-previous "TAB t" 'tab-new
   "TAB q"   'tab-close    "TAB b" 'tab-bar-mode
   ;; code
   "ca"  'eglot-code-actions "cf" 'eglot-format-buffer
   "cc"  'compile
   ;; projectile
   "pf"  'projectile-find-file  "pp"  'projectile-switch-project
   "pi"  'projectile-cleanup-known-projects
   "pa"  'projectile-add-known-project
   "pr"  'projectile-remove-known-project
   ;; git
   "gg"  'magit-status     "ghb"   'magit-blame
   "jj"  'majutsu
   ;; ai
   "ll"  'gptel            "lm"    'gptel-menu
   "ls"  'gptel-send       "la"    'gptel-abort
   "lq"  'gptel-quick      "ln"    'gptel-agent

   ;; toggle
   "tn"  'display-line-numbers-mode
   "tm"  'toggle-frame-maximized
   "tf"  'toggle-frame-fullscreen
   "ts"  'flycheck-mode
   ;; nix
   "ni"  'nix-env-activate-packages
   "nr"  'nix-env-reset
   "ns"  'nix-env-status
   ;; help
   "hf"  'describe-function  "hv" 'describe-variable
   "hk"  'describe-key       "hb" 'describe-bindings
   "hi"  'info               "ht" 'consult-theme))

;; SIMPLE GLOBAL KEYS
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(evil-global-set-key 'insert (kbd "C-SPC") #'completion-at-point)
(global-set-key (kbd "M-g i") 'consult-imenu)
(global-set-key (kbd "M-C-[") 'tab-bar-move-tab-backward)
(global-set-key (kbd "M-C-]") 'tab-bar-move-tab)
(global-set-key (kbd "M-[") 'tab-previous)
(global-set-key (kbd "M-]") 'tab-next)

(dotimes (i 9)
  (global-set-key (kbd (format "M-%d" (1+ i)))
                  `(lambda () (interactive)
                     (tab-bar-select-tab ,(1+ i)))))

(use-package repeat
  :ensure nil
  :hook (after-init . repeat-mode))

(defvar-keymap window-resize-repeat-map
  :doc "Repeat map for window resizing."
  :repeat t
  ">" #'enlarge-window-horizontally
  "<" #'shrink-window-horizontally
  "+" #'enlarge-window
  "-" #'shrink-window)

;; FORGE: ON-DEMAND PR REF FETCHING
;; Replaces the wildcard +refs/pull/*/head:refs/pullreqs/* refspec. Fetches only
;; the specific ref when forge needs it (closed PRs, deleted source branches).
(defun my/forge--maybe-fetch-pullreq-ref (pullreq-id)
  (let* ((pr     (forge-get-pullreq pullreq-id))
         (number (oref pr number))
         (ref    (format "refs/pullreqs/%s" number)))
    (unless (magit-rev-verify ref)
      (magit-git "fetch" (oref (forge-get-repository pr) remote)
                 (format "+refs/pull/%s/head:%s" number ref)))))

(with-eval-after-load 'forge
  (advice-add 'forge-branch-pullreq    :before (lambda (pr)   (my/forge--maybe-fetch-pullreq-ref pr))   '((name . my/forge-fetch-pullreq-ref)))
  (advice-add 'forge-checkout-pullreq  :before (lambda (pr)   (my/forge--maybe-fetch-pullreq-ref pr))   '((name . my/forge-fetch-pullreq-ref)))
  (advice-add 'forge-checkout-worktree :before (lambda (_ pr) (my/forge--maybe-fetch-pullreq-ref pr))   '((name . my/forge-fetch-pullreq-ref))))

;; TERM BUFFER AUTO-KILL
(defun my/term-sentinel-around (orig-fn proc msg)
  "Kill TERM buffer when its process PROC exits or signals."
  (if (memq (process-status proc) '(exit signal))
      (let ((buf (process-buffer proc)))
        (funcall orig-fn proc msg)
        (when (buffer-live-p buf) (kill-buffer buf)))
    (funcall orig-fn proc msg)))
(advice-add 'term-sentinel :around #'my/term-sentinel-around)

;; BUFFER KILL PROTECTION
(defgroup my-buffers nil
  "Settings for buffer-killing utilities." :group 'emacs)

(defcustom my/important-buffer-regexps
  '("\\`\\*scratch\\*\\'" "\\`\\*Messages\\*\\'" "\\`\\*dashboard\\*\\'"
    "\\` \\*Minibuf-[0-9]+\\*\\'" "\\`\\*echo-area\\*\\'")
  "Regexps of buffers not to kill." :type '(repeat string) :group 'my-buffers)

(defun important-buffer-p (buffer)
  "Non-nil if BUFFER matches `my/important-buffer-regexps`."
  (when-let ((name (buffer-name buffer)))
    (seq-some (lambda (rx) (string-match-p rx name))
              my/important-buffer-regexps)))

;;;###autoload
(defun kill-all-buffers ()
  "Kill all buffers except those in `my/important-buffer-regexps`."
  (interactive)
  (dolist (buf (buffer-list))
    (unless (important-buffer-p buf) (kill-buffer buf)))
  (message "All non-important buffers killed."))

;;;###autoload
(defun kill-other-buffers ()
  "Kill other buffers except current and those in `my/important-buffer-regexps`."
  (interactive)
  (let ((current (current-buffer)))
    (dolist (buf (buffer-list))
      (unless (or (eq buf current) (important-buffer-p buf))
        (kill-buffer buf))))
  (message "Other non-important buffers killed."))

;; NIX ENVIRONMENT UTILITIES
(defvar nix-env-current-packages nil
  "A list of the currently active Nix packages.")
(defvar nix-env-original-path (getenv "PATH")
  "The original value of the `PATH` environment variable.")
(defvar nix-env-original-exec-path exec-path
  "The original value of Emacs's `exec-path`.")
(defvar nix-env-active-paths nil
  "A list of directory paths currently injected by `nix-env-activate-packages`.")

(defun nix-env-activate-packages (packages)
  "Asynchronously activate a Nix development environment for PACKAGES."
  (interactive
   (list (split-string
          (read-string "Nix packages (space-separated): " "")
          " " t)))

  (when nix-env-active-paths
    (nix-env-reset))

  (message "nix-env: Activating packages: %s..." (string-join packages ", "))

  (let* ((nix-expr (format "with import <nixpkgs> { config = { allowUnfree = true; }; }; mkShell { buildInputs = [ %s ]; }"
                           (string-join packages " ")))
         (output-buffer (get-buffer-create "*nix-env-output*"))
         (proc (start-process "nix-env" output-buffer
                              "nix" "print-dev-env" "--impure" "--expr" nix-expr)))
    (set-process-sentinel
     proc
     (lambda (proc msg)
       (let ((output-buf (process-buffer proc)))
         (unwind-protect
             (if (and (eq (process-status proc) 'exit)
                      (zerop (process-exit-status proc)))

                 (with-current-buffer output-buf
                   (goto-char (point-min))
                   (if (re-search-forward "PATH='\\(.*\\)'" nil t)
                       ;; Successfully parsed the PATH
                       (let* ((paths-str (match-string 1))
                              (paths (split-string paths-str path-separator)))
                         (setq nix-env-active-paths (reverse paths))
                         (dolist (p nix-env-active-paths)
                           (add-to-list 'exec-path p)
                           (setenv "PATH" (concat p path-separator (getenv "PATH"))))
			 (setq nix-env-current-packages packages)
                         (message "nix-env: Activated: %s" (string-join packages ", ")))
                     ;; Could not parse the PATH from output
                     (message "nix-env: Failed to parse PATH from nix output.")))

               (let ((failure-buffer (get-buffer-create "*Nix-Env Failure*")))
                 (with-current-buffer failure-buffer
                   (insert (format "nix-env: Command failed for packages: %s\n\n" (string-join packages ", ")))
                   (insert-buffer-substring output-buf)
		   (view-mode 1))
                 (pop-to-buffer failure-buffer)))

           (when (buffer-live-p output-buf)
             (kill-buffer output-buf))))))))

(defun nix-env-reset ()
  "Restore `exec-path` and `PATH` to their original values."
  (interactive)
  (setq exec-path nix-env-original-exec-path)
  (setenv "PATH" nix-env-original-path)
  (setq nix-env-active-paths nil)
  (setq nix-env-current-packages nil)
  (message "nix-env: Original environment restored"))

(defun nix-env-status ()
    "Display the current status of the Nix environment."
    (interactive)
    (if nix-env-current-packages
	(message "nix-env: Active with %s" (string-join nix-env-current-packages ", "))
    (message "nix-env: Inactive.")))

(defvar gptel-quick-buffer-name "*Response*"
  "Name of the transient buffer used for quick GPTel queries.")

(defun gptel-quick (&optional question)
  "Ask a single question using GPTel, or explain the active region if no question is provided.
The response is displayed in a transient buffer that can be discarded or replaced by the next query."
  (interactive
   (list
    (read-string "Enter your question (or press RET to explain region): "
                 nil nil 'completion-at-point)))

  (let* ((region-text (when (use-region-p)
                        (buffer-substring-no-properties (region-beginning)
                                                        (region-end))))
         (effective-question (or question ""))
         (full-prompt (cond
                       ;; Case 1: Region exists, and no question was provided.
                       ((and region-text (string-blank-p effective-question))
                        (concat "Explain the following text:\n" region-text))
                       ;; Case 2: Region exists, and a question was provided.
                       ((and region-text (not (string-blank-p effective-question)))
                        (concat "Context:\n" region-text "\n\nQuestion:\n" effective-question))
                       ;; Case 3: No region, use the question provided.
                       (t effective-question))))

    ;; Only proceed if there is a prompt to send.
    (unless (string-blank-p full-prompt)
      (let ((buf (get-buffer-create gptel-quick-buffer-name)))
        (with-current-buffer buf
          (read-only-mode -1)
          (erase-buffer)
          (insert "Waiting for response...\n")
          (goto-char (point-max))
          (read-only-mode 1)
          (display-buffer buf))
        (gptel-request full-prompt
          :system "Answer concisely when applicable."
          :callback (lambda (response _info)
                      (with-current-buffer buf
                        (read-only-mode -1)
                        (erase-buffer)
                        (if response
                            (insert response)
                          (insert "GPTel query failed."))
                        (goto-char (point-min))
                        (read-only-mode 1))))))))

;; THEME
(use-package gruber-darker-theme :ensure t)
(use-package ef-themes :ensure t)
(use-package doom-themes :ensure t)
(use-package vb-light-theme :ensure t)
(use-package vb-dark-theme :ensure t)

(defvar my/last-theme 'doom-badger
  "The last theme selected via `consult-theme`.")

(defun my/save-last-theme (theme)
  "Remember THEME as the last selected and persist it."
  (when (and theme (not (eq theme 'default)))
    (setq my/last-theme theme)
    (let ((inhibit-message t))
      (customize-save-variable 'my/last-theme theme))))

(defun my/load-last-theme ()
  "Load the theme saved in `my/last-theme`, if any."
  (when (and (boundp 'my/last-theme)
             my/last-theme
             (not (eq my/last-theme 'default)))
    (load-theme my/last-theme t)))

;; After picking a theme with `consult-theme`, save it:
(advice-add 'consult-theme :after
            (lambda (theme &rest _)
              (my/save-last-theme theme)))

;; On startup, load last theme:
(my/load-last-theme)

(provide 'init)
;;; init.el ends here
