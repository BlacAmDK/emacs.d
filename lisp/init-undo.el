;;; init-undo.el --- Undo/redo tree -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(require-package 'undo-fu)

(require-package 'undo-fu-session)
(undo-fu-session-global-mode t)

(require-package 'vundo)


(provide 'init-undo)
;;; init-undo.el ends here
