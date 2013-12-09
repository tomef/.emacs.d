(let ((default-directory "~/.emacs.d/"))
  (normal-top-level-add-subdirs-to-load-path))
(require 'cask "~/.cask/cask.el")

(cask-initialize)

(mapc
 'require
 '(
   smex
   auto-complete
   inf-mongo
   powerline
   itail
   kill-ring-search
   ido
   ido-ubiquitous
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

(require-maybe 'my-local)
(require-maybe 'emux-session)
;;(dired "~/.emacs.d")

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
