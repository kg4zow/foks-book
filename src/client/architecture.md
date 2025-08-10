# Client Architecture

* `foks agent` running in the background
    * holds state, including secret key material for the "active" profile
    * listening on a UNIX socket
        * macOS: `${HOME}/Library/Caches/foks/foks.sock`
        * Linux: `${XDG_RUNTIME_DIR:-${HOME}/.config}/foks/foks.sock`

* `foks` commands run in the foreground
    * communicates with agent using UNIX socket
    * &#x2753; protocol over that UNIX socket
    * HTTP protocol proposed &#x21D2; [#180](https://github.com/foks-proj/go-foks/issues/180)
