(require 'tls)
(require 'erc)

(setq my-erc-identities '("bion@substantial.com" "bionjohnson@gmail.com"))
(setq my-erc-flowdock-nickname "@adam")

(setq erc-current-nick-highlight-type 'nick)
(setq erc-keywords '("@bion" "@all" "@everyone"))
(setq erc-track-use-faces t)
(setq erc-track-faces-priority-list
      '(erc-current-nick-face erc-keyword-face))
(setq erc-track-priority-faces-only 'all)

(defun my-erc-pop-mention (&rest ignore)
  (let ((buffer (erc-track-get-active-buffer 1))
        (active-minibuffer (active-minibuffer-window)))
    (when buffer
      (when active-minibuffer
        (next-in-frame-window))
      (if (>= 10 (window-height))
          (window-resize (get-buffer-window) 10))
      (split-window-below -10)
      (other-window 1)
      (erc-track-switch-buffer 1)
      (if active-minibuffer
          (switch-to-buffer active-minibuffer)
        (other-window -1)))))
(add-hook 'erc-track-list-changed-hook 'my-erc-pop-mention)

(defun my-erc-identify ()
  (interactive)
  (let* ((identity
          (completing-read
           "identity: " my-erc-identities nil nil nil nil
           (first my-erc-identities)))
         (password (read-passwd "password: "))
         (command (format "/msg NickServ identify %s %s" identity password)))
    (erc-load-irc-script-lines (list command))
    (let ((inhibit-read-only t))
      (buffer-disable-undo)
      (erase-buffer)
      (buffer-enable-undo))))

(defun my-erc-flowdock ()
  (interactive)
  (erc-tls :server "irc.flowdock.com" :port 6697))

(provide 'my-erc)
