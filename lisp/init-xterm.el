;;; init-xterm.el --- Integrate with terminals such as xterm -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(require 'init-frame-hooks)

(global-set-key [mouse-4] (lambda () (interactive) (scroll-down 1)))
(global-set-key [mouse-5] (lambda () (interactive) (scroll-up 1)))

(autoload 'mwheel-install "mwheel")

(defun sanityinc/console-frame-setup ()
  (xterm-mouse-mode 1) ; Mouse in a terminal (Use shift to paste with middle button)
  (mwheel-install))



(add-hook 'after-make-console-frame-hooks 'sanityinc/console-frame-setup)


(unless (display-graphic-p)
  (setopt cjk-ambiguous-chars-are-wide nil)
  (setq-default auto-composition-mode nil)
  ;; (package-vc-install "https://github.com/cashmeredev/kitty-graphics.el")
  ;; (when (maybe-require-package 'kitty-graphics)
  ;;   (kitty-graphics-setup))

  )

(require-package 'kkp)
;; (setopt kkp-restore-legacy-keys-around-subprocesses t)
(add-hook 'tty-setup-hook #'global-kkp-mode)




(provide 'init-xterm)
;;; init-xterm.el ends here
