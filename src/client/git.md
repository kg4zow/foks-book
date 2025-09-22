# Working with Git Repositories

> &#x2139;&#xFE0F; This page is just a rough outline of what I want to cover.


Background

* repos are stored in KV, under `/app/git`
* owned by user vs owned by team


Procedures

* create repo
    * `foks git create`
    * If content doesn't exist yet
        * `git init`
    * Either way
        * `git remote add`
        * `git commit` if needed (repo must contain at least one commit before push)
        * `git push --all`
        * `git push --tags`
* clone a repo
    * `git clone foks://SERVER/OWNER/REPONAME`
    * `OWNER` will be `xxx` for a username, or `t:xxx` for a team name
* remove a repo
    * there is no `foks git rm` command (yet?)
    * `foks kv rm -r /app/git/REPONAME` will do the job
* other operations (pull, push, etc.) all use the same `git` commands you would use for other git servers

Questions

* primary branch name
    * git "server" assumes primary branch name `main`, created [issue #187](https://github.com/foks-proj/go-foks/issues/187)
    * command to *set* primary branch name, or brain surgery?
* LFS support &#x2192; hasn't been built yet
