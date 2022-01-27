Nazar's Guix Channel
=====================

A collection of custom Guix packages that aren't (yet) suitable
for submission upstream.

Usage
-----

This channel can be installed as a
[Guix channel](https://www.gnu.org/software/guix/manual/en/html_node/Channels.html).
To do so, add it to '~/.config/guix/channels.scm':

```
(cons* (channel
  (name 'guix-phps)
  (url "https://github.com/Nazar65/my-guix-packages-channel")
  (introduction
    (make-channel-introduction
      "5c31dba5f3a5bb1b1f49305576bfec68efc39d71"
      (openpgp-fingerprint
       "736A C00E 1254 378B A982  7AF6 9DBE 8265 81B6 4490"))))
       %default-channels)
```

Then run 'guix pull'.

The packages in this repo will take precedence over those in the
official distribution.
