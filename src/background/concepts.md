# Concepts

This page *will* contain information that will hopefully make it easier to understand FOKS.

For now this is just a list of what I think would be useful to cover.

## Servers

* `foks.app` - default server, run by Max
    * offers [paid accounts](https://w.foks.app/)
    * free accounts only allow a few MiB of data to be stored - enough for basic testing, then `foks admin web` to log in and convert to paid account
* `vh.foks.app`
* others - self-hosted

## Users

* each user exists on a specific server
* encryption: per-user key
* per-user storage limit (depending on server policy)

## Devices

* each user can have multiple devices
* physical device, backup key, Yubikey
* "profiles" are per-user settings, on a physical device
* encryption: per-device key is used to unlock per-user key &#x2753;

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
    * `foks.app`: limit for teams not linked to a user?
* user/team names are in the same "namespace"
    * if user `xyz` exists on a server, team `xyz` cannot be created on the same server
* encryption: per-team key

## Roles

* control who has what access within a team
* owner, admin, member, none
* member priority values
    * integer between `-32768` and `32767`, default `0`
    * each priority level being used has its own key
        * how/when are priority-level keys created?
    * members can access content encrypted using any member key whose priority is equal or lower than their own role, but not member keys whose priority is higher than their own role
    * users who publish items can choose which "level" will have access to the item (any level *at or below* their own access)
    * admins and owners can read all "member/*" items

