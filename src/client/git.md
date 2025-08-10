# Working with Git Repositories

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
* remove a repo
    * `foks kv rm -r /app/git/REPONAME`
* other operations (pull, push, etc.) all use the same `git` commands you would use for other git servers

Questions

* primary branch name
    * does git "server" assume a certain branch name (`master`, `main`, etc.) or does it use the name of the first branch pushed into?
    * command to *set* primary branch name, or brain surgery?
* LFS support
