(setq lexical-binding t)

(defvar my-packages
  '(use-package))

(package-initialize)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))

(require 'cl-lib)

(when (cl-find-if (lambda (p) (not (package-installed-p p))) my-packages)
  (package-refresh-contents))

(dolist (pack my-packages)
  (unless (package-installed-p pack)
    (package-install pack)))

(require 'use-package)

(use-package better-defaults
  :ensure t)
(use-package company
  :init (run-with-timer 0 nil (lambda () (global-company-mode t)))
  :ensure t)
(use-package custom
  :init (setq custom-file "~/.emacs.d/custom.el"))
(use-package eldoc
  :commands eldoc-mode)
(use-package evil
  :bind (:map evil-normal-state-map
              (";" . evil-ex))
  :config (progn
            (defun my-send-string-to-terminal (string)
              (unless (display-graphic-p) (send-string-to-terminal string)))

            (defun my-evil-terminal-cursor-change ()
              (when (string= (getenv "TERM_PROGRAM") "iTerm.app")
                (add-hook 'evil-insert-state-entry-hook
                          (lambda () (my-send-string-to-terminal "\e]50;CursorShape=1\x7")))
                (add-hook 'evil-insert-state-exit-hook
                          (lambda () (my-send-string-to-terminal "\e]50;CursorShape=0\x7")))))

            (add-hook 'after-make-frame-functions (lambda (frame) (my-evil-terminal-cursor-change)))
            (my-evil-terminal-cursor-change))
  :ensure t
  :init (evil-mode t))
(use-package evil-ediff
  :ensure t)
(use-package ido
  :config (progn
            (ido-mode t)
            (use-package flx-ido
              :config (flx-ido-mode t)
              :ensure t)
            (use-package ido-ubiquitous
              :config (ido-ubiquitous-mode)
              :ensure t)
            (use-package ido-vertical-mode
              :config (ido-vertical-mode)
              :ensure t))
  :ensure t)
(use-package less-css-mode
  :defer t
  :ensure t)
(use-package lisp-mode
  :config (progn
            (add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
            (add-hook 'lisp-interaction-mode-hook 'eldoc-mode)))
(use-package magit
  :config (progn
            (setq evil-magit-want-horizontal-movement t)
            (setq magit-fetch-arguments '("--prune"))
            (use-package evil-magit
              :ensure t)
            (use-package magit-gh-pulls
              :defer t
              :ensure t)
            (add-hook 'magit-mode-hook 'turn-on-magit-gh-pulls)
            (setq magit-completing-read-function 'magit-ido-completing-read
                  magit-status-buffer-switch-function 'switch-to-buffer)
            (defun my-magit-section-visibility (section)
              (and (member (magit-section-type section) '(pulls stashes)) 'hide))
            (add-hook 'magit-section-set-visibility-hook 'my-magit-section-visibility))
  :ensure t)
(use-package nlinum
  :config (global-nlinum-mode t)
  :ensure t)
(use-package smex
  :bind ("M-x" . smex)
  :ensure t)
(use-package spacemacs-theme
  :defer t
  :ensure t
  :init (load-theme 'spacemacs-dark t nil))

(setq column-number-mode t)

(defun startup-magit ()
  (magit-status)
  (delete-other-windows))