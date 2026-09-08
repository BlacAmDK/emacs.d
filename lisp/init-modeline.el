;;; init-modeline.el --- Modeline Settings -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(when (maybe-require-package 'doom-modeline)
  (doom-modeline-mode 1)
  (setopt doom-modeline-project-name t))

(provide 'init-modeline)
;;; init-modeline.el ends here
