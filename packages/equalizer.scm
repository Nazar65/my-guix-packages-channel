;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2013, 2016 Ludovic Courtès <ludo@gnu.org>
;;; Copyright © 2015, 2016 Mark H Weaver <mhw@netris.org>
;;; Copyright © 2015 Eric Bavier <bavier@member.fsf.org>
;;; Copyright © 2016, 2017 Leo Famulari <leo@famulari.name>
;;; Copyright © 2017, 2021 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2017 Marius Bakke <mbakke@fastmail.com>
;;; Copyright © 2018, 2019, 2020 Tobias Geerinckx-Rice <me@tobias.gr>
;;;
;;; This file is part of GNU Guix.
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

(define-module (packages equalizer)
  #:use-module (guix packages)
  #:use-module (guix build-system glib-or-gtk)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages)
  #:use-module (gnu packages build-tools)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages ninja)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages pkg-config)
  #:use-module (guix git-download)
  #:use-module (guix licenses)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages base)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages glib)
  #:use-module (guix build-system meson)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages pkg-config)
  #:use-module (guix build-system glib-or-gtk)
  #:use-module (guix build-system python)
  #:use-module (gnu packages python-build)
  #:use-module ((guix licenses) #:prefix license:))

(define-public pulseaudio-equalizer
  (package
    (name "pulseaudio-equalizer")
    (version "v3.0.2")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/pulseaudio-equalizer-ladspa/equalizer")
                    (commit "0a7406d71a3d93cd5ac38aeed00a26c5f9cc422a")))
	      (sha256
               (base32
		"1nav7kq8h42i6k0r1jhgx4b5ls1yiir8kv9iirjcxkn2vkhl2fvr"))))

    (build-system meson-build-system)
    (arguments
     `(#:glib-or-gtk? #t
       #:phases
       (modify-phases %standard-phases
         (add-after 'install 'wrap
                    (lambda* (#:key outputs inputs #:allow-other-keys)
                      (wrap-program (string-append (assoc-ref outputs "out")
                                                   "/bin/pulseaudio-equalizer-gtk")
                 `("GUIX_PYTHONPATH" = (,(getenv "GUIX_PYTHONPATH")))
                 `("GI_TYPELIB_PATH" = (,(getenv "GI_TYPELIB_PATH")))))))
       #:parallel-build? #f
	#:tests? #f))
     (native-inputs
     `(("glib:bin" ,glib "bin")
       ("gobject-introspection" ,gobject-introspection)
       ("gtk+:bin" ,gtk+ "bin")))
    (inputs
     `(("meson" ,meson)
       ("bash" ,bash-minimal)
       ("python" ,python-3.9)
       ("pycairo" ,python-pycairo)
       ("pygobject" ,python-pygobject)
       ("gtk3" ,gtk+)
       ("pkg-config" ,pkg-config)
       ("glib" ,glib)
       ("ninja" ,ninja)))
    (propagated-inputs
     (list  python-pycairo python-pygobject))
    (home-page "")
    (synopsis "")
    (description "")
    (license (non-copyleft "file://COPYING"
                           "See COPYING file in the distribution."))))
