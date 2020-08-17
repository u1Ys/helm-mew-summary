;; configure example
;; 
;; (require 'helm-mew-summary)
;; (define-key mew-summary-mode-map (kbd "g")
;;   'helm-mew-summary-goto-folder)
;; (define-key mew-summary-mode-map (kbd "G")
;;   'mew-summary-goto-folder)

(require 'helm-config)

(defun helm-mew-summary-goto-folder()
  "helm interface for mew-summary-goto-folder (which is bind to 'g' in default)"
  (interactive)
  (helm :sources helm-mew-folder-source
	:prompt "Folder Name: "
	:preselect "%inbox"
	))

(defvar helm-mew-folder-source
  '((name . "helm mew folder")
    (candidates . (lambda ()
		    (append
		     (mew-local-folder-alist)
		     (mapcar 'car (mew-imap-folder-alist
				   (if (mew-case-default-p mew-case)
				       "" mew-case)))
		     )))
    (action . mew-summary-visit-folder)
    ))

(provide 'helm-mew-summary)

