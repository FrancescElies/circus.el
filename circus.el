;;; circus.el --- Control circus within emacs        -*- lexical-binding: t; -*-

;; Copyright (C) 2018  Francesc Elies

;; Author: Francesc Elies Henar <elies@posteo.net>
;; Keywords: unix, abbrev

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; See status, start, stop processes controlled by circus.
;; Circus docs https://circus.readthedocs.io/en/latest/

;; Documented commands (type help <topic>):
;; ========================================
;; add     globaloptions  kill         numprocesses  reload        set     status
;; decr    help           list         numwatchers   reloadconfig  signal  stop
;; dstats  incr           listen       options       restart       start
;; get     ipython        listsockets  quit          rm            stats

;;; Code:



(provide 'circus)

(setq my/circus-endpoint "tcp://127.0.0.1:9999")
(setq my/circusctl-path "/Users/cesc/anaconda/envs/py27/bin/")

(setq my/circusctl-cmd (s-join " "
                               `(,(concat my/circusctl-path "circusctl")
                                 "--endpoint"
                                 ,my/circus-endpoint)))
(setq my/circus-cmd-status (s-join " " `(,my/circusctl-cmd "status")))
(setq my/circus-cmd-stop (s-join " " `(,my/circusctl-cmd "stop")))
(setq my/circus-cmd-reloadconfig (s-join " " `(,my/circusctl-cmd "reloadconfig")))
(setq my/circus-cmd-start (s-join " " `(,my/circusctl-cmd "start")))
(setq my/circus-cmd-restart (s-join " " `(,my/circusctl-cmd "restart")))



(defun my/circus/start-process ()
  (interactive)
  (shell-command-to-string (s-join " "
                                   `(,my/circus-cmd-start ,(my/circus/prompt-process)))))

(defun my/circus/reloadconfig ()
  (interactive)
  (shell-command-to-string (s-join " "
                                   `(,my/circus-cmd-reloadconfig))))

(defun my/circus/restart-process ()
  (interactive)
  (shell-command-to-string (s-join " "
                                   `(,my/circus-cmd-restart
                                     ,(my/circus/prompt-process)))))

(defun my/circus/stop-process ()
  (interactive)
  (shell-command-to-string (s-join " "
                                   `(,my/circus-cmd-stop
                                     ,(my/circus/prompt-process)))))

(defun my/circus/prompt-process ()
  (completing-read "process: "
                   (-map (lambda (x)
                           (s-replace-regexp ": .*$" "" x))
                         (s-split "\n"
                                  (shell-command-to-string my/circus-cmd-status)))))

(defun my/circus/status (process)
  (shell-command-to-string (s-join " "
                                   `(,my/circus-cmd-status ,process))))

(defun my/circus/status-all ()
  (interactive)
  (shell-command-to-string my/circus-cmd-status))


