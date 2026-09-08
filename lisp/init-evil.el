;;; init-evil.el --- Use Evil Mode -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(require-package 'evil)
(setopt evil-want-C-u-scroll t)
(setopt evil-want-C-i-jump nil)
(setopt evil-undo-system 'undo-fu)
(evil-mode 1)
(evil-set-initial-state 'dired-mode 'emacs)
(evil-set-leader '(normal visual) (kbd "SPC"))
(evil-set-leader 'emacs (kbd ","))
(evil-set-leader 'insert (kbd "\\"))

(require-package 'evil-find-char-pinyin)
(evil-find-char-pinyin-mode 1)

(require-package 'evil-surround)
(global-evil-surround-mode 1)

(require-package 'evil-exchange)
(evil-exchange-install)

(require-package 'evil-numbers)
(evil-define-key '(normal visual) 'global
  (kbd "C-a") 'evil-numbers/inc-at-pt
  (kbd "g C-a") 'evil-numbers/inc-at-pt-incremental)

(defun my-dual-leader-key (fn-noarg fn-witharg)
  "Return an interactive lambda that call FN-NOARG when no prefix ARG, or FN-WITHARG when ARG is non-nil.  If ARG is 1, call FN-WITHARG without args."
  (lambda (arg)
    (interactive "P")
    (cond
     ((null arg) (call-interactively fn-noarg))
     ((= arg 1) (let ((current-prefix-arg nil))
                  (call-interactively fn-witharg)))
     (t (call-interactively fn-witharg)))))


;; general leader key
(evil-define-key '(normal visual emacs) 'global
  (kbd "<leader>x") ctl-x-map
  (kbd "<leader>c") mode-specific-map
  (kbd "<leader>h") 'help-command

  (kbd "<leader>y") 'my-transient-launcher
  (kbd "<leader>g") 'my-transient-git
  (kbd "<leader>;") 'my/avy-goto-char-timer
  (kbd "<leader>w") 'my-narrow-or-widen-dwim

  (kbd "<leader>r") 'consult-recent-file
  (kbd "<leader>b") 'consult-buffer
  (kbd "<leader>i") 'consult-imenu
  (kbd "<leader>j") 'switch-window
  (kbd "<leader>t") 'gt-translate
  (kbd "<leader>f") (my-dual-leader-key #'find-file #'project-find-file)
  (kbd "<leader>s") (my-dual-leader-key #'consult-line #'sanityinc/consult-ripgrep-at-point)
  (kbd "<leader>.") (my-dual-leader-key #'embark-act #'embark-dwim)

  (kbd "<leader>dd") 'pwd
  (kbd "<leader>u") 'vundo
  (kbd "<leader>ar") 'align-regexp
  (kbd "<leader>,") 'comment-line)

;; insert mode leader key
(evil-define-key 'insert 'global
  (kbd "<leader>p") 'browse-kill-ring
  (kbd "<leader>\\") 'paredit-backslash)

(evil-define-key 'insert org-mode-map
  (kbd "<leader>p") 'yank-media
  (kbd "<leader>r") 'org-link-preview-refresh
  (kbd "<leader>o") 'org-pandoc-export-to-docx)

(evil-define-key 'visual 'global
  (kbd "v") 'puni-expand-region
  (kbd "V") 'puni-contract-region)

(evil-define-key 'insert 'global
  (kbd "C-a") 'beginning-of-line
  (kbd "C-e") 'end-of-line)

(provide 'init-evil)
;;; init-evil.el ends here
