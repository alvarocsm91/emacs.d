;;; Main menu
;;;; Create body
(defhydra my-general-menu (:color blue)
  "
^Basic Conf^         ^Packages^         ^Features^          ^Prog Mode^
^-------------------------------------------------------------------
_b_: My basic        _p_: Installed     _f_: Global         _p_: Programming
   configuration      packages         features          modes
"
  ;; Show basic config menu
  ("b" help)
  ;; Show basic config menu
  ("p" help)
  ;; Show basic config menu
  ("f" help)
  ;; Show basic config menu
  ("p" help)
  ;; Extra info
  ("q" quit-window "quit" :color blue)
  )

;;;; Set global key
;;(define-key Buffer-general-mode-map "." 'my-general-menu/body)
(global-set-key (kbd "C-h SPC") 'my-general-menu/body)
