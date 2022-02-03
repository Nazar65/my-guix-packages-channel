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

(define-module (packages elasticsearch)
  #:use-module (guix packages)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages)
  #:use-module (guix download)
  #:use-module (guix licenses)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages java)
  #:use-module (gnu packages base)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages bootstrap) ;glibc-dynamic-linker
  #:use-module (gnu packages pkg-config)
  #:use-module ((guix licenses) #:prefix license:))

(define-public elasticsearch
  (package
    (name "elasticsearch")
    (version "7.16.3")
    (source (origin
              (method url-fetch)
	      (uri
	       (string-append
		"https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-"
		version "-linux-x86_64.tar.gz"))
	      (sha256
               (base32
		"0aiqzmgynnv6yffjgi2vpirj68kx553jhmjb4lbii5m4bjhgx8s3"))
              (patches
	       (search-patches "patches/elasticsearch_log.patch"))))
    (build-system gnu-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
	 (delete 'configure)
         (delete 'build)
         (replace 'install
           (lambda* (#:key outputs inputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (out-bin (string-append out "/bin/"))
                    (out-config (string-append out "/config/"))
                    (out-lib (string-append out "/lib/"))
                    (out-modules (string-append out "/modules/"))
                    (out-plugins (string-append out "/plugins/"))
		    (ld-so (search-input-file inputs ,(glibc-dynamic-linker)))
		    (binaries
                     (list
                      (string-append out-modules "/x-pack-ml/platform/linux-x86_64/bin/controller"))))
               (copy-recursively "bin" out-bin)
               (copy-recursively "lib" out-lib)
               (copy-recursively "config" out-config)
               (copy-recursively "modules" out-modules)
               (copy-recursively "plugins" out-plugins)
	       ;; The binaries have "/lib64/ld-linux-x86-64.so.2" hardcoded.
	       (invoke "patchelf"
		       "--set-interpreter"
		       ld-so
		       (string-append out-modules "/x-pack-ml/platform/linux-x86_64/bin/controller")))
             #t))
         (add-after 'install 'wrap
           (lambda* (#:key outputs inputs #:allow-other-keys)
             (wrap-program (string-append (assoc-ref outputs "out")
                                          "/bin/elasticsearch")
               `("ES_JAVA_HOME" = (,(assoc-ref inputs "jdk")))
	       `("ES_PATH_CONF" = (,"/tmp/elasticsearch/config/"))
               `("ES_HOME" = (,"/tmp/elasticsearch/"))))))
       #:parallel-build? #f
       #:tests? #f))
    (native-inputs
     `(("jdk" ,openjdk11 "jdk")
       ("zlib" ,zlib)
       ("patchelf" ,patchelf)))
    (home-page "https://github.com/elastic/elasticsearch")
    (synopsis "Free and Open, Distributed, RESTful Search Engine")
    (description
     "Elasticsearch is the distributed, RESTful search and analytics engine at the heart of the Elastic Stack.
You can use Elasticsearch to store, search, and manage data for:, Logs, Metrics, A search backend, Application monitoring, Endpoint security ... and more!")
    (license (non-copyleft "file://COPYING"
                           "See COPYING file in the distribution."))))
