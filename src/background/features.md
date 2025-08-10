# High-Level Features

This page *will* explain the high-level features of FOKS.

For now this is just a list of what I think would be useful to cover.


## Key-Value Storage

* user KV vs team KV
* key namespace looks like unix path
    * first character must be `/`, 0+ "directories" separated by `/`, then a non-empty "file" name
    * `foks kv ls` output shows names within each "directory", but not whether each name is a file or directory
    * newly created accounts don't have a `/` key until at least one other key is created (or a git repo is created, which creates `/`, `/app` and `/app/git` if they don't already exist, so it can create `/app/git/REPONAME`)
* individual values can be anything, any size
    * user account storage limits based on server policy
* values are stored ... ?
    * as files on disk?
    * as rows in a database table?
    * either/or depending on size?
    * can values be stored in other storage?
        * S3 (or compatible) bucket blobs
        * azure blob storage
* deleted values still count against `foks kv get-usage` totals
    * not sure how this will be handled, but there needs to be a way to reclaim the storage, both to prevent the server from running out of space, and to not charge paying users for deleted data


## Git Repositories

* stored in KV, using keys under `/app/git/REPONAME`
* `git-remote-foks` - allows `git` to work with `foks://` URLs
* there is no `foks git delete` command, but `foks kv rm -R /app/git/REPONAME` deletes the repo

