;;; gcj.el --- helpers to use elisp on GCJ -*- lexical-binding: t -*-

;; Copyright (C) 2016 Alexey Kutepov <reximkut@gmail.com>

;; Author: Alexey Kutepov <reximkut@gmail.com>
;; URL: http://github.com/rexim/gcj.el

;; Permission is hereby granted, free of charge, to any person
;; obtaining a copy of this software and associated documentation
;; files (the "Software"), to deal in the Software without
;; restriction, including without limitation the rights to use, copy,
;; modify, merge, publish, distribute, sublicense, and/or sell copies
;; of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:

;; The above copyright notice and this permission notice shall be
;; included in all copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
;; BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
;; ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
;; CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.

;;; Commentary:

;; helpers to use elisp on GCJ

;;; Code:

(defvar gcj--input-buffer nil)
(defvar gcj--output-buffer nil)

(defmacro with-gcj-input (filename &rest body)
  (declare (indent 1))
  `(let ((gcj--input-buffer (find-file-noselect ,filename))
         (gcj--output-buffer (find-file-noselect (concat ,filename
                                                         ".out"))))
     (with-current-buffer gcj--input-buffer
       (goto-char (point-min)))
     (with-current-buffer gcj--output-buffer
       (erase-buffer))
     ,@body
     (with-current-buffer gcj--output-buffer
       (save-buffer))))

(defun gcj-read-word ()
  (with-current-buffer gcj--input-buffer
    (let ((end (progn (forward-word)
                      (point)))
          (start (progn (backward-word)
                        (point))))
      (forward-word)
      (buffer-substring start end))))

(defun gcj-read-number ()
  (string-to-number (gcj-read-next-word)))

(defun gcj-write-strings (&rest ss)
  (with-current-buffer gcj--output-buffer
    (apply #'insert ss)))

(provide 'gcj)

;;; gcj.el ends here
