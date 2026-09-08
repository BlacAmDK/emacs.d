;;; init-translate.el --- Translate tools -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


(when (maybe-require-package 'gt)
  (with-eval-after-load 'gt
    (require 'gt-core)
    (defclass gt-mtrans-parser (gt-parser) ())
    (defclass gt-mtrans-engine (gt-api-engine)
      ((tag  :initform 'MTrans)
       (host :initform "http://127.0.0.1:8989")
       (path :initform "/translate")
       (key  :initform "ALiwf872nvVKBk3rbvq")
       (parse :initform (gt-mtrans-parser))))
    (cl-defmethod gt-execute ((engine gt-mtrans-engine) task)
      (with-slots (text src tgt) task
        (with-slots (host path key rate-limit) engine
          (let ((url (concat host path)))
            (gt-dolist-concurrency (item text rate-limit)
                                   (gt-request url
                                               :cache (if pdd-active-cacher `(t mtrans ,src ,tgt ,item))
                                               :headers `(json-u8 ("Authorization" . ,key))
                                               :data `(("text" . ,item)
                                                       ("from" . ,src)
                                                       ("to"   . ,tgt)
                                                       ("html" . "false"))))))))
    (cl-defmethod gt-parse ((_ gt-mtrans-parser) task)
      (cl-loop for item in (oref task res)
               collect (cdr (assoc 'result item)) into lst
               finally (oset task res lst)))


    (setq gt-langs '(en zh))
    (setq gt-preset-translators
          `((buffer . ,(gt-translator
                        :taker (gt-taker :text 'buffer :pick 'paragraph)
                        :engines (gt-mtrans-engine)
                        :render (gt-buffer-render)
                        ))
            (word . ,(gt-translator
                      :taker (gt-taker :text 'word)
                      :engines (gt-mtrans-engine)
                      :render (gt-overlay-render)))))))

(provide 'init-translate)
;;; init-translate.el ends here
