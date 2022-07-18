;;; Copyright © 2022 Nazar Klovanych <nazarn96@gmail.com>
;;;
;;; This file is an addendum to GNU Guix.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (packages nyxt)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix git-download)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages webkit)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages lisp-xyz)
  #:use-module (gnu packages web-browsers))

(define-public nyxt-3
  (let ((commit "f024c4a3048f665baf973019ca2e49b615e5acf5")
        (revision "1"))
    (package
      (inherit nyxt)
      (name "nyxt-3")
      (version (git-version (package-version nyxt) revision commit))
      (source
        (origin
          (method git-fetch)
          (uri (git-reference
                 (url "https://github.com/atlas-engineer/nyxt")
                 (commit commit)))
          (file-name (git-file-name name version))
          (sha256
           (base32
            "0kps05d7gvqns8s6v2446v9qwb9nwj0gjqq5pvrhxxr3cfh60ij1"))))
      (inputs
       `(("cl-gopher" ,cl-gopher)
	 ("cl-tld" ,cl-tld)
	 ("cl-dissect" ,cl-dissect)
	 ("cl-nfiles" ,cl-nfiles)
	 ("cl-gopher" ,cl-gopher)
	 ("cl-calispel" ,cl-calispel)
	 ("cl-css" ,cl-css)
	 ("cl-html-diff" ,cl-html-diff)
	 ("cl-json" ,cl-json)
	 ("cl-ppcre-unicode" ,sbcl-cl-ppcre-unicode)
	 ("sbcl-cl-prevalence" ,sbcl-cl-prevalence)
	 ("cl-qrencode" ,cl-qrencode)
	 ("cl-tld" ,cl-tld)
	 ("cl-closer-mop" ,cl-closer-mop)
	 ("cl-containers" ,cl-containers)
	 ("cl-dissect" ,cl-dissect)
	 ("cl-moptilities" ,cl-moptilities)
	 ("cl-dexador" ,cl-dexador)
	 ("cl-enchant" ,cl-enchant)
	 ("cl-iolib" ,cl-iolib)
	 ("cl-lparallel" ,cl-lparallel)
	 ("cl-log4cl" ,cl-log4cl)
	 ("cl-nfiles" ,cl-nfiles)
	 ("cl-parenscript" ,cl-parenscript)
	 ("cl-py-configparser" ,cl-py-configparser)
	 ("cl-nhooks" ,cl-nhooks)
	 ("sbcl-nkeymaps" ,sbcl-nkeymaps)
	 ("cl-phos" ,cl-phos)
	 ("cl-plump" ,cl-plump)
	 ("cl-slynk" ,cl-slynk)
	 ("alexandria" ,sbcl-alexandria)
	 ("bordeaux-threads" ,sbcl-bordeaux-threads)
	 ("cl-base64" ,sbcl-cl-base64)
	 ("cl-calispel" ,sbcl-calispel)
	 ("cl-containers" ,sbcl-cl-containers)
	 ("cl-css" ,sbcl-cl-css)
	 ("cl-custom-hash-table" ,sbcl-custom-hash-table)
	 ("cl-html-diff" ,sbcl-cl-html-diff)
	 ("cl-json" ,sbcl-cl-json)
	 ("cl-ppcre" ,sbcl-cl-ppcre)
	 ("cl-prevalence" ,sbcl-cl-prevalence)
	 ("cl-qrencode" ,sbcl-cl-qrencode)
	 ("closer-mop" ,sbcl-closer-mop)
	 ("cluffer" ,sbcl-cluffer)
	 ("dexador" ,sbcl-dexador)
	 ("enchant" ,sbcl-enchant)
	 ("flexi-streams" ,cl-flexi-streams)
	 ("fset" ,sbcl-fset)
	 ("hu.dwim.defclass-star" ,sbcl-hu.dwim.defclass-star)
	 ("iolib" ,sbcl-iolib)
	 ("local-time" ,sbcl-local-time)
	 ("log4cl" ,sbcl-log4cl)
	 ("lparallel" ,sbcl-lparallel)
	 ("mk-string-metrics" ,sbcl-mk-string-metrics)
	 ("moptilities" ,sbcl-moptilities)
	 ("named-readtables" ,sbcl-named-readtables)
	 ("parenscript" ,sbcl-parenscript)
	 ("plump" ,sbcl-plump)
	 ("clss" ,sbcl-clss)
	 ("quri" ,sbcl-quri)
	 ("serapeum" ,sbcl-serapeum)
	 ("spinneret" ,sbcl-spinneret)
	 ("str" ,sbcl-cl-str)
	 ("swank" ,sbcl-slime-swank)
	 ("trivia" ,sbcl-trivia)
	 ("trivial-clipboard" ,sbcl-trivial-clipboard)
	 ("trivial-features" ,sbcl-trivial-features)
	 ("trivial-package-local-nicknames" ,sbcl-trivial-package-local-nicknames)
	 ("trivial-types" ,sbcl-trivial-types)
	 ("unix-opts" ,sbcl-unix-opts)
	 ;; WebKitGTK deps
	 ("cl-cffi-gtk" ,sbcl-cl-cffi-gtk)
	 ("cl-webkit" ,sbcl-cl-webkit)
	 ("glib-networking" ,glib-networking)
	 ("gsettings-desktop-schemas" ,gsettings-desktop-schemas)
	 ;; GObjectIntrospection
	 ("cl-gobject-introspection" ,sbcl-cl-gobject-introspection)
	 ("gtk" ,gtk+)                    ; For the main loop.
	 ("webkitgtk" ,webkitgtk)         ; Required when we use its typelib.
	 ("gobject-introspection" ,gobject-introspection)))
    )))
