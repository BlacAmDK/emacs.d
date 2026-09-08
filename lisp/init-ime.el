;;; init-ime.el --- IME Setup -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(when (maybe-require-package 'rimel)
  (with-eval-after-load 'rimel
    (advice-add 'rimel-input-method :around #'kkp-restore-legacy-keys))
  (setopt default-input-method "rimel"
          liberime-user-data-dir "~/.local/share/fcitx5/rime"
          liberime-auto-build t
          rimel-schema "rime_ice")
  (setq rimel-disable-predicates '(rimel-predicate-prog-in-code-p
                                   rimel-predicate-after-alphabet-char-p
                                   rimel-predicate-current-uppercase-letter-p
                                   rimel-predicate-evil-mode-p
                                   rimel-predicate-org-in-src-block-p)))

(provide 'init-ime)
;;; init-ime.el ends here
