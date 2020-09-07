;; configure example
;; 
;; (require 'helm-mew-summary)
;; (define-key mew-summary-mode-map (kbd "g")
;;   'helm-mew-summary-goto-folder)
;;
;; (use-helm-to-mew-refile)

(require 'helm-config)

;; ------------------------ goto folder
(defun helm-mew-summary-goto-folder()
  "helm interface for mew-summary-goto-folder (which is bind to
  `g' in default)"
  (interactive)
  (helm :sources helm-mew-folder-source
	:prompt "Folder Name: "
	:preselect "%inbox"
	))

(defvar helm-mew-folder-source
      (helm-build-sync-source
	  "Folders"
	:candidates (lambda ()
		      (append
		       (mew-local-folder-alist)
		       (mapcar 'car (helm-mew-imap-current-folder-alist))))
	:action 'mew-summary-visit-folder
    ))

;; ------------------------ refile
(defun use-helm-to-mew-refile ()
  "overwride `mew-input-refile-folders', that use on
  `mew-summary-refile' (binded to `o' on default)->
  `mew-summary-refile-body' -> `mew-refile-decide-folders' ->
  `mew-input-refile-folders'"
  (defun mew-input-refile-folders (folder-list singlep case proto)
    (helm-mew-input-refile-folders folder-list)
    ))

(defun helm-mew-input-refile-folders (folder-list)
  (interactive)
    (helm
     :sources '(helm-mew-refile-source helm-mew-refile-fallback-source)
     :prompt "Folder Name: "
     :preselect (car folder-list)
     ))

(defvar helm-mew-refile-source
  (helm-build-sync-source
      "Refile Folder"
    :candidates (lambda ()
		  (mapcar 'car (helm-mew-imap-current-folder-alist)))
    :action 'helm-mew-refile-action
    ))

(defvar helm-mew-refile-fallback-source
  (helm-build-dummy-source
      "Create Folder"
    :action 'helm-mew-refile-action
    )
  "Even if enter an input that is not in candidates, do the same
   action (creates a folder in `mew-refile-folder-check' function
   in `mew-refile-decide-folders')"
  )

(defun helm-mew-refile-action (folder)
  (let*
      ;; FIXME: `proto' is not function-local variable
      ((proto-is-imap (mew-folder-imapp proto))
       ;; add '%' to head when protocol is imap and `folder' is not
       ;; start with '%'
       (folder (if (and proto-is-imap (not (mew-folder-imapp folder)))
		   (concat "%" folder)
       		 folder)))
    ;; extract from original `mew-input-refile-folders' function
    (mew-input-refile-folder-check
     (mapcar 'mew-chop (mew-split folder ?,))
     (if proto-is-imap 'imap 'local)
     )))

;; ------------------------ utility function
(defun helm-mew-imap-current-folder-alist ()
  (mew-imap-folder-alist
   (if (mew-case-default-p mew-case)
       "" mew-case)))

(provide 'helm-mew-summary)
