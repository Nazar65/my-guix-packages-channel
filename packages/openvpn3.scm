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

(define-module (packages openvpn3)
  #:use-module (guix packages)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages pkg-config)
  #:use-module (guix git-download)
  #:use-module (gnu packages python)
  #:use-module (guix licenses)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages selinux)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages serialization)
  #:use-module (gnu packages version-control)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages pkg-config)
  #:use-module ((guix licenses) #:prefix license:))

(define-public openvpn3
  (package
    (name "openvpn3")
    (version "v16_beta")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/OpenVPN/openvpn3-linux")
                    (commit "079e9da7f66f5cca59cf80ba8c548f0dedd433db")
		    (recursive? #t)))
	      (sha256
               (base32
		"0b68a55id0n1w4sgn2bprzi3cfhx9pix4s1lvgcnlvm0ph98sydx"))
	      (patches
	       (search-patches "patches/openvpn3_gitsubmodules.patch"
			       "patches/openvpn3_updatem4.patch"
			       "patches/openvpn3_core.patch"
			       "patches/openvpn3_remove_selinx.patch"))))
    (build-system gnu-build-system)
    (arguments
     `(#:configure-flags
       '("--disable-selinux-build" "--enable-debug-exceptions")
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'patch-shebangs
           (lambda* (#:key inputs #:allow-other-keys)
             (patch-shebang "./bootstrap.sh")
	     (patch-shebang "./update-version-m4.sh"))))))
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("git" ,git)
       ("libselinux" ,libselinux)
       ("lz4" ,lz4)
       ("xmllint" ,libxml2)
       ("glib" ,glib)
       ("dbus" ,dbus)
       ("openssl" ,openssl)
       ("tinyxml2" ,tinyxml2)
       ("libcap-ng" ,libcap-ng)
       ("jsoncpp" ,jsoncpp)
       ("automake" ,automake)
       ("autoreconf" ,autoconf)
       ("bash" ,bash-minimal)))
    (home-page "https://github.com/OpenVPN/openvpn3-linux")
    (synopsis "OpenVPN 3 Linux client")
    (description "This is the next generation OpenVPN client for Linux. This project is very different from the more classic OpenVPN 2.x versions. First, this is currently only a pure client-only implementation.")
    (license (non-copyleft "file://COPYING"
                           "See COPYING file in the distribution."))))
