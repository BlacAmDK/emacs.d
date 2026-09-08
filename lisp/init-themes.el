;;; init-themes.el --- Defaults for themes -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(require-package 'catppuccin-theme)

;; Don't prompt to confirm theme safety. This avoids problems with
;; first-time startup on Emacs > 26.3.
(setq custom-safe-themes t)

;; If you don't customize it, this is the theme you get.
(setq-default custom-enabled-themes '(catppuccin))
(setq catppuccin-flavor 'mocha)

;; Ensure that themes will be applied even if they have not been customized
(defun reapply-themes ()
  "Forcibly load the themes listed in `custom-enabled-themes'."
  (dolist (theme custom-enabled-themes)
    (unless (custom-theme-p theme)
      (load-theme theme)))
  (custom-set-variables `(custom-enabled-themes (quote ,custom-enabled-themes)))
  (setq my-theme-default-bg-color (face-background 'mode-line)))

(add-hook 'after-init-hook 'reapply-themes)

;; {{ change modeline color by evil&ime state

(defun my-color-adjust (hex &optional dir k)
  "Adjust HEX color towards direction DIR by factor K.
HEX is a color string of the form \"#rrggbb\".
DIR is one of the symbols 'red, 'blue, 'pink, 'cyan.
K is an optional float scaling factor (default 0.18).
Returns the adjusted color as a hex string, or unspecified if DIR is unrecognized."
  (let* ((x (substring hex 1))
         (r (string-to-number (substring x 0 2) 16))
         (g (string-to-number (substring x 2 4) 16))
         (b (string-to-number (substring x 4 6) 16))
         (k (or k 0.18))
         (cl (lambda (v) (max 0 (min 255 v)))))
    (pcase dir
      ('red  (format "#%02x%02x%02x" (funcall cl (+ r (* (- 255 r) k)))
                     (funcall cl (- g (* g k))) (funcall cl (- b (* b k)))))
      ('blue (format "#%02x%02x%02x" (funcall cl (- r (* r k)))
                     (funcall cl (- g (* g k))) (funcall cl (+ b (* (- 255 b) k)))))
      ('pink (format "#%02x%02x%02x" (funcall cl (+ r (* (- 255 r) k)))
                     (funcall cl (- g (* g k))) (funcall cl (+ b (* (- 255 b) k)))))
      ('cyan (format "#%02x%02x%02x" (funcall cl (- r (* r k)))
                     (funcall cl (+ g (* (- 255 g) k))) (funcall cl (+ b (* (- 255 b) k)))))
      (_ 'unspecified))))

(defun my-show-evil-state ()
  "Change modeline color to notify user evil current state."
  (let ((bg-color (cond
                   ((minibufferp) 'unspecified)
                   (current-input-method (my-color-adjust my-theme-default-bg-color 'pink))
                   ((evil-insert-state-p) (my-color-adjust my-theme-default-bg-color 'red))
                   ((evil-emacs-state-p) (my-color-adjust my-theme-default-bg-color 'blue))
                   ((string-prefix-p "*" (buffer-name)) 'unspecified)
                   ((buffer-modified-p) (my-color-adjust my-theme-default-bg-color 'cyan))
                   (t 'unspecified))))
    (set-face-attribute 'doom-modeline nil :background bg-color)))
(add-hook 'post-command-hook #'my-show-evil-state)
(add-hook 'after-save-hook #'my-show-evil-state)
;; }}



;; Toggle between light and dark

(defun light ()
  "Activate a light color theme."
  (interactive)
  (setq catppuccin-flavor 'latte)
  (catppuccin-reload)
  (reapply-themes))

(defun dark ()
  "Activate a dark color theme."
  (interactive)
  (setq catppuccin-flavor 'mocha)
  (catppuccin-reload)
  (reapply-themes))


(when (maybe-require-package 'dimmer)
  (setq-default dimmer-fraction 0.15)
  (add-hook 'after-init-hook 'dimmer-mode)
  (with-eval-after-load 'dimmer
    ;; TODO: file upstream as a PR
    (advice-add 'frame-set-background-mode :after (lambda (&rest args) (dimmer-process-all))))
  (with-eval-after-load 'dimmer
    ;; Don't dim in terminal windows. Even with 256 colours it can
    ;; lead to poor contrast.  Better would be to vary dimmer-fraction
    ;; according to frame type.
    (defun sanityinc/display-non-graphic-p ()
      (not (display-graphic-p)))
    (add-to-list 'dimmer-exclusion-predicates 'sanityinc/display-non-graphic-p)))


(provide 'init-themes)
;;; init-themes.el ends here
