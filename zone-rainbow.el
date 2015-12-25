;;; zone-rainbow.el --- Zone out with rainbow      -*- lexical-binding: t; -*-

;; Copyright (C) 2015  KAWABATA, Taichi

;; Author: KAWABATA, Taichi <kawabata.taichi@gmail.com>
;; Keywords: games

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Zone out with rainbow.  This code is inspired by
;; https://gist.github.com/mrkuc/7121179.
;;
;; It can directly invoked by `M-x zone-rainbow'.
;;
;; It can be set as a single zone program by the following.
;;
;; (setq zone-programs '(zone-pgm-rainbow))
;;
;; Or, it can be added to zone programs list as follows.
;;
;; (callf2 mapcar 'identity zone-programs) ; in case `zone-programs' is vector.
;; (add-to-list 'zone-programs 'zone-pgm-rainbow)

;;; Code:

(require 'zone)
(require 'color)

(defgroup zone-rainbow nil
  "Zone out with rainbow."
  :group 'games)

(defcustom zone-rainbow-hue-factor 50 "Hue factor." :group 'zone-rainbow)
(defcustom zone-rainbow-sat 1.0 "Saturation." :group 'zone-rainbow)
(defcustom zone-rainbow-light 0.5 "Light." :group 'zone-rainbow)
(defcustom zone-rainbow-background "#000000" "Background color." :group 'zone-rainbow)

;;;###autoload
(defun zone-pgm-rainbow ()
  "Zone out with rainbow."
  (cl-loop
   while (not (input-pending-p))
   with k = 0
   do
   (cl-loop
    for i from (window-start) to (1- (window-end))
    do (add-text-properties
        i (1+ i)
        `(face ((foreground-color
                 . ,(apply 'color-rgb-to-hex
                           (color-hsl-to-rgb
                            (/ (* (% (+ i k) zone-rainbow-hue-factor) 1.0)
                               zone-rainbow-hue-factor)
                            zone-rainbow-sat zone-rainbow-light)))
                (background-color
                 . ,zone-rainbow-background)
                ))))
   (sit-for 0.1)
   (incf k)))

;;;###autoload
(defun zone-rainbow ()
  "Zone out with rainbow."
  (interactive)
  (let ((zone-programs [zone-pgm-rainbow]))
    (zone)))

(provide 'zone-rainbow)

;;; zone-rainbow.el ends here
