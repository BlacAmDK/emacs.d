;;; init-dired.el --- Dired customisations -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(setq-default dired-dwim-target t)

;; Prefer g-prefixed coreutils version of standard utilities when available
(let ((gls (executable-find "gls")))
  (when gls (setq insert-directory-program gls)))

(when (maybe-require-package 'diredfl)
  (with-eval-after-load 'dired
    (diredfl-global-mode)
    (require 'dired-x)))

;; Hook up dired-x global bindings without loading it up-front
(define-key ctl-x-map "\C-j" 'dired-jump)
(define-key ctl-x-4-map "\C-j" 'dired-jump-other-window)

(with-eval-after-load 'dired
  (setq dired-recursive-deletes 'top)
  (setopt wdired-allow-to-change-permissions t)
  (setopt dired-listing-switches "--group-directories-first -aBhl")

  (defun my/dired-create-file-or-directory (path)
    "Create file or directory in the current working directory.

 Create file or directory using PATH as a path to the new file or
 directory. The directory path should contain trailing slash at the end."
    (interactive "GCreate new file or directory: ")
    (if (or (file-exists-p path)
            (file-directory-p path))
        (message "Error: '%s' already exists." path))
    (if (string-match "/$" path)
        (dired-create-directory path)
      (dired-create-empty-file path)))
  (define-key dired-mode-map (kbd "+") 'my/dired-create-file-or-directory)
  (define-key dired-mode-map [mouse-2] 'dired-find-file)
  (define-key dired-mode-map (kbd "C-c C-q") 'wdired-change-to-wdired-mode))

(when (maybe-require-package 'diff-hl)
  (with-eval-after-load 'dired
    (add-hook 'dired-mode-hook 'diff-hl-dired-mode)))

(provide 'init-dired)
;;; init-dired.el ends here
