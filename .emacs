;(load-theme 'tsdh-dark t)

;(load-file "/usr/share/emacs/site-lisp/xcscope/xcscope.el")
;(load-file "~/src/tools/editors/emacs/etags-select.el")
;(load-file "~/src/tools/editors/emacs/style.el")

;(require 'xcscope)

(global-auto-revert-mode t)
(url-handler-mode t)
(line-number-mode 1)
(column-number-mode 1)

;Only allow vertical panes
(setq split-height-threshold nil)

;Override default tagging engine
(global-set-key "\M-?" 'etags-select-find-tag-at-point)
(global-set-key "\M-." 'etags-select-find-tag)
(global-set-key "\M-*" 'pop-tag-mark)

;VirtualBox terminal fix
;(add-hook 'isearch-update-post-hook 'redraw-display)

;Backup of files works with hardlinks
(setq backup-by-copying-when-linked t)

;Don't leave garbage everywhere
(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default nil) ; stop creating #autosave# files

;Always reflow to 100 characters wide
(setq-default fill-column 100)

;Package management
(require 'package)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;Make helm always default to src
(defun my_helm ()
  (interactive)
  (setq default-directory "~/src")
  (helm-find 'ask-for-dir)
)
(global-set-key (kbd "C-c o f") 'my_helm)

;Don't try to do smart things with hg merge
(setq vc-handled-backends nil)

;fzf added this stuff automatically
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (markdown-mode rust-mode projectile helm-fuzzy-find fzf))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq linum-format "%d ")
(global-linum-mode)
