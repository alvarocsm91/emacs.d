;;; Basic setup
;;;; Home directory
(setq MyHomeDir (getenv "HOME"))

;;;; Proxy
(when (file-exists-p (format "%s/.emacs.d/proxy.el" MyHomeDir))
  (load-file (format "%s/.emacs.d/proxy.el" MyHomeDir)))

;;;; Repositories
(require 'package)
(setq package-user-dir (format "%s/.emacs.d/elpa" MyHomeDir))

(setq load-prefer-newer t
      package-enable-at-startup t)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

(package-initialize)
(package-refresh-contents)

;;; Package usage
;;;; Use Package
(package-install 'use-package t)
(setq use-package-always-defer t
      use-package-always-ensure t)

;;;; Hydra
(use-package hydra
  :defer t)

;;;; Org mode
(use-package org
  :ensure org-plus-contrib
  :config
  (setq org-return-follows-link t)
  :hook (org-mode . (lambda ()
                      (aggressive-fill-paragraph-mode t)))
  :bind
  (("C-x L" . org-store-link)		;; global
   ("C-x C-l" . org-insert-link-global) ;; global
   :map org-mode-map
   ("C-x C-l" . org-insert-link)))

;;;;; Org tarsk state
;;Define pocess states
(setq org-todo-keywords
'((sequence "TBD" "TODO" "ACTIVE" "BLOCKED" "REVIEW" "|" "DONE" "ARCHIVED" "DELETED")))
;; Define process colours
(setq org-todo-keyword-faces
      '(("TBD" .(:foreground "white" :weight bold-italic))
      ("TODO" .(:foreground "grey" :weight bold-italic))
      ("ACTIVE" .(:foreground "ligth-blue" :weight bold-italic))
      ("BLOCKED" .(:foreground "purple" :weight bold-italic))
      ("REVIEW" .(:foreground "pink" :weight bold-italic))
      ("DONE" .(:foreground "yellow" :weight bold-italic))
      ("ARCHIVED" .(:foreground "green" :weight bold-italic))
      ("DELETED" .(:foreground "black" :weight bold-italic))))

;;;;; Org pygmentize
(require 'org)
(require 'ox-latex)
(add-to-list 'org-latex-packages-alist '("" "minted"))
(setq org-latex-listings 'minted)

(setq org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
    "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
    "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

(setq org-src-fontify-natively t)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)
   (latex . t)
   ()))

;;;;; Org-link-moinor-mode
;; (use-package org-link-minor-mode)
(when (file-exists-p (format "%s/.emacs.d/org-link-minor-mode/org-link-minor-mode.el" MyHomeDir))
  (load-library (format "%s/.emacs.d/org-link-minor-mode/org-link-minor-mode.el" MyHomeDir)))

(require 'org)
(use-package org-link-minor-mode
  :ensure t)

;;;;; Poporg
(use-package poporg
  :ensure t
  :bind
  ;; call it
  (:map global-map
    (("C-c SPC" . poporg-dwim))
    ;; from within the org mode, poporg-mode-map is a minor mode
    :map poporg-mode-map
    ("C-c C-c" . poporg-update)            ;; update original
    ("C-c SPC" . poporg-edit-exit)         ;; exit, keeping changes
    ("C-x C-s" . poporg-update-and-save))  ;; update original and save buffer
  :hook (poporg-mode . (lambda ()
             (outline-show-all)
             (aggressive-fill-paragraph-mode t)
             (goto-char (point-min)))))

;;;;; Org Trello
;;(require 'org-trello)
;;(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
;;(package-initialize)

;;;;;; Set credentials
;; First of all you should connect with trello with the browser using next command:
;; org-trello-install-key-and-token
;; Now you can use trello woth emacs

;;;;;; Add Trello to major mode
;;(add-to-list 'auto-mode-alist '("\\.trello$" . org-mode))

;;;;;; Auto org-trello files in emacs
;;(add-hook 'org-mode-hook
;;(lambda ()
;;(let ((filename (buffer-file-name (current-buffer))))
;;(when (and filename (string= "trello" (file-name-extension filename)))
;;(org-trello-mode)))))

;;;; Company
(use-package company
  :defer t
  :ensure t
  :init (global-company-mode t)
  :config
  ;; Company Quickhelp
  ;; When idling on a completion candidate the documentation for the
  ;; candidate will pop up after `company-quickhelp-delay' seconds.
  (use-package company-quickhelp
    :defer t
    :ensure t
    ;; :if window-system
    :init (company-quickhelp-mode t)
    :config
    (setq company-quickhelp-delay 0.2
      company-quickhelp-max-lines 10))
  ;; With use-package:
  ;; (use-package company-box
  ;;   :hook (company-mode . company-box-mode))
  ;; Variables
  (setq company-dabbrev-ignore-case nil
    company-dabbrev-code-ignore-case nil
    company-dabbrev-downcase nil
    company-idle-delay 0.01
    company-echo-delay 0.01
    company-minimum-prefix-length 2)
  :diminish company-mode)

;;;; Flycheck
(use-package flycheck-pos-tip
  :defer t)
(use-package helm-flycheck
  :defer t)
(use-package flycheck-color-mode-line
  :defer t)
(use-package flycheck
  :init
  (global-flycheck-mode t)
  (flycheck-pos-tip-mode t)
  :bind
  (:map flycheck-command-map
    ("h" . helm-flycheck))
  :config
  (setq flycheck-completion-system 'helm-comp-read )
  (add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode))

;;;; Aggresive indent
(use-package aggressive-indent
  :init (global-aggressive-indent-mode 1))

(use-package aggressive-fill-paragraph
  :ensure t)

;;;; Whitespace
(use-package whitespace
  :config
  (add-to-list 'whitespace-style 'lines-tail)
  (setq-default show-trailing-whitespace nil)
  (setq whitespace-line-column 80))

(use-package whitespace-cleanup-mode
  :init
  (global-whitespace-cleanup-mode 1)
  :config
  (setq whitespace-cleanup-mode-only-if-initially-clean nil))

;;;; Crux
(use-package crux
  :defer t
  :config
  (progn
    (crux-reopen-as-root-mode 1))
  :bind
  (:map global-map
    ("C-a" . nil)
    ([remap kill-whole-line] . crux-kill-whole-line)
    ([remap move-beginning-of-line] . crux-move-beginning-of-line)
    ("C-a"  . crux-move-beginning-of-line)))

;;;;  Smart scan
(use-package smartscan
  :init
  (global-smartscan-mode 1)
  :bind
  (:map smartscan-map
    ("M-’" . 'smartscan-symbol-replace))
  :config
  ;; Variables
  (setq smartscan-symbol-selector "word"))

;;;; Magit
(use-package magit-svn
  :ensure t)

(use-package magit
  :config
  (add-hook 'magit-mode-hook 'magit-svn-mode)
  (setq magit-diff-paint-whitespace nil
    magit-diff-highlight-trailing nil
    magit-refresh-verbose t
    magit-refresh-status-buffer t
    magit-display-buffer-function
    #'magit-display-buffer-fullframe-status-v1
    magit-diff-highlight-indentation nil))

;;;; Auto backup and save
(setq auto-save-default t	;; do auto-saving of every file-visiting buffer.
      delete-auto-save-files t  ;; delete auto-save file when a buffer is saved or killed.
      auto-save-timeout 10	;; Number of seconds idle time before auto-save.
      auto-save-interval 300)	;; Number of input events between auto-saves.

(use-package super-save
  :init
  (super-save-mode 1)
  :defer 5
  :config
  (setq super-save-auto-save-when-idle t ;; Save current buffer automatically when Emacs is idle
    super-save-remote-files nil)     ;; Save remote files when t, ignore them otherwise
  )

;;;; Which key
(use-package which-key
  :init (which-key-mode 1)
  :pin melpa-stable
  :ensure t
  :config
  ;; Set the time delay (in seconds) for the which-key popup to appear.
  (setq which-key-idle-delay 0.5)
  ;; A list of regexp strings to use to filter key sequences.
  (setq which-key-allow-regexps '("C-c p" "C-c p s" "C-x c"))
  ;; Set the maximum length (in characters) for key descriptions (commands or
  ;; prefixes). Descriptions that are longer are truncated and have ".." added
  (setq which-key-max-description-length nil)
  ;; Set the separator used between keys and descriptions. Change this setting to
  ;; an ASCII character if your font does not show the default arrow. The second
  ;; setting here allows for extra padding for Unicode characters. which-key uses
  ;; characters as a means of width measurement, so wide Unicode characters can
  ;; throw off the calculation.
  (setq which-key-separator " → " )
  (setq which-key-unicode-correction 3)
  (setq which-key-max-display-columns 3)
  ;; Set the special keys. These are automatically truncated to one character and
  ;; have which-key-special-key-face applied. Set this variable to nil to disable
  ;; the feature
  (setq which-key-special-keys '("SPC" "TAB" "RET" "ESC" "DEL"))
  ;; Show the key prefix on the left or top (nil means hide the prefix). The
  ;; prefix consists of the keys you have typed so far. which-key also shows the
  ;; page information along with the prefix.
  (setq which-key-show-prefix 'left)
  ;; Set to t to show the count of keys shown vs. total keys in the mode line.
  (setq which-key-show-remaining-keys nil))

;;;; Which function
(use-package which-func
  :init
  (which-function-mode 1)
  :config
  (setq which-func-unknown " "
    which-func-format
    (list " " (car (cdr which-func-format)) "")
    mode-line-misc-info
    ;; We remove Which Function Mode from the mode line, because it's mostly
    ;; invisible here anyway.
    (assq-delete-all 'which-func-mode mode-line-misc-info))
  (setq-default header-line-format '((which-function-mode (""
        which-func-format " ")))))

;;;; Autocompile
(use-package auto-compile
  :init
  (auto-compile-on-load-mode 1)
  (auto-compile-on-save-mode 1)
  :config
  (setq auto-compile-display-buffer nil
        auto-compile-mode-line-counter t
        load-prefer-newer t
        auto-compile-display-buffer nil
        auto-compile-mode-line-counter t))

;;;; Multiple cursors
(use-package multiple-cursors)
(global-set-key (kbd "C-c m c") 'mc/edit-lines)

;;;; Yasnippet
(use-package yasnippet)
;; Use as global mode
(yas-global-mode 1)
;;;;; Add yasnippet as minor mode in prog-modes
;;(yas-reload-all)
;;(add-hook 'prog-mode-hook #'yas-minor-mode)
;;;;; Configure yasnippet
(setq yas-snippet-dirs
      '("~/.emacs.d/snippets/vhdl-mode/vhdl"
;;	"~/.emacs.d/snippets/C"
   ))
;;;;; Create snippets
;; look in noxt folder .emacs/elpa/yasnippet-snippets/snippets/vhdl-mode/

;;;; Annotation mode
(defun csb/org-annotate-file ()
  (interactive)
  (let ((org-annotate-file-add-search t)
        (org-annotate-file-storage-file
         (if (buffer-file-name) ;; if not nil
             ;; for the rest of buffers, create a hidden folder containing its buffer-file-name
             (concat (file-name-directory (buffer-file-name)) "." (file-name-nondirectory (buffer-file-name))
                     ".annotations")
           "~/.org-annotate-file.org")))
    (org-annotate-file)))

(global-set-key (kbd "C-c C-SPC") #'csb/org-annotate-file)

(setq-default ispell-program-name "aspell")
(setq ispell-dictionary "castellano")
(setq ispell-local-dictionary. "castellano")
(flyspell-mode 1)

(use-package helm
  :init
  (require 'helm-config)
  (helm-mode 1)
  (helm-autoresize-mode 1)
  :config
  (helm-autoresize-mode 1)
  (global-set-key (kbd "M-x")     'helm-M-x)
  (global-set-key (kbd "C-x C-b") 'helm-buffers-list)
  (global-set-key (kbd "C-x b")   'helm-mini)
  (global-set-key (kbd "C-x C-f") 'helm-find-files)
  (define-key helm-command-map (kbd "T") #'helm-themes)
  (global-set-key (kbd "M-y")     'helm-show-kill-ring))

;;;; Projectile
(use-package projectile
  :init (projectile-mode 1)
  :ensure t
  :pin melpa-stable
  ;; Keys
  :bind
  (:map projectile-mode-map
    ("C-c p" . projectile-command-map)
    ("C-c p s a" . projectile-ag)
    ("C-c p s s" . nil))
  :config

  ;; Variables
  (setq projectile-completion-system 'helm
    projectile-indexing-method 'native
    projectile-enable-caching t
    projectile-remember-window-config t
    projectile-switch-project-action 'projectile-dired)

  (add-to-list 'projectile-globally-ignored-directories ".backups")
  (add-to-list 'projectile-globally-ignored-directories ".stversions"))

;; Helm + projectile
(use-package helm-projectile
  :init (helm-projectile-on)
  :ensure t
  :pin melpa-stable
  :config
  (setq
   helm-projectile-fuzzy-match t
   helm-projectile-sources-list '(helm-source-projectile-recentf-list
                  helm-source-projectile-buffers-list
                  helm-source-projectile-files-list
                  helm-source-projectile-projects)))

;;;; Grep
(use-package helm-ag
  :ensure t)

;;;; Ripgrep
(use-package ripgrep
  :ensure t)

;;;; Ag
(use-package helm-rg
  :ensure t
  :pin melpa-stable)

;;;; Wakatime
;;(use-package wakatime-mode)
;;(global-wakatime-mode 1)

;;;; Undo tree
(use-package undo-tree)
;; Active as global mode
(global-undo-tree-mode 1)

;;;; Mode icons
(use-package mode-icons)
(mode-icons-mode)

;;;; Hightlight-symbol
(use-package highlight-symbol)
(global-set-key [(control f3)] 'highlight-symbol)
(global-set-key [f3] 'highlight-symbol-next)
(global-set-key [(shift f3)] 'highlight-symbol-prev)
(global-set-key [(meta f3)] 'highlight-symbol-query-replace)

;; Install package
(use-package google-this)
;; Set active
(google-this-mode 1)

(use-package google-translate)
(require 'google-translate-smooth-ui)
(global-set-key "\C-ct" 'google-translate-smooth-translate)



;;; Global features

;;;; Global keys
;; Cambia la fuente del buffer a su valor por defecto.
(global-set-key (kbd "C-=") (lambda () (interactive) (text-scale-adjust 0)))
;; Maximiza las fuentes del buffer
(global-set-key (kbd "C-+") (lambda () (interactive) (text-scale-increase 0.5)))
;; Minimiza las fuentes del buffer
(global-set-key (kbd "C--") (lambda () (interactive) (text-scale-decrease 0.5)))
;; Cierra el buffer activo
(global-set-key (kbd "C-x k") #'kill-this-buffer)
;; Abre magit mostrando el estado de la carpeta
(global-set-key (kbd "C-x g") #'magit-status)

;;;; Global variables
(setq-default
 confirm-kill-emacs nil
 inhibit-splash-screen t
 inhibit-startup-message t
 ad-redefinition-action 'accept                   ; Silence warnings for redefinition
 confirm-kill-emacs 'yes-or-no-p                  ; Confirm before exiting Emacs
 cursor-in-non-selected-windows t                 ; Hide the cursor in inactive windows
 delete-by-moving-to-trash t                      ; Delete files to trash
 display-time-default-load-average nil            ; Don't display load average
 display-time-format "%H:%M"                      ; Format the time string
 fill-column 80                                   ; Set width for automatic line breaks
 help-window-select t                             ; Focus new help windows when opened
 indent-tabs-mode nil                             ; Stop using tabs to indent
 inhibit-startup-screen t                         ; Disable start-up screen
 initial-scratch-message ""                       ; Empty the initial *scratch* buffer
 left-margin-width 1 right-margin-width 1         ; Add left and right margins
 mode-require-final-newline 'visit                ; Add a newline at EOF on visit
 mouse-yank-at-point t                            ; Yank at point rather than pointer
 ns-use-srgb-colorspace nil                       ; Don't use sRGB colors
 recenter-positions '(5 top bottom)               ; Set re-centering positions
 redisplay-dont-pause t                           ; don't pause display on input
 debug-on-error t
 jit-lock-defer-time 0
 frame-resize-pixelwise t
 fast-but-imprecise-scrolling t
 scroll-conservatively 10000                      ; Always scroll by one line
 scroll-margin 1                                  ; scroll N lines to screen edge
 scroll-step 1                                    ; keyboard scroll one line at a time
 scroll-preserve-screen-position 1
 select-enable-clipboard t                        ; Merge system's and Emacs' clipboard
 sentence-end-double-space nil                    ; End a sentence after a dot and a space
 show-trailing-whitespace nil                     ; Display trailing whitespaces
 split-height-threshold nil                       ; Disable vertical window splitting
 split-width-threshold nil                        ; Disable horizontal window splitting
 tab-width 4                                      ; Set width for tabs
 uniquify-buffer-name-style 'forward              ; Uniquify buffer names
 window-combination-resize t                      ; Resize windows proportionally
 x-stretch-cursor t)                              ; Stretch cursor to the glyph width

;;;; Global modes
(delete-selection-mode)                           ; Replace region when inserting text
(setq line-number-mode t)                         ; Enable line numbers in the mode-line
(setq column-number-mode t)                       ; Enable column numbers in the mode-line
(size-indication-mode 1)                          ; Enable size status in the mode-line
(display-time-mode)                               ; Enable time in the mode-line
(when (window-system)
  (fringe-mode 80))
(fset 'yes-or-no-p 'y-or-n-p)                     ; Replace yes/no prompts with y/n
(global-hl-line-mode)                             ; Hightlight current line
(show-paren-mode t)
(setq show-paren-style 'expression)
(global-subword-mode)                             ; Iterate through CamelCase words
(menu-bar-mode 0)                                 ; Disable the menu bar
(mouse-avoidance-mode 'banish)                    ; Avoid collision of mouse with point
(put 'downcase-region 'disabled nil)              ; Enable downcase-region
(put 'upcase-region 'disabled nil)                ; Enable upcase-region
(put 'downcase-region 'disabled nil)              ; Enable downcase-region
(put 'upcase-region 'disabled nil)                ; Enable upcase-region
(add-hook 'focus-out-hook #'garbage-collect)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(fset 'yes-or-no-p 'y-or-n-p)

(set-language-environment 'utf-8)
(setq locale-coding-system 'utf-8-unix)
(prefer-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)
(set-terminal-coding-system 'utf-8-unix)
(set-keyboard-coding-system 'utf-8-unix)
(set-selection-coding-system 'utf-8-unix)

;;;; Theme
(use-package gruvbox-theme)
(use-package org-web-tools)

;;;;; Adaptative theme installation
(when (file-exists-p (format "%s/.emacs.d/adaptative-theme/adaptative-theme.el" MyHomeDir))
  (load-file (format "%s/.emacs.d/adaptative-theme/adaptative-theme.el" MyHomeDir))
  (adaptative-theme-autolocation 'gruvbox-light-soft 'gruvbox-dark-hard)
  )

;; Start maximised
(add-hook 'window-setup-hook 'toggle-frame-fullscreen t)

;; Remove all that’s not necessary
(when window-system
  (menu-bar-mode 0)
  (global-display-line-numbers-mode t)
  ;; (blink-cursor-mode 0)                        ; Disable the cursor blinking
  (scroll-bar-mode 0)                             ; Disable the scroll bar
  (tool-bar-mode 0)                               ; Disable the tool bar
  (tooltip-mode 0))                               ; Disable the tooltips

;;; Load files
(when (file-exists-p (format "%s/.emacs.d/general_conf.el" MyHomeDir))
  (load-file (format "%s/.emacs.d/general_conf.el" MyHomeDir)))

;;; Programming modes
(add-hook 'prog-mode-hook
          (lambda ()
            (outshine-mode t)
            (org-link-minor-mode t)))

;;;; VHDL
;;;;; Cayetano's features

  (use-package vhdl-mode
    :defer t
  ;;; Config
    :config
  ;;;; Beautifying setting last semicolom to column 79 or not
    ;; This variable toggles the functionality
    (defvar csb/vhdl-beautify-shift-semicolom t
      "When non nil, beautify shifts semicolon to column csb/vhdl-shift-semicolom-value. Indra compliant ...")
    (defvar csb/vhdl-shift-semicolom-value 79
      "Amount of shift to apply. Indra compliant ...")
    ;; The executing function
    (defun csb/vhdl-shift-semicolom (&optional start end)
      (when csb/vhdl-beautify-shift-semicolom
        (save-excursion
          (goto-char (or start (point-min)))
          (while (re-search-forward "[,;]$"
                                    (if (region-active-p)
                                        (region-end)
                                      (point-max))
                                    t)
            (backward-char)
            (indent-to-column csb/vhdl-shift-semicolom-value)
            (forward-char)))))
    ;; Advicing the beautifying function
    (advice-add 'vhdl-beautify-region :after #'csb/vhdl-shift-semicolom)
  ;;;; Major mode variables
    (setq vhdl-basic-offset 2
          vhdl-beautify-options '(t t t t nil)
          vhdl-highlight-forbidden-words t
          vhdl-highlight-special-words t
          vhdl-highlight-translate-off t
          vhdl-upper-case-constants t  ;; Non-nil means convert upper case.
          vhdl-upper-case-types nil
          vhdl-upper-case-keywords nil
          vhdl-upper-case-attributes nil
          vhdl-upper-case-enum-values nil)
  ;;;; Helpful modes on by default
    (vhdl-stutter-mode 1)
    (vhdl-electric-mode 1)
  ;;;; Completion at point with company, see below
    ;; Declare a variable to limit the features for large files
    (defvar csb/vhdl-max-lines-disable-features 1500
      "Maximun number of lines in a file to allow all features.")
    ;; Following previous variable
    (when (require 'vhdl-capf)
      (add-hook 'vhdl-mode-hook
                (lambda ()
                  (if (< (count-lines 1 (point-max))
                         csb/vhdl-max-lines-disable-features)
                      (progn
                        (add-to-list
                         (make-local-variable 'completion-at-point-functions)
                         'vhdl-capf-main)
                        ;; Make ‘company-backends’ local is critcal or else, you will
                        ;; have completion in every major mode
                        (make-local-variable 'company-backends)
                        ;; set ‘company-capf’ first in list
                        (delq 'company-capf company-backends)
                        (add-to-list 'company-backends 'company-capf))
                    ;; For large files, disable a couple of things
                    (progn
                      ;; Force standard for large files, fixes bug
                      (setq-local vhdl-standard (quote (93 nil)))
                      (company-mode -1)
                      (aggressive-indent-mode -1)
                      (flyspell-mode -1))))))
  ;;;; Show trailing whitespaces
    (add-hook 'vhdl-mode-hook
              (lambda ()
                (setq show-trailing-whitespace t)))
  ;;;; Outshine
    (add-hook 'vhdl-mode-hook
              (lambda ()
                (setq-local outline-regexp
                            "^\\s-*--\\s-\\([*]\\{1,8\\}\\)\\s-\\(.*\\)$")))
  ;;;; Custom beautify region, activating the paragraph first
    (defun csb/vhdl-beautify-region (arg)
      "Call beautify-region but auto activate region first.
           With a prefix ARG, fall back to previous behaviour."
      (interactive "P")
      (if (equal arg '(4))
          (call-interactively 'vhdl-beautify-region)
        (save-excursion
          (when (not (region-active-p))
            (mark-paragraph))
          (call-interactively 'vhdl-beautify-region))))
  ;;;; Hydra
    (defhydra csb/hydra-vhdl (:color blue)
      "
    _i_ndent   _I_nsert   _t_emplate   _f_ill   _b_eautify   _p_ort  _c_ompose   _F_ix  _m_odel  _M_ode   _a_lign  _?_
      "
      ("i" (with-initial-minibuffer "vhdl indent") nil)
      ("I" (with-initial-minibuffer "vhdl insert") nil)
      ("t" (with-initial-minibuffer "vhdl template") nil)
      ("f" (with-initial-minibuffer "vhdl fill") nil)
      ("b" (with-initial-minibuffer "vhdl beautify") nil)
      ("a" (with-initial-minibuffer "vhdl align") nil)
      ("p" (with-initial-minibuffer "vhdl -port") nil)
      ("c" (with-initial-minibuffer "vhdl compose") nil)
      ("F" (with-initial-minibuffer "vhdl fix") nil)
      ("m" (with-initial-minibuffer "vhdl model") nil)
      ("M" (with-initial-minibuffer "vhdl mode$") nil)
      ("?" vhdl-doc-mode nil)
      ("q" nil nil))
  ;;;; Bindings
    :bind (:map vhdl-mode-map
                ([remap vhdl-beautify-region] . csb/vhdl-beautify-region)
                ("C-c ?" . vhdl-doc-mode)
                ("C-c C-h" . nil)
                ("C-c v" . csb/hydra-vhdl/body)))

(use-package vhdl-capf
  :defer t
  :config
  (require 'vhdl-mode)
  (require 'company)
  (require 'cl)
  (setq vhdl-capf-search-vhdl-buffers-for-candidates t))

;;;;; Own config
;; Specific to vhdl-major mode
;;;;; Use ghdl if available as flycheck checker (linter)
;; First, install ghdl and at it to your windoze10 path
;; Check with (executable-find "ghdl"), which should return the path to the
;; executable
;; The "vhdl-ghdl" checker is already provided by Flycheck
(when (executable-find "ghdl")
  ;; Define a custom checker called "vhdl-ghdl-custom"
  ;; using your own options following your setup
  (flycheck-define-checker vhdl-ghdl-custom
    "A custom VHDL syntax checker using ghdl."
    :command ("ghdl"
          "-s" ; only do the syntax checking
          "--std=08"
          ;;"--std=93"
          "--ieee=synopsys"
          ;; "-fexplicit"
          ;; "--workdir=work"
          "-P/opt/CompiledLibraries/Vivado"
          "--warn-unused"
          source)
    :error-patterns
    ((error line-start (file-name) ":" line ":" column ": " (message) line-end))
    :modes vhdl-mode)

  ;; Finally, use one of "vhdl-ghdl" or "vhdl-ghdl-custom"
  (add-hook 'vhdl-mode-hook
        (lambda ()
          ;; Select ONLY one of:
          (flycheck-select-checker 'vhdl-ghdl-custom)
          ;; (flycheck-select-checker 'vhdl-ghdl)
          )
        ) ;; end add-hook
  ) ;; end when

;;;; Python
;;;;; Instal package
(use-package elpy)

;;;;; Emacs IPython Notebook
(use-package ein)

;;;;; Enable package
(elpy-enable)

;;;;; Use IPython for REPL
(setq python-shell-interpreter "jupyter"
      python-shell-interpreter-args "console --simple-prompt"
      python-shell-prompt-detect-failure-warning nil)
(add-to-list 'python-shell-completion-native-disabled-interpreters
         "jupyter")

;;;;; Enable flycheck mode
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;;;;; Show trailing whitespaces
(add-hook 'python-mode-hook
      (lambda ()
        (setq show-trailing-whitespace t)))
;;;;; Outshine
(add-hook 'python-mode-hook
      (lambda ()
        (setq-local outline-regexp
            "# [*]+")))

;;;; Python

;; Based on [[https://vxlabs.com/2018/11/19/configuring-emacs-lsp-mode-and-microsofts-visual-studio-code-python-language-server/][this]] article.

;; Only under linux
;;(when (eq (window-system) 'x)

;;(add-hook 'python-mode-hook
;;(lambda ()
;; flychek checker
;;(flycheck-select-checker 'python-flake8)
;;(lsp))))

;;  ;; Microsoft lsp implementation
;;  (use-package ms-python
;;    :config
;;    (setq ms-python-server-install-dir
;;          ;; set path to install
;;          (expand-file-name
;;           "~/Software/MS-LS/build/python-language-server/output/bin/Release/")
;;          ;; set path to dotnet
;;          ms-python-dotnet-install-dir "/usr/bin"))
;;
;;(use-package lsp-mode
;;    :config

;;    ;; change nil to 't to enable logging of packets between emacs and the LS
;;    ;; this was invaluable for debugging communication with the MS Python Language Server
;;    ;; and comparing this with what vs.code is doing
;;    (setq lsp-print-io nil)
;;
;;    ;; lsp-ui gives us the blue documentation boxes and the sidebar info
;;    (use-package lsp-ui
;;      :config
;;      ;; flycheck
;;      (require 'lsp-ui-flycheck)
;;      ;;
;;      (setq lsp-ui-sideline-ignore-duplicate t
;;            lsp-ui-sideline-delay 1
;;            lsp-ui-doc-use-childframe nil)
;;      (define-key lsp-ui-mode-map [remap xref-find-definitions]
;;        #'lsp-ui-peek-find-definitions)
;;      (define-key lsp-ui-mode-map [remap xref-find-references]
;;        #'lsp-ui-peek-find-references)
;;      (add-hook 'lsp-mode-hook 'lsp-ui-mode)
;;      (add-hook 'lsp-after-open-hook #'(lambda()(lsp-ui-flycheck-enable t)))
;;      (add-hook 'lsp-after-open-hook #'(lambda()(lsp-ui-sideline-enable t)))
;;      (add-hook 'lsp-after-open-hook #'(lambda()(lsp-ui-imenu-enable t)))
;;      (add-hook 'lsp-after-open-hook #'(lambda()(lsp-ui-peek-enable t)))
;;      (add-hook 'lsp-after-open-hook #'(lambda()(lsp-ui-doc-enable t))))
;;
;;    ;; install LSP company backend for LSP-driven completion
;;    (use-package company-lsp
;;      :config
;;      ;; avoid, as this changes it globally
;;      ;; do it in the major mode instead
;;      ;; (push 'company-lsp company-backends)
;;      ;; better set it locally
;;      (add-hook 'lsp-after-open-hook
;;                #'(lambda()(add-to-list (make-local-variable 'company-backends)
;;                                        'company-lsp)))
;;      (setq company-lsp-async t
;;            company-lsp-cache-candidates t
;;            company-lsp-enable-recompletion t
;;            company-lsp-enable-snippet t)))
;;
;;  ) ;; (eq (window-system) 'x)

;;;;; Set *.pyz to open as python-mode
;; Python script archive
(add-to-list 'auto-mode-alist '("\\.pyz\\'" . python-mode))
;;;;; Set *.pywz to open as python-mode
;; Python script archive form MS-Windos
(add-to-list 'auto-mode-alist '("\\.pywz\\'" . python-mode))
;;;;; Set *.rpy to open as python-mode
;; RPython script or python script contain app or framework specific features
(add-to-list 'auto-mode-alist '("\\.rpy\\'" . python-mode))
;;;;; Set *.pyde to open as python-mode
;; Python script used by processing
(add-to-list 'auto-mode-alist '("\\.pyde\\'" . python-mode))
;;;;; Set *.pyp to open as python-mode
;; Py4D Python Plugin
(add-to-list 'auto-mode-alist '("\\.pyp\\'" . python-mode))
;;;;; Set *.pyt to open as python-mode
;; Python declaration file
(add-to-list 'auto-mode-alist '("\\.pyt\\'" . python-mode))
;;;;; Set *.ipynb to open as python-mode
;; Jupyter notebook file
(add-to-list 'auto-mode-alist '("\\.ipynb\\'" . python-mode))

;;;; C/C++
;;;;; Show trailing whitespaces
(add-hook 'c-mode-hook
      (lambda ()
        (setq show-trailing-whitespace t)))

;;;;; Outshine
(add-hook 'c-mode-hook
      (lambda ()
        (setq-local outline-regexp
            "// [*]+")))
;;                        "^//\\s-\\([*]\\{1,8\\}\\)\\s-\\(.*\\)$")))

;;;; TCL
;;;;; Show trailing whitespaces
(add-hook 'tcl-mode-hook
      (lambda ()
        (setq show-trailing-whitespace t)))

;;;;; Outshine
(add-hook 'tcl-mode-hook
      (lambda ()
        (setq-local outline-regexp
            "# [*]+")))

;;;;; Set *.xdc to open as tcl-mode
;; URL: http://ergoemacs.org/emacs/emacs_auto-activate_a_major-mode.html
;; setup files ending in *.xdc to open in tcl-mode
(add-to-list 'auto-mode-alist '("\\.xdc\\'" . tcl-mode))

;;;;; Set *.ucf to open as tcl-mode
;; URL: http://ergoemacs.org/emacs/emacs_auto-activate_a_major-mode.html
;; setup files ending in *.ucf to open in tcl-mode
(add-to-list 'auto-mode-alist '("\\.ucf\\'" . tcl-mode))

;;;;; Set *.bd to open as tcl-mode
;; Open Xilinx block design as TCL file
(add-to-list 'auto-mode-alist '("\\.bd\\'" . tcl-mode))

;;;;; Set *.ip to open as tcl-mode
;; Open Xilinx IPcore as TCL file
(add-to-list 'auto-mode-alist '("\\.ip\\'" . tcl-mode))

;;;; Matlab
;; install matlab mode
;;(require 'matlab-mode)

;; include libraries
;; https://blogs.mathworks.com/community/2009/09/14/matlab-emacs-integration-is-back/

;; https://www.emacswiki.org/emacs/MatlabMode
;;(autoload 'matlab-mode "matlab" "Matlab Editing Mode" t)
;;(add-to-list
;; 'auto-mode-alist
;; '("\\.m$" . matlab-mode))
;;(setq matlab-indent-function t)
;;(setq matlab-shell-command "matlab")

;;; Help
(when (file-exists-p (format "%s/.emacs.d/my_help.el" MyHomeDir))
      (load-file (format "%s/.emacs.d/my_help.el" MyHomeDir)))
