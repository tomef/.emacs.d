;; Cask
    (let ((default-directory "~/.emacs.d/"))
      (normal-top-level-add-subdirs-to-load-path))
    (require 'cask "~/.cask/cask.el")
    (cask-initialize)

;; Start Emacs maximized
;; DEPENDENCY: wmctrl
    (defun switch-full-screen ()
          (interactive)
          (shell-command (concat "wmctrl -i -r " (frame-parameter nil 'outer-window-id) " -btoggle,maximized_vert,maximized_horz")))
    (switch-full-screen)
    ; Make it toggle-able
    (global-set-key [f11] 'switch-full-screen)

;; ADD EVIL
;; Fix C-u page-up sort of behavior from vim - has to load before evil
    (setq evil-want-C-u-scroll t)
    (add-to-list 'load-path "~/.emacs.d/evil")
    (require 'evil)
    (evil-mode 1)

;; Colors
    (add-to-list 'load-path "/usr/share/emacs/site-lisp/emacs-goodies-el/color-theme.el")
    (require 'color-theme)
    (eval-after-load "color-theme"
      '(progn
         (color-theme-initialize)
         ;(color-theme-hober))
      ))

;; Require list
    (mapc
     'require
     '(
       smex
       auto-complete
       ;inf-mongo
       powerline
       itail
       key-chord
       kill-ring-search
       ido
       ido-ubiquitous
       linum-relative ; here: https://github.com/coldnew/linum-relative
       magit
       custom
       simp
       my-functions
       my-keybindings
       my-hooks
       my-add-to-lists
       my-project-definitions
       my-settings
       my-initializers))

;; Add sass to path
    (setq exec-path (cons (expand-file-name "/usr/local/bin") exec-path))
    (add-to-list 'load-path (expand-file-name "~/.emacs.d"))
    (autoload 'scss-mode "scss-mode")
    (add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))

;; Powerline tweaked for EVIL
    (powerline-center-evil-theme)

;; Aww yis relative line numbers
    (global-linum-mode 1)
    (setq linum-format 'linum-relative)

;; Set up and define some EVIL keychords
    (key-chord-mode 1)
    (setq key-chord-two-keys-delay 0.7)
    (key-chord-define evil-insert-state-map "jj" 'evil-normal-state)

;; Port over the vim newlining
    (defun newline-before ()
      "Create a newline before the current line without leaving normal mode.
       Intended for use with EVIL"
      (interactive)
      (move-beginning-of-line 1)
      (newline))

    (defun newline-after ()
      "Create a newline after the current line without leaving normal mode.
       Intended for use with EVIL"
      (interactive)
      (move-beginning-of-line 1)
      (next-line)
      (newline)
      (previous-line)
      (previous-line))

    (define-key evil-motion-state-map "zk" 'newline-before)
    (define-key evil-motion-state-map "zj" 'newline-after)

;; change mode-line color by evil state
   (lexical-let ((default-color (cons (face-background 'mode-line)
                                      (face-foreground 'mode-line))))
     (add-hook 'post-command-hook
       (lambda ()
         (let ((color (cond ((minibufferp) default-color)
                            ((evil-insert-state-p) '("#e80000" . "#ffffff"))
                            ((evil-emacs-state-p)  '("#444488" . "#ffffff"))
                            ((buffer-modified-p)   '("#006fa0" . "#ffffff"))
                            (t default-color))))
           (set-face-background 'mode-line (car color))
           (set-face-foreground 'mode-line (cdr color))))))

;; I'll look at this someday
    (require-maybe 'my-local)
    (require-maybe 'emux-session)

;; Simp
    (simp-project-define
     '(:has (.git)
       :ignore (.git)))

    (simp-project-define
     '(:has (.git Gemfile)
       :ignore (tmp .git vendor log public)))

    (global-set-key (kbd "C-c f") 'simp-project-find-file)
    (global-set-key (kbd "C-c d") 'simp-project-root-dired)
    (global-set-key (kbd "C-c s") 'simp-project-rgrep)
    (global-set-key (kbd "C-c S") 'simp-project-rgrep-dwim)
    (global-set-key (kbd "C-c b") 'simp-project-ibuffer-files-only)
    (global-set-key (kbd "C-c B") 'simp-project-ibuffer)
    (global-set-key (kbd "C-c C-f") 'simp-project-with-bookmark-find-file)
    (global-set-key (kbd "C-c C-s") 'simp-project-with-bookmark-rgrep)
    (global-set-key (kbd "C-c C-b") 'simp-project-with-bookmark-ibuffer)

;; I want to see my cursor
    (setq evil-default-cursor '("white" box))

;; Ditch autosave
    (setq auto-save-default nil)
;; Scroll just one line when hitting bottom of window
    (setq scroll-conservatively 10000)
;; Have a five-line buffer away from the bottom while scrolling
    (setq scroll-margin 5)
