;; configure example
;; 
;; (require 'helm-mew-summary)
;; (define-key mew-summary-mode-map (kbd "g")
;;   'helm-mew-summary-goto-folder)
;; (define-key mew-summary-mode-map (kbd "G")
;;   'mew-summary-goto-folder)

(require 'helm-config)

;; ------------------------ goto folder
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
		     (mapcar 'car (helm-mew-imap-current-folder-alist))
		     )))
    (action . mew-summary-visit-folder)
    ))

;; ------------------------ refile
(defvar use-helm-to-mew-refile 't)
(if use-helm-to-mew-refile
    (defun mew-input-refile-folders (folder-list singlep case proto)
      (helm-mew-input-refile-folders folder-list)
      ))

(defun helm-mew-input-refile-folders (folder-list)
  (interactive)
  (helm :sources helm-mew-refile-source
	:prompt "Folder Name: "
	:preselect (car folder-list)
	))

(defvar helm-mew-refile-source
      '((name . "helm refile folder")
	(candidates . (lambda ()
			(mapcar 'car (helm-mew-imap-current-folder-alist))
			))
	(action . (lambda (folder)
		    ;; extract from original
		    ;; "mew-input-refile-folders" function
		    (mew-input-refile-folder-check
		     (mapcar 'mew-chop (mew-split folder ?,))
		     'imap)
		    ))
	))

;; ------------------------ utility function
(defun helm-mew-imap-current-folder-alist ()
  (mew-imap-folder-alist
   (if (mew-case-default-p mew-case)
       "" mew-case)))

(provide 'helm-mew-summary)
