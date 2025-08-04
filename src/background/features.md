# Features

This page *will* explain the high-level features of FOKS.

For now this is just a list of what I think would be useful to cover.


## Key-Value Storage

* user KV vs team KV
* key namespace looks like unix path
    * first character must be `/`
    * other "node" names are separated by `/`
    * each "node" either "is a file" (containing a value) or "is a directory" (containing files or directories)
    * `foks kv ls` output shows names within each "directory", but not whether each name "is a" file or directory
    * newly created accounts don't have a `/` key until at least one other key is created (or a git repo created, which creates `/app` and `/app/git` so it can create `/app/git/REPONAME`)
* values can be anything, any size (up to server policy)
* values are stored ... ?
    * as files on disk?
    * as rows in a database table?
    * either/or depending on size?
    * can values be stored in other storage?
        * S3 (or compatible) bucket blobs
        * azure blob storage
* deleted values still count against `foks kv get-usage` totals


## Git repos

* stored in KV, using keys under `/app/git/REPONAME`
* `git-remote-foks` - allow `git` to work with `foks://` URLs
* no `foks git delete` command, but `foks kv rm -R /app/git/REPONAME` works

