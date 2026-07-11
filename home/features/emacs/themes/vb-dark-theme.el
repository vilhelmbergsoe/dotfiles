;;; vb-dark-theme.el --- VB Dark - Minimalist syntax highlighting -*- lexical-binding: t; -*-

;; Author: Vilhelm Bergsoe
;; URL: https://tonsky.me/blog/syntax-highlighting/
;; Version: 1.0
;; Package-Requires: ((emacs "24"))

;;; Commentary:
;;
;; A minimalist dark theme based on Nikita Prokopov's Alabaster theme.
;; Uses subtle background highlighting and only 4 strategic colors.
;;
;; Core philosophy: "If everything is highlighted, nothing is highlighted."
;;
;; Uses only 4 strategic colors + subtle backgrounds:
;; - Green for strings
;; - Purple for constants and numbers
;; - Orange for comments
;; - Blue for top-level definitions

;;; Code:

(deftheme vb-dark
  "VB Dark - Minimalist syntax highlighting with subtle backgrounds.")

(let ((bg       "#1E1E1E")  ; dark background
      (fg       "#D4D4D4")  ; light gray text
      (subtle   "#9D9D9D")  ; subtle gray for less important text
      (faint    "#555555")  ; very faint for punctuation

      ;; Strategic colors - brighter for better contrast
      (string-fg   "#81C784") ; brighter green
      (const-fg    "#BA68C8") ; brighter purple
      (comment-fg  "#FFB74D") ; brighter orange
      (func-fg     "#42A5F5") ; brighter blue

      ;; UI colors
      (select      "#2F4F6F")
      (hl-line     "#252525")
      (border      "#2D2D2D")
      (error       "#EF5350")
      (warning     "#FFA726")
      (success     "#66BB6A"))

  (custom-theme-set-faces
   'vb-dark

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
   `(lazy-highlight ((t (:background ,select))))
   `(match ((t (:background ,select))))

   ;; Core syntax - NO BACKGROUNDS
   `(font-lock-string-face ((t (:foreground ,string-fg))))
   `(font-lock-doc-face ((t (:foreground ,comment-fg))))
   `(font-lock-constant-face ((t (:foreground ,const-fg))))
   `(font-lock-number-face ((t (:foreground ,const-fg))))
   `(font-lock-comment-face ((t (:foreground ,comment-fg))))
   `(font-lock-comment-delimiter-face ((t (:foreground ,subtle))))

   ;; Function and variable DECLARATIONS (not usage)
   `(font-lock-function-name-face ((t (:foreground ,func-fg))))
   `(font-lock-variable-name-face ((t (:foreground ,func-fg))))

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
   `(markdown-header-face-1 ((t (:foreground ,func-fg))))
   `(markdown-header-face-2 ((t (:foreground ,func-fg))))
   `(markdown-header-face-3 ((t (:foreground ,func-fg))))
   `(markdown-code-face ((t (:foreground ,const-fg))))
   `(markdown-inline-code-face ((t (:foreground ,const-fg))))
   `(markdown-link-face ((t (:foreground ,func-fg :underline t))))

   `(org-level-1 ((t (:foreground ,func-fg))))
   `(org-level-2 ((t (:foreground ,func-fg))))
   `(org-level-3 ((t (:foreground ,func-fg))))
   `(org-code ((t (:foreground ,const-fg))))
   `(org-verbatim ((t (:foreground ,const-fg))))
   `(org-link ((t (:foreground ,func-fg :underline t))))
   `(org-block ((t (:background ,hl-line :foreground ,fg))))
   `(org-block-begin-line ((t (:foreground ,subtle :slant italic))))
   `(org-block-end-line ((t (:foreground ,subtle :slant italic))))

   ;; Completion UI
   `(corfu-default ((t (:background "#282828" :foreground ,fg))))
   `(corfu-current ((t (:background ,select :foreground ,fg))))
   `(corfu-border ((t (:background ,border))))

   `(vertico-current ((t (:background ,select))))

   `(marginalia-key ((t (:foreground ,const-fg))))
   `(marginalia-documentation ((t (:foreground ,subtle))))

   ;; Magit
   `(magit-section-heading ((t (:foreground ,func-fg))))
   `(magit-branch-local ((t (:foreground ,func-fg))))
   `(magit-branch-remote ((t (:foreground ,string-fg))))
   `(magit-diff-added ((t (:background "#1F3A1F" :foreground ,success))))
   `(magit-diff-added-highlight ((t (:background "#2A4A2A" :foreground ,success))))
   `(magit-diff-removed ((t (:background "#3A1F1F" :foreground ,error))))
   `(magit-diff-removed-highlight ((t (:background "#4A2A2A" :foreground ,error))))
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
   `(evil-ex-substitute-matches ((t (:background "#4A2A2A" :foreground ,error))))
   `(evil-ex-substitute-replacement ((t (:background "#2A4A2A" :foreground ,success))))

   ;; Eldoc box
   `(eldoc-box-body ((t (:background "#282828" :foreground ,fg))))
   `(eldoc-box-border ((t (:background ,border))))

   ;; hl-todo
   `(hl-todo ((t (:foreground ,comment-fg))))

   ;; Tab bar
   `(tab-bar ((t (:background ,border :foreground ,fg))))
   `(tab-bar-tab ((t (:background ,bg :foreground ,fg :box (:line-width 1 :color ,border)))))
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
   `(font-latex-string-face ((t (:foreground ,string-fg))))
   `(font-latex-warning-face ((t (:foreground ,warning))))
   `(font-latex-verbatim-face ((t (:foreground ,const-fg))))

   ;; ANSI colors for terminal emulators (ansi-term, vterm, eshell, etc.)
   `(ansi-color-black ((t (:background ,bg :foreground ,bg))))
   `(ansi-color-red ((t (:background ,error :foreground ,error))))
   `(ansi-color-green ((t (:background ,string-fg :foreground ,string-fg))))
   `(ansi-color-yellow ((t (:background ,comment-fg :foreground ,comment-fg))))
   `(ansi-color-blue ((t (:background ,func-fg :foreground ,func-fg))))
   `(ansi-color-magenta ((t (:background ,const-fg :foreground ,const-fg))))
   `(ansi-color-cyan ((t (:background "#4DB8A8" :foreground "#4DB8A8"))))
   `(ansi-color-white ((t (:background ,fg :foreground ,fg))))
   `(ansi-color-bright-black ((t (:background ,subtle :foreground ,subtle))))
   `(ansi-color-bright-red ((t (:background ,error :foreground ,error))))
   `(ansi-color-bright-green ((t (:background ,success :foreground ,success))))
   `(ansi-color-bright-yellow ((t (:background ,warning :foreground ,warning))))
   `(ansi-color-bright-blue ((t (:background "#90CAF9" :foreground "#90CAF9"))))
   `(ansi-color-bright-magenta ((t (:background "#CE93D8" :foreground "#CE93D8"))))
   `(ansi-color-bright-cyan ((t (:background "#80DEEA" :foreground "#80DEEA"))))
   `(ansi-color-bright-white ((t (:background "#FFFFFF" :foreground "#FFFFFF"))))

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

(provide-theme 'vb-dark)

;;; vb-dark-theme.el ends here
