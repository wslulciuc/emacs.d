;;; custom-org.el --- Setup for org-mode
;;; Commentary:
;;
;; Copyright (C) 2016  Lincoln de Sousa <lincoln@comum.org>
;;
;;; Code:

(require 'org)
(require 'org-agenda)
(require 'org-bullets)
(require 'org-gcal)
(require 'custom-auth)

(defun custom-org-directory-dirs (dir)
  "List directories recursively inside of DIR."
  (let ((dirs (delq nil
                    (mapcar (lambda (p) (and (file-directory-p p) p))
                            (directory-files
                             dir t directory-files-no-dot-files-regexp)))))
    (push (expand-file-name dir) dirs)))


(defun custom-org-utf-8-bullet ()
  "Replace asterisk chars with sexy UTF-8 Bullets."
  (font-lock-add-keywords
   'org-mode
   '(("^ +\\([-*]\\) "
      (0 (prog1 ()
           (compose-region (match-beginning 1) (match-end 1) "•")))))))


(defun custom-org-keys ()
  "Key bindings for the `org-mode'."
  (define-key global-map "\C-cl" 'org-store-link)
  (define-key global-map "\C-ca" 'org-agenda))


(defun custom-org-bullets ()
  "Enable and configure `org-bullets' with custom icons."
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  (setq org-bullets-bullet-list '("▶" "▸" "▹" "▹")))


(defun custom-org-workflow ()
  "Set a kanban-ish workflow for managing TODO items."
  (setq org-todo-keywords
    '((sequence "TODO" "DOING" "BLOCKED" "|" "DONE" "ARCHIVED")))
  (setq org-todo-keyword-faces
        '(("TODO" . "red")
          ("DOING" . "yellow")
          ("BLOCKED" . org-warning)
          ("DONE" . "green")
          ("ARCHIVED" .  "blue"))))


(defun custom-org-setup-gcal ()
  "Setup Google Calendar integration."
  (setq org-gcal-client-id (car (custom-auth-url-read-user "google-oauth"))
        org-gcal-client-secret (car (custom-auth-url-read-password "google-oauth"))
        org-gcal-file-alist
        '(("lincoln@canary.is" . "~/org/Calendar/lincoln@canary.is.org"))))


(defun custom-org ()
  "Configuration for the `org-mode'."
  (custom-org-keys)
  (custom-org-utf-8-bullet)
  (custom-org-bullets)
  (custom-org-workflow)
  (setq org-agenda-files (custom-org-directory-dirs "~/org"))
  (setq org-log-done t))


(provide 'custom-org)
;;; custom-org.el ends here
