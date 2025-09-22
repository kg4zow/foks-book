# Client Architecture

> &#x2139;&#xFE0F; This page is just a rough outline of what I want to cover.


* `foks agent` - runs in the background
    * holds state, including secret key material for the "active" profile
    * listening on a UNIX socket
        * macOS: `${HOME}/Library/Caches/foks/foks.sock`
        * Linux: `${XDG_RUNTIME_DIR:-${HOME}/.config}/foks/foks.sock`

* `foks` commands run in the foreground
    * communicates with agent using UNIX socket
        * &#x2753; document protocol over that UNIX socket
    * HTTP protocol - `foks kv rest` commands
        * [API documentation](kv-rest.md)
