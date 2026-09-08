;;; init-transient.el --- Transient menus       -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'transient)

(transient-define-prefix my-transient-launcher ()
  "Quick launcher menu"
  [["Quick"
    ("a" "Prose mode" prose-mode)
    ("p" "Pomodoro" org-pomodoro)]
   ["Service"
    ("d" "Docker" (lambda () (interactive) (shell-command "sudo rc-service -N docker start")))
    ("z" "Zerotier" (lambda () (interactive) (shell-command "sudo rc-service zerotier restart")))
    ("n" "Nginx" (lambda () (interactive) (shell-command "sudo rc-service nginx restart")))]
   ["Network"
    ("g" "Gnus" gnus)
    ("e" "Eglot" eglot)
    ("j" "Webjump" webjump)]
   ["Sub-menu"
    ("t" "Toggle" my-transient-toggle)
    ("w" "Window" my-transient-window)
    ("m" "Describe" my-transient-describe)
    ("q" "Quit" transient-quit-one)]])

(global-set-key (kbd "C-c C-y") 'my-transient-launcher)

;; gnus-summary-mode
(with-eval-after-load 'gnus-sum
  (transient-define-prefix my-transient-gnus-summary ()
    "Gnus summary"
    [["Actions"
      ("s" "Show thread" gnus-summary-show-thread)
      ("h" "Hide thread" gnus-summary-hide-thread)
      ("n" "Refresh" gnus-summary-insert-new-articles)
      ("F" "Forward" gnus-summary-mail-forward)
      ("!" "Mail -> disk" gnus-summary-tick-article-forward)
      ("c" "Read all" gnus-summary-catchup-and-exit)
      ("e" "Resend" gnus-summary-resend-message-edit)
      ("R" "Reply with original" gnus-summary-reply-with-original)
      ("r" "Reply" gnus-summary-reply)
      ("W" "Reply all with original" gnus-summary-wide-reply-with-original)
      ("w" "Reply all" gnus-summary-wide-reply)
      ("d" "Delete article" gnus-summary-delete-article)
      ("#" "Mark" gnus-summary-mark-as-processable)
      ("A" "Show raw article" gnus-summary-show-raw-article)
      ("q" "Quit" transient-quit-one)]])

  (define-key gnus-summary-mode-map "y" 'my-transient-gnus-summary))

;; gnus-article-mode
(with-eval-after-load 'gnus-art
  (transient-define-prefix my-transient-gnus-article ()
    "Gnus article"
    [["Actions"
      ("F" "Forward" gnus-summary-mail-forward)
      ("r" "Reply" gnus-summary-reply)
      ("R" "Reply with original" gnus-article-reply-with-original)
      ("w" "Reply all" gnus-summary-wide-reply)
      ("W" "Reply all with original" gnus-article-wide-reply-with-original)
      ("o" "Save attachment" (lambda () (interactive)
                               (let* ((file (gnus-mime-save-part)))
                                 (when file (copy-yank-str file)))))
      ("q" "Quit" transient-quit-one)]])

  (define-key gnus-article-mode-map "y" 'my-transient-gnus-article))

;; message-mode
(with-eval-after-load 'message
  (transient-define-prefix my-transient-message ()
    "Message"
    [["Mail"
      ("d" "Save to draft" message-dont-send)
      ("a" "Attach file" mml-attach-file)
      ("s" "Send mail" message-send-and-exit)
      ("H" "Convert to html" org-mime-htmlize)
      ("p" "Paste image" yank-media)
      ("q" "Quit" transient-quit-one)]])

  (defun message-mode-hook-transient-setup ()
    (local-set-key (kbd "C-c C-y") 'my-transient-message))
  (add-hook 'message-mode-hook 'message-mode-hook-transient-setup))

;; dired
(with-eval-after-load 'dired
  (defun my-replace-dired-base (base)
    "Change file name in `wdired-mode'"
    (let* ((fp (dired-file-name-at-point))
           (fb (file-name-nondirectory fp))
           (ext (file-name-extension fp))
           (dir (file-name-directory fp))
           (nf (concat base "." ext)))
      (when (yes-or-no-p (format "%s => %s at %s?"
                                 fb nf dir))
        (rename-file fp (concat dir nf)))))
  (defun my-copy-file-info (fn)
    "Copy file or directory info."
    (let* ((file-name (dired-file-name-at-point)))
      (when (file-directory-p file-name)
        (setq file-name (directory-file-name file-name)))
      (message "%s => clipboard & yank ring"
               (copy-yank-str (funcall fn file-name)))))

  (transient-define-prefix my-transient-dired ()
    "Dired"
    [["Misc"
      ("+f" "Create File" find-file)
      ("+d" "Create Directory" dired-create-directory)
      ("m" "Mark regexp" dired-mark-files-regexp)]
     ["File"
      ("c" "Copy" dired-do-copy)
      ("r" "Move" dired-do-rename)
      ("R" "Read-only" dired-toggle-read-only)
      ("b" "Change base" (lambda () (interactive) (my-replace-dired-base (car kill-ring))))
      ("f" "Find" consult-fd)]
     ["Copy Info"
      ("yp" "Path" (lambda () (interactive) (my-copy-file-info 'file-truename)))
      ("yn" "Name" (lambda () (interactive) (my-copy-file-info 'file-name-nondirectory)))
      ("yb" "Base name" (lambda () (interactive) (my-copy-file-info 'file-name-base)))
      ("yd" "Directory" (lambda () (interactive) (my-copy-file-info 'file-name-directory)))
      ("q" "Quit" transient-quit-one)]])

  (defun dired-mode-hook-transient-setup ()
    (local-set-key (kbd "y") 'my-transient-dired))
  (add-hook 'dired-mode-hook 'dired-mode-hook-transient-setup))

;; zoom - font size in GUI emacs
(when (display-graphic-p)
  (transient-define-prefix my-transient-zoom ()
    "Zoom"
    :transient-suffix t
    [["Zoom"
      ("g" "in" text-scale-increase)
      ("l" "out" text-scale-decrease)
      ("r" "reset" (lambda () (interactive) (text-scale-set 0)))
      ("q" "Quit" transient-quit-one)]])
  (global-set-key (kbd "<f2>") 'my-transient-zoom))

;; toggle
(transient-define-prefix my-transient-toggle ()
  "Toggle menu"
  :transient-suffix t
  [["Toggles"
    ("p" "paredit-mode"
     (lambda () (interactive) (paredit-mode 'toggle))
     :description (lambda (_)
                    (format "paredit-mode: %s" paredit-mode)))
    ("e" "electric-pair-local-mode"
     (lambda () (interactive) (electric-pair-local-mode 'toggle))
     :description (lambda (_)
                    (format "electric-pair-mode: %s" electric-pair-mode)))
    ("a" "abbrev-mode"
     (lambda () (interactive) (abbrev-mode 'toggle))
     :description (lambda (_)
                    (format "abbrev-mode: %s" abbrev-mode)))
    ("d" "debug-on-error" toggle-debug-on-error
     :description (lambda (_)
                    (format "debug-on-error: %s" debug-on-error)))
    ("f" "auto-fill-mode"
     (lambda () (interactive) (auto-fill-mode 'toggle))
     :description (lambda (_)
                    (format "auto-fill: %s" auto-fill-function)))
    ("t" "truncate-lines" toggle-truncate-lines
     :description (lambda (_)
                    (format "truncate-lines: %s" truncate-lines)))
    ("w" "whitespace-mode"
     (lambda () (interactive) (whitespace-mode 'toggle))
     :description (lambda (_)
                    (format "whitespace-mode: %s" whitespace-mode)))
    ("i" "indent-tabs-mode"
     (lambda ()
       (interactive)
       (setq indent-tabs-mode (not indent-tabs-mode)))
     :description (lambda (_)
                    (format "indent-tabs-mode: %s" indent-tabs-mode)))
    ("v" "visible-mode"
     (lambda () (interactive) (visible-mode 'toggle))
     :description (lambda (_)
                    (format "visible-mode: %s" visible-mode)))
    ("q" "Quit" transient-quit-all)]])


;; window management helpers
(defun hydra-move-split-left (arg)
  "Move window split left."
  (interactive "p")
  (if (let* ((windmove-wrap-around))
        (windmove-find-other-window 'right))
      (shrink-window-horizontally arg)
    (enlarge-window-horizontally arg)))

(defun hydra-move-split-right (arg)
  "Move window split right."
  (interactive "p")
  (if (let* ((windmove-wrap-around))
        (windmove-find-other-window 'right))
      (enlarge-window-horizontally arg)
    (shrink-window-horizontally arg)))

(defun hydra-move-split-up (arg)
  "Move window split up."
  (interactive "p")
  (if (let* ((windmove-wrap-around))
        (windmove-find-other-window 'up))
      (enlarge-window arg)
    (shrink-window arg)))

(defun hydra-move-split-down (arg)
  "Move window split down."
  (interactive "p")
  (if (let* ((windmove-wrap-around))
        (windmove-find-other-window 'up))
      (shrink-window arg)
    (enlarge-window arg)))

(transient-define-prefix my-transient-window ()
  "Window management"
  :transient-suffix t
  [["Movement"
    ("h" "Left" windmove-left)
    ("j" "Down" windmove-down)
    ("k" "Up" windmove-up)
    ("l" "Right" windmove-right)
    ("SPC" "Quit" transient-quit-all)]
   ["Split"
    ("v" "Vertical" (lambda () (interactive) (split-window-right) (windmove-right)))
    ("x" "Horizontal" (lambda () (interactive) (split-window-below) (windmove-down)))]
   ["Toggle"
    ("f" "Follow Mode" follow-mode)
    ("d" "Dedicate Window" toggle-window-dedicated)
    ("s" "Save" save-buffer)]
   ["Resize"
    ("q" "← Left" hydra-move-split-left)
    ("w" "↓ Down" hydra-move-split-down)
    ("e" "↑ Up" hydra-move-split-up)
    ("r" "→ Right" hydra-move-split-right)]])

;; git
(transient-define-prefix my-transient-git ()
  "Git"
  [["Git"
    ("g" "Status" magit-status)
    ("dd" "Diff dwim" magit-diff-dwim)
    ("dc" "Diff staged" magit-diff-staged)
    ("au" "Add modified" magit-stage-modified)
    ("cc" "Commit" magit-commit-create)
    ("ca" "Amend" magit-commit-amend)
    ("tt" "Stash" magit-stash)
    ("ta" "Apply stash" magit-stash-apply)
    ("l" "Log file" magit-log-buffer-file)
    ("b" "Branches" magit-show-refs)
    ("k" "Commit link" git-link)
    ("q" "Quit" transient-quit-one)]])

;; describe
(transient-define-prefix my-transient-describe ()
  "Describe something"
  [["Describe"
    ("a" "All help" help)
    ("b" "Bindings" describe-bindings)
    ("c" "Char" describe-char)
    ("C" "Coding system" describe-coding-system)
    ("f" "Function" describe-function)
    ("i" "Input method" describe-input-method)
    ("k" "Key briefly" describe-key-briefly)
    ("K" "Key" describe-key)
    ("l" "Language environment" describe-language-environment)
    ("m" "Major mode" describe-mode)
    ("M" "Minor mode" describe-minor-mode)
    ("n" "Coding system briefly" describe-current-coding-system-briefly)
    ("N" "Coding system full" describe-current-coding-system)
    ("o" "Lighter indicator" describe-minor-mode-from-indicator)
    ("O" "Lighter symbol" describe-minor-mode-from-symbol)
    ("p" "Package" describe-package)
    ("P" "Text properties" describe-text-properties)
    ("s" "Symbol" describe-symbol)
    ("t" "Theme" describe-theme)
    ("v" "Variable" describe-variable)
    ("w" "Where is" where-is)
    ("q" "Quit" transient-quit-all)]])

(provide 'init-transient)
;;; init-transient.el ends here
