# helm-mew-summary
helm interface for mew-summary-mode
configure example

# Requirements

- [helm](https://github.com/emacs-helm/helm)
- [mew](https://github.com/kazu-yamamoto/Mew)

# Configure example

Add following to your configure file

```emacs-lisp
(require 'helm-mew-summary)
(define-key mew-summary-mode-map (kbd "g")
  'helm-mew-summary-goto-folder)

(use-helm-to-mew-refile)
```
