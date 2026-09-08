;;; init-local.el --- custom config -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(defun my-query-ip ()
  "Query ip's info."
  (interactive)
  (let* ((ip-clipboard (or (evil-get-register ?+ t) ""))
         (ip (if (string-match-p (rx bos (= 3 (+ digit) ".") (+ digit) eos) ip-clipboard)
                 ip-clipboard
               (read-string "IP:")))
         (api-url (format "https://ip9.com.cn/get?ip=%s" (url-hexify-string ip))))
    (url-retrieve
     api-url
     (lambda (status)
       (goto-char (point-min))
       (when (search-forward "\n\n" nil t)
         (let* ((resp (buffer-substring-no-properties (point) (point-max)))
                (data (gethash "data" (json-parse-string resp))))
           (message "IP: %s\nAddress: %s-%s-%s"
                    (gethash "ip" data)
                    (gethash "country" data)
                    (gethash "prov" data)
                    (gethash "city" data) )))))))




(provide 'init-local)
;;; init-local.el ends here
