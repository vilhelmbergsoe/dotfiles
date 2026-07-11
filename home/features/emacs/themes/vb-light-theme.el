;;; vb-light-theme.el --- VB Light - Minimalist syntax highlighting -*- lexical-binding: t; -*-

;; Author: Vilhelm Bergsoe
;; URL: https://tonsky.me/blog/syntax-highlighting/
;; Version: 1.0
;; Package-Requires: ((emacs "24"))

;;; Commentary:
;;
;; A minimalist light theme based on Nikita Prokopov's Alabaster theme.
;; Uses background highlighting for high contrast and only 4 strategic colors.
;;
;; Core philosophy: "If everything is highlighted, nothing is highlighted."
;;
;; Uses only 4 strategic colors + backgrounds:
;; - Green backgrounds for strings
;; - Purple backgrounds for constants and numbers
;; - Orange backgrounds for comments
;; - Blue backgrounds for top-level definitions

;;; Code:

(deftheme vb-light
  "VB Light - Minimalist syntax highlighting with background colors.")

(let ((bg       "#FAFAFA")  ; soft off-white background
      (fg       "#2E2E2E")  ; dark gray text (softer than black)
      (subtle   "#6B6B6B")  ; subtle gray for less important text
      (faint    "#B0B0B0")  ; very faint for punctuation

      ;; Strategic background highlighting
      (string-bg   "#E6F4EA") ; soft green background
      (string-fg   "#1E5631") ; dark green foreground

      (const-bg    "#F3ECFF") ; soft purple background
      (const-fg    "#5E35B1") ; deep purple foreground

      (comment-bg  "#FFF8E1") ; soft yellow background
      (comment-fg  "#8B6914") ; dark gold foreground

      (func-bg     "#E3F2FD") ; soft blue background
      (func-fg     "#1565C0") ; deep blue foreground

      ;; UI colors
      (select      "#D6E5F5")
      (hl-line     "#F5F5F5")
      (border      "#E0E0E0")
      (error       "#D32F2F")
      (warning     "#F57C00")
      (success     "#388E3C"))

  (custom-theme-set-faces
   'vb-light

   ;; Base faces
   `(default ((t (:background ,bg :foreground ,fg))))
   `(cursor ((t (:background ,fg))))
   `(region ((t (:background ,select))))
   `(hl-line ((t (:background ,hl-line))))
   `(fringe ((t (:background ,bg :foreground ,faint))))
   `(mode-line ((t (:background ,border :foreground ,fg :box (:line-width 1 :color ,border)))))
   `(mode-line-inactive ((t (:background ,hl-line :foreground ,subtle :box (:line-width 1 :color ,border)))))
   `(vertical-border ((t (:foreground ,border))))
   `(minibuffer-prompt ((t (:foreground ,func-fg))))

   ;; Line numbers
   `(line-number ((t (:foreground ,faint :background ,bg))))
   `(line-number-current-line ((t (:foreground ,fg :background ,hl-line))))

   ;; Search and matching
   `(isearch ((t (:background ,func-fg :foreground ,bg))))
   `(lazy-highlight ((t (:background ,func-bg))))
   `(match ((t (:background ,const-bg))))

   ;; Core syntax - BACKGROUND HIGHLIGHTING
   `(font-lock-string-face ((t (:background ,string-bg :foreground ,string-fg))))
   `(font-lock-doc-face ((t (:background ,comment-bg :foreground ,comment-fg))))
   `(font-lock-constant-face ((t (:background ,const-bg :foreground ,const-fg))))
   `(font-lock-number-face ((t (:background ,const-bg :foreground ,const-fg))))
   `(font-lock-comment-face ((t (:background ,comment-bg :foreground ,comment-fg))))
   `(font-lock-comment-delimiter-face ((t (:foreground ,subtle))))

   ;; Function and variable DECLARATIONS (not usage)
   `(font-lock-function-name-face ((t (:background ,func-bg :foreground ,func-fg))))
   `(font-lock-variable-name-face ((t (:background ,func-bg :foreground ,func-fg))))

   ;; Keywords are invisible (same as default text)
   `(font-lock-keyword-face ((t (:foreground ,fg))))
   `(font-lock-builtin-face ((t (:foreground ,fg))))
   `(font-lock-type-face ((t (:foreground ,fg))))

   ;; Preprocessor and warnings
   `(font-lock-preprocessor-face ((t (:foreground ,fg))))
   `(font-lock-warning-face ((t (:foreground ,error))))

   ;; Tree-sitter faces
   `(tree-sitter-hl-face:string ((t (:inherit font-lock-string-face))))
   `(tree-sitter-hl-face:string.special ((t (:inherit font-lock-string-face))))
   `(tree-sitter-hl-face:number ((t (:inherit font-lock-constant-face))))
   `(tree-sitter-hl-face:constant ((t (:inherit font-lock-constant-face))))
   `(tree-sitter-hl-face:constant.builtin ((t (:inherit font-lock-constant-face))))
   `(tree-sitter-hl-face:comment ((t (:inherit font-lock-comment-face))))

   ;; Function CALLS are not highlighted (only definitions)
   `(tree-sitter-hl-face:function.call ((t (:foreground ,fg))))
   `(tree-sitter-hl-face:function ((t (:inherit font-lock-function-name-face))))
   `(tree-sitter-hl-face:function.builtin ((t (:foreground ,fg))))
   `(tree-sitter-hl-face:method.call ((t (:foreground ,fg))))

   ;; Variable USAGE is not highlighted (only declarations)
   `(tree-sitter-hl-face:variable ((t (:foreground ,fg))))
   `(tree-sitter-hl-face:variable.parameter ((t (:foreground ,fg))))
   `(tree-sitter-hl-face:variable.builtin ((t (:foreground ,fg))))

   ;; Keywords are invisible (same as default text)
   `(tree-sitter-hl-face:keyword ((t (:foreground ,fg))))
   `(tree-sitter-hl-face:operator ((t (:foreground ,fg))))
   `(tree-sitter-hl-face:punctuation ((t (:foreground ,subtle))))
   `(tree-sitter-hl-face:punctuation.bracket ((t (:foreground ,subtle))))
   `(tree-sitter-hl-face:punctuation.delimiter ((t (:foreground ,subtle))))

   ;; Types are invisible (same as default text)
   `(tree-sitter-hl-face:type ((t (:foreground ,fg))))
   `(tree-sitter-hl-face:type.builtin ((t (:foreground ,fg))))

   ;; Properties and attributes
   `(tree-sitter-hl-face:property ((t (:foreground ,fg))))
   `(tree-sitter-hl-face:attribute ((t (:foreground ,fg))))

   ;; Markup (Markdown, Org)
   `(markdown-header-face ((t (:foreground ,func-fg))))
   `(markdown-header-face-1 ((t (:background ,func-bg :foreground ,func-fg))))
   `(markdown-header-face-2 ((t (:foreground ,func-fg))))
   `(markdown-header-face-3 ((t (:foreground ,func-fg))))
   `(markdown-code-face ((t (:background ,const-bg :foreground ,const-fg))))
   `(markdown-inline-code-face ((t (:background ,const-bg :foreground ,const-fg))))
   `(markdown-link-face ((t (:foreground ,func-fg :underline t))))

   `(org-level-1 ((t (:background ,func-bg :foreground ,func-fg))))
   `(org-level-2 ((t (:foreground ,func-fg))))
   `(org-level-3 ((t (:foreground ,func-fg))))
   `(org-code ((t (:background ,const-bg :foreground ,const-fg))))
   `(org-verbatim ((t (:background ,const-bg :foreground ,const-fg))))
   `(org-link ((t (:foreground ,func-fg :underline t))))
   `(org-block ((t (:background ,hl-line :foreground ,fg))))
   `(org-block-begin-line ((t (:foreground ,subtle :slant italic))))
   `(org-block-end-line ((t (:foreground ,subtle :slant italic))))

   ;; Completion UI
   `(corfu-default ((t (:background "#FFFFFF" :foreground ,fg))))
   `(corfu-current ((t (:background ,select :foreground ,fg))))
   `(corfu-border ((t (:background ,border))))

   `(vertico-current ((t (:background ,select))))

   `(marginalia-key ((t (:foreground ,const-fg))))
   `(marginalia-documentation ((t (:foreground ,subtle))))

   ;; Magit
   `(magit-section-heading ((t (:background ,func-bg :foreground ,func-fg))))
   `(magit-branch-local ((t (:foreground ,func-fg))))
   `(magit-branch-remote ((t (:foreground ,string-fg))))
   `(magit-diff-added ((t (:background "#E8F5E9" :foreground ,success))))
   `(magit-diff-added-highlight ((t (:background "#C8E6C9" :foreground ,success))))
   `(magit-diff-removed ((t (:background "#FFEBEE" :foreground ,error))))
   `(magit-diff-removed-highlight ((t (:background "#FFCDD2" :foreground ,error))))
   `(magit-diff-context ((t (:foreground ,fg))))
   `(magit-diff-hunk-heading ((t (:background ,hl-line :foreground ,subtle))))
   `(magit-diff-hunk-heading-highlight ((t (:background ,border :foreground ,fg))))

   ;; Flycheck/Flymake
   `(flycheck-error ((t (:underline (:style wave :color ,error)))))
   `(flycheck-warning ((t (:underline (:style wave :color ,warning)))))
   `(flycheck-info ((t (:underline (:style wave :color ,func-fg)))))

   `(flymake-error ((t (:underline (:style wave :color ,error)))))
   `(flymake-warning ((t (:underline (:style wave :color ,warning)))))
   `(flymake-note ((t (:underline (:style wave :color ,func-fg)))))

   ;; Which-key
   `(which-key-key-face ((t (:foreground ,const-fg))))
   `(which-key-separator-face ((t (:foreground ,faint))))
   `(which-key-group-description-face ((t (:foreground ,func-fg))))

   ;; Evil
   `(evil-ex-substitute-matches ((t (:background "#FFCDD2" :foreground ,error))))
   `(evil-ex-substitute-replacement ((t (:background "#C8E6C9" :foreground ,success))))

   ;; Eldoc box
   `(eldoc-box-body ((t (:background "#FFFFFF" :foreground ,fg))))
   `(eldoc-box-border ((t (:background ,border))))

   ;; hl-todo
   `(hl-todo ((t (:background ,comment-bg :foreground ,comment-fg))))

   ;; Tab bar
   `(tab-bar ((t (:background ,border :foreground ,fg))))
   `(tab-bar-tab ((t (:background ,select :foreground ,fg :weight bold :box (:line-width 1 :color ,border)))))
   `(tab-bar-tab-inactive ((t (:background ,hl-line :foreground ,subtle :box (:line-width 1 :color ,border)))))

   ;; Links and buttons
   `(link ((t (:foreground ,func-fg :underline t))))
   `(link-visited ((t (:foreground ,const-fg :underline t))))
   `(button ((t (:foreground ,func-fg :underline t))))

   ;; LaTeX - make it look like code, not formatted text
   `(font-latex-sectioning-0-face ((t (:foreground ,func-fg))))
   `(font-latex-sectioning-1-face ((t (:foreground ,func-fg))))
   `(font-latex-sectioning-2-face ((t (:foreground ,func-fg))))
   `(font-latex-sectioning-3-face ((t (:foreground ,func-fg))))
   `(font-latex-sectioning-4-face ((t (:foreground ,func-fg))))
   `(font-latex-sectioning-5-face ((t (:foreground ,func-fg))))
   `(font-latex-sedate-face ((t (:foreground ,fg))))  ; & and other special chars
   `(font-latex-math-face ((t (:foreground ,const-fg))))
   `(font-latex-string-face ((t (:background ,string-bg :foreground ,string-fg))))
   `(font-latex-warning-face ((t (:foreground ,warning))))
   `(font-latex-verbatim-face ((t (:background ,const-bg :foreground ,const-fg))))

   ;; ANSI colors for terminal emulators (ansi-term, vterm, eshell, etc.)
   `(ansi-color-black ((t (:background "#000000" :foreground "#000000"))))
   `(ansi-color-red ((t (:background ,error :foreground ,error))))
   `(ansi-color-green ((t (:background ,string-fg :foreground ,string-fg))))
   `(ansi-color-yellow ((t (:background ,comment-fg :foreground ,comment-fg))))
   `(ansi-color-blue ((t (:background ,func-fg :foreground ,func-fg))))
   `(ansi-color-magenta ((t (:background ,const-fg :foreground ,const-fg))))
   `(ansi-color-cyan ((t (:background "#0097A7" :foreground "#0097A7"))))
   `(ansi-color-white ((t (:background ,subtle :foreground ,subtle))))
   `(ansi-color-bright-black ((t (:background "#666666" :foreground "#666666"))))
   `(ansi-color-bright-red ((t (:background "#EF5350" :foreground "#EF5350"))))
   `(ansi-color-bright-green ((t (:background ,success :foreground ,success))))
   `(ansi-color-bright-yellow ((t (:background ,warning :foreground ,warning))))
   `(ansi-color-bright-blue ((t (:background "#42A5F5" :foreground "#42A5F5"))))
   `(ansi-color-bright-magenta ((t (:background "#AB47BC" :foreground "#AB47BC"))))
   `(ansi-color-bright-cyan ((t (:background "#26C6DA" :foreground "#26C6DA"))))
   `(ansi-color-bright-white ((t (:background ,fg :foreground ,fg))))

   ;; Xref
   `(xref-file-header ((t (:foreground ,func-fg))))
   `(xref-line-number ((t (:foreground ,subtle))))
   `(xref-match ((t (:background ,select))))

   ;; Compilation
   `(compilation-info ((t (:foreground ,func-fg))))
   `(compilation-warning ((t (:foreground ,warning))))
   `(compilation-error ((t (:foreground ,error))))
   `(compilation-line-number ((t (:foreground ,subtle))))
   `(compilation-column-number ((t (:foreground ,subtle))))
   `(compilation-mode-line-fail ((t (:foreground ,error))))
   `(compilation-mode-line-exit ((t (:foreground ,success))))

   ;; Dired
   `(dired-directory ((t (:foreground ,func-fg))))
   `(dired-symlink ((t (:foreground ,const-fg))))
   `(dired-marked ((t (:foreground ,warning))))
   `(dired-flagged ((t (:foreground ,error))))
   `(dired-header ((t (:foreground ,func-fg))))

   ;; Other common faces
   `(header-line ((t (:background ,border :foreground ,fg))))
   `(highlight ((t (:background ,hl-line))))
   `(secondary-selection ((t (:background ,select))))
   `(shadow ((t (:foreground ,subtle))))
   `(trailing-whitespace ((t (:background ,error))))
   `(show-paren-match ((t (:background ,select))))
   `(show-paren-mismatch ((t (:background ,error :foreground ,bg))))))

(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'vb-light)

;;; vb-light-theme.el ends here
