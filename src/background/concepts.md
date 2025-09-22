# Concepts

> &#x2139;&#xFE0F; This page is just a rough outline of what I want to cover.

This page *will* contain information that will hopefully make it easier to understand FOKS.

For now this is just a list of what I think would be useful to cover.

## Encryption Keys

* Every "key" (device key, PUK, PTK, etc.) actually consists of three key pairs:
    * EdDSA
    * Curve25519
    * ML-KEM key - "post quantum"

* Yubikey firmware cannot do the ML-KEM algorithms (yet?)
    * [FIPS 203](https://csrc.nist.gov/pubs/fips/203/ipd)
    * Yubikey firmware is not upgradable - when/if future Yubikeys *do* support it, we'll all have to buy newer Yubikeys &#x1F601;

## Servers

* `foks.app` - default server, run by Max
    * offers [paid accounts](https://w.foks.app/)
    * free accounts only allow a few MiB of data to be stored - enough for basic testing, then `foks admin web` to log in and convert to paid account
* `vh.foks.app` - also Max, used for "virtual hosting"
    * for people want their own FOKS server but don't want to build or maintain it
* other servers - anybody is able to stand up their own FOKS server
    * source code is in the same repo with `foks` client
    * can be free or paid, the `foks.app` server is using it


## Users

* each user exists on a specific server
* encryption: per-user key
* per-user or per-virtual-server storage limit (depending on server policy)


## Devices

* each user account can have multiple devices
* computers can access multiple FOKS accounts, only one is active at a time
* key types
    * device key
    * backup key
    * bot token
    * Yubikey
* encryption: per-device key is used to decrypt per-user and per-team keys, which are then used to decrypt


## Profiles

* "profiles" contain per-user settings associated with a device/backup/yubikey
* &#x2753; TBD


## Teams

* groups of users
* team exists on one server
* every team must have at least one owner - user who creates a team is the initial owner
* team owner/admin must be on same server as the team, but team members may be on different servers
* adding members
    * closed server: invite/accept/(inbox,admit) process
    * open server: &#x2753;
* users can create teams (count can be limited by server policy)
* team storage consumes a user's storage limit
    * teams have a limit of 512 KiB until "claimed" by somebody, limit is configurable using `floating_team` in `config.jsonnet` file
* user/team names are in the same "namespace"
    * if user `xyz` exists on a server, team `xyz` cannot be created on the same server
* encryption: per-team key


## Roles and Visibility Levels

Roles control who has access to which items *within a team*.

Items stored in KV have two levels associated with them - the level required to *read* the item, and the level required to *write* (or overwrite) the item. The values are encrypted using encryption keys which are specific to that level. (These keys are created the first time they're needed.)

If an operation is attempted using a client whose role isn't "high" enough, the operation will fail because the client won't have access to the necessary encryption key.

* Owners
    * can add/remove team members and assign visibility levels
    * can delete the team
    * can access encryption keys for all levels

* Admins
    * can add/remove team members and assign visibility levels (other than `owner`)
    * cannot delete the team
    * can access encryption keys for "admin" and all "member/*" items
    * cannot access encryption keys for "owner"

* Members
    * cannot add/remove members or assign visibility levels
    * cannot delete the team
    * members have "visibility levels"
        * integer between `-32768` and `32767`, default `0`
        * each priority level which is being used, has its own encryption key
    * can access encryption keys for visibility levels equal to or lower than their own role
    * cannot access encryption keys for visibility levels higher than their own role
        * `m/0` *can* access `m/0`, `m/-1`, `m/-2`, etc.
        * `m/0` *cannot* access `m/1`, `m/2`, etc.
        * `m/*` cannot access `admin` or `owner` keys

* None
    * used for former members who were removed from the team
    * cannot access or do anything
    * this is just like if they had never *been* a member of the team

Other info

* Users who publish items can choose which levels are required to read or write that value. Either level can be any level *at or below* their own access level.

* The first time an item is published using a level which has not previously been used (for example, as `member/100`), an encryption key is created *for that visibility level*. This key is used to encrypt the value being stored, as well as any future values stored using the same visibility level.

