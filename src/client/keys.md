# Working with Keys and Devices

On this page, unless otherwise specified, the term "key" refers to any of ...

* **Device keys.** These are encryption keys stored on a computer.

* **Backup keys.** These are collections of words and numbers which *encode* an encryption key. This key acts as a "device key" on the user account.

* **A Yubikey,** or more correctly, an encryption key *stored* in a Yubikey. This key also acts as a "device key" on the user account.

* **Bot tokens.** These are similar to backup keys, but are written using a different format, and may have reduced permissions to the user account.

> &#x2139;&#xFE0F; The descriptions below were written using FOKS version 0.1.2. Things may be different in later versions.


## Profiles

The first time you "log into" FOKS using a given key, it creates a "profile" on disk which contains information *about the key*, including the key name, what kind of key it is (device, backup, bot token, or Yubikey), and the server and username who "owns" the key. **Profiles do not contain any secret keys.**

* **For device keys**, the profile contains the key's name, user information (server and username), and information about how and where the secret key is stored on the computer. The [Key Storage](key-storage.md) page has more detail about this.

* **For backup keys**, the profile contains the key's name and user information. The backup key itself consists of a series of alternating words and numbers. The first word and number act as the key's name.

* **For bot tokens**, the profile contains the key's name and user information. The token consists of two blocks of characters, separated by a `.` character. The first block is five characters, and act as the key's name.

* **For Yubikeys**, the profile contains the key's name and user information, plus the Yubikey's serial number and the PIV "slot" numbers containing two encryption keys. One key is used to perform encryption operations on the Yubikey itslf, the other is used to *generate* the key used to perform post-quantum encryption operations on the computer.

**Only one profile can be active at a time.** Any operations done by FOKS will be done "as" the device (and therefore the user) contained in that profile. Note that secret key material for other profiles may exist in memory, but it will not be used unless that profile is active.

It's also possible to have *no* active profile. In this case, `foks` will not be able to do anything (other than create or log into a user account).


# Commands

Note that several `foks` keys have multiple commands which do the same thing. For example, `foks key list` and `foks key ls` are "aliases" for each other, and end up running the same code within the client.


## List Keys/Profiles

```
foks key list
foks key ls
```

This command will print two lists:

* A list of all keys attached to the user account. If there is no active profile, this list will not be printed.
* A list of profiles on this machine.

Options exist to show just the keys or just the profiles, use `foks key list -h` for more information.

```
$ foks key ls
┌───────────────────────────────────────────────────────────────────────────────────┐
│ All keys for 👤 example123 @ foks.app                                             │
├────────┬────────────┬────────┬────────────┬───────────────────────────────────────┤
│ ACTIVE │ NAME       │ TYPE   │ CREATED    │ ID                                    │
├────────┼────────────┼────────┼────────────┼───────────────────────────────────────┤
│        │ evoke 3992 │ backup │ 2025-09-21 │ .GGIQfSnZxxxxxxxxxxxxxxxxxxxxxxxxxxxx │
│ *      │ MyComputer │ device │ 2025-09-21 │ .4FYMa91Exxxxxxxxxxxxxxxxxxxxxxxxxxxx │
└────────┴────────────┴────────┴────────────┴───────────────────────────────────────┘
┌──────────────────────────────────────────────────────┐
│ All profiles available on this machine               │
├────────┬────────────┬──────────┬────────┬────────────┤
│ ACTIVE │ USERNAME   │ HOSTNAME │ TYPE   │ KEY NAME   │
├────────┼────────────┼──────────┼────────┼────────────┤
│ *      │ example123 │ foks.app │ device │ MyComputer │
└────────┴────────────┴──────────┴────────┴────────────┘
```


## Log Into FOKS

These sections cover how to log into an existing FOKS account. See the [Creating a User](create-user.md) page for information about how to *create* a new FOKS account.


### Log In Using an Existing Profile

```
foks key switch
```

This command will show a menu containing the profiles on the local machine, *other than* the currently active profile.

Select the profile linked to the key you want to sign in with.

* If a passphrase, PIN, or other authentication is needed, you will be asked for it.

* It the new profile's secret keys are not in memory, the key will be used to decrypt them *into* memory (unless the profile you activated is tied to a Yubikey).

* If you *were* logged in using a different profile, any secret keys associated with the previous profile will remain in memory, so that a future `foks key switch` command can switch back to them, but they will not be *used*.


#### Device Keys

It is possible to have multiple device keys for the same computer, if you have multiple FOKS user accounts. In this case, *this* device's keys for the *other* user accounts will be shown on the list, so you can switch to those accounts.

You cannot "select" a device key whose secret keys are not present on the current machine. Device keys only exist *on the device* where they were created.

> It may be possible to copy device keys from one computer to another, but this is not part of how FOKS was designed, and doing so can cause problems. If you need another computer to have access to your account, enroll that computer as its own device on the account, or use a "backup key" or "bot token" on that other computer.


#### Backup Keys

While logged in using a backup key, you can "switch" to a different key and then later "swtich" back to the backup key, without needing to type in the list of words and numbers again.

When you're finished using a backup key, be sure to log out. (See below.)


#### Bot Tokens

While logged in using a bot token, you can "switch" to a different key and then later "swtich" back to the bot token, without needing to type in the token again.

When you're finished using the bot token, be sure to log out. (See below.)


#### Yubikeys

If you "select" a Yubikey profile but the Yubikey isn't physically plugged into the computer, the `foks key switch` command will *say* it succeeded but you won't be able to access anything until the Yubikey is inserted. In this case, commands will fail with an error message like this:

```
$ foks key list
Error: credentials are locked by Yubikey and unlocked credentials are required
```


### Log In Using a Backup Key

To log in using a backup key ...

```
foks key use-backup
```

This command will ...

* Ask you for the FOKS server name
* Ask you to type in the backup key (the list of words and numbers)

The encryption key will be decoded from that list and used to decrypt the other keys associated with the user account and any teams it may be a member of.

This will create a profile on the computer, but the key itself (derived from the words and numbers you typed) is never written to disk. When you "log out" of the profile, the secret key material is removed from memory.

> &#x2757;&#xFE0F; **Switching vs Logging Out**
>
> If you're logged in using a backup key and *switch* to a different profile, the profile based on the backup key will remain in memory, and you can switch back to it, *without* having to type in the list of words and numbers again.
>
> If this is not what you want, be sure to log out (see below) when you're finished using a backup key.


### Log In Using a Bot Token

To long in using a bot token ...

```
foks key use-bot-token [--host SERVERNAME] [--token TOKEN]
```

This command will ...

* Ask you for the FOKS server name, if the `--host` option was not used.
* Ask you to type in the token, if it was not supplied using the `--token` option or the `FOKS_BOT_TOKEN` environment variable.

The encryption key will be decoded from the token and used to decrypt the other keys associated with the user account and any teams it may be a member of.

This will create a *temporary* profile on the computer, which is never written to disk. When you "log out" of the profile, the secret key material and the profile are removed from memory.

> &#x2757;&#xFE0F; **Switching vs Logging Out**
>
> If you're logged in using a bot token and *switch* to a different profile, the profile based on the bot token will remain in memory, and you can switch back to it, *without* having to supply the token again.
>
> If this is not what you want, be sure to log out (see below) when you're finished using a backup key.



### Log In Using a Yubikey

To log in using a Yubikey ...

```
foks key use-yubikey
```

This command will ...

* Scan the computer to list all attached Yubikeys and ask you to select one
* Ask you for the FOKS server name
* Ask you for a "slot number" on the Yubikey
* Ask you to confirm you want to use this Yubikey to log into the user account

The encryption key stored on the Yubikey will be used to decrypt the PUK (per-user key) and PTK's (per-team keys) for any teams the user is a member of. This involves two key exchanges:

* DH over Curve25519, performed by the Yubikey itself.
* ML-KEM (aka "post quantum"), performed on the computer, using a seed calculated by the Yubikey.

The encrytion keys stored on the Yubikey are never sent to the computer.


## Log Out

There are two different commands to "log out" of FOKS.

```
foks key lock
```

This command will remove *the current profile's* secret key material from memory, and un-select the profile. If any other profiles are available, one will be "selected" automatically.

> &#x2753; I tried this command while logged in using a Yubikey, on a computer which also has its own device key, stored in the macOS Keychain. FOKS did lock the Yubikey's key and made the machine's normal device key active, but `foks key ls` showed the device *key* active, with the Yubikey *profile* active.
>
> I'm not sure if this is the expected behaviour. Until I know more, I plan to use `foks clear` whenever I need to "log out".

```
foks clear
```

This command will remove the secret key material *for all profiles* from memory, and totally log out of FOKS. (If the machine has a device key, you can use `foks key switch` to log back in.)


## Add A Computer

Adding a computer to your account requires approval from an existing key. This can only be done using a device which is logged in using a key on the account.


### Add A Computer Using An Existing Device

This requires a computer logged into the FOKS account using an existing key, *in addition to* the computer you're adding. You will need to be able to read from one screen and type into the other, so it may be helpful to have the two computers physically close to each other. You can also SSH into one *from* the other, so you can copy and paste a temporary code from one window to the other.

* On the existing device

    ```
    foks key assist
    ```

    This command will print a series of words and numbers on the screen, then ask for a different code.

     **Don't do anything**, just leave it on the screen for now.

* On the new device

    ```
    foks key new
    ```

    This command will walk you through the process.

    * "Press Enter to get started"
    * Select "A new user on this device"
    * Select or enter the FOKS server for the user account.
    * Enter your username.
    * Enter the device name you want to use for the new device.

    This will *also* print a series of words and numbers on the screen, and then ask for a different code.

* On *either* device

    Type in the series of words and numbers from the *other* device's screen.

After a few seconds, it should report that the device was added, and *both* computers will return to a command prompt.


### Add A Computer Using A Backup Key

This can be done using only the computer you're adding to the account.

* Log the computer into your FOKS account using the backup key. (See above.)

* Add the computer as a permanent device on the account.

    ```
    foks key new
    ```

    This command will recognize that FOKS is logged in using a backup key and walk you through the process of adding a permanent device key for this computer.

    &#x2753; exact steps


### Add A Computer Using A Yubikey

This can be done using only the computer you're adding to the account.

* Log the computer into your FOKS account using the Yubikey. (See above.)

* Add the computer as a permanent device on the account.

    ```
    foks key new
    ```

    This command will recognize that FOKS is logged in using a Yubikey and walk you through the process of adding a permanent device key for this computer.

    &#x2753; exact steps


## Add a Backup Key

A backup key can be used to access an account from a computer that isn't a permanent device on your account. Using a backup key doesn't *make* the computer a device on your account, although the backup key has "owner" access, which means it can be used to *add* devices to your account.

Before running this command ...

* Make sure the computer is logged into the FOKS account you're adding the backup key to.

```
foks key new
```

This command will walk you through the following steps:

* `Press <Enter> to get started`.
* Select the `[ACTIVE]` profile for the user you want to create a backup key for.
* Select `A new backup key`.
* The command will print a series of words and numbers.

These words and numbers encode an encryption key which has the same access as any other device on your account.

**WRITE THE WORDS AND NUMBERS DOWN ON PAPER AND STORE IT SOMEWHERE SECURE.** This is the only time FOKS will ever print it. If you don't save it, there is no way to recover it (although as long as you have access to the FOKS account, you can revoke the backup key and/or create another one).

Note that the first word and number will be used as the name of the backup key.


## Add a Bot Token

A bot token can be used to access a FOKS account from a computer that isn't a permanent device on the account. They are useful for "bots" or other automated processes.

> &#x2753; **Unclear what `--role` option does**
>
> My first guess was that each token carries a visibility level with it, so that a client using the token will have limited access to the account (and its teams). If this were true, I had written the following:
>
> Unlike a backup key (which always has "owner" access), a bot token can be assigned any "visibility level" you like. When a client *uses* a bot token, they will be limited to the token's visibility level. For example, if you create a token with visiblity level "member/0", clients using that token will not be able to access items or perform operations requiring "admin" or "owner" access.
>
> However, when I tried to create a token with anything *other than* owner access, it didn't work.

```
foks bot new [--role XXX]
```

The `XXX` value can be one of:

- `owner` or `o`: owner access
- `admin` or `a`: admin access
- `member/10` or `m/10`: member access with visibility level 10 (which is higher than `m/0` but lower than `m/20`)



### Visibility Levels

Visibility levels can be specified when adding key-value items, to control who can read or write that item. For example, if you add an item with read role `m/0` and write role `m/10`, then a bot token with visibility level `m/0` would be able to *read* that item but not *write* the item.







## Add a Yubikey

Like a backup key, a Yubikey can be used to access your account from a computer that isn't a permanent device on your account. Using a Yubikey doesn't *make* the computer a device on your account, although it can be *used* to add devices to your account.

Unlike a backup key, the actual secret keys are generated by the Yubikey itself, and stored in a "secure element" within the Yubikey itself. This means that ...

* There is no way to download the *actual* secret keys that it generates.
* There is no way to back up the scret keys to a second Yubikey.
* If you physically lose the Yubikey, those secret keys are gone. All you can do is revoke them and set up a new Yubikey.

Before running this command ...

* Make sure the Yubikey's PIV app is enabled, and the PIN/PUK codes and admin key have been changed from the default values. The [Yubikeys](yubikeys.md) page explains this.
* Make sure the computer is logged into the FOKS account you're adding the backup key to.
* Make sure the Yubikey is plugged into the computer.

```
foks key new
```

This command will make the Yubikey generate two encryption keys and store them in "slots" within the PIV app.

* `Press <Enter> to get started`
* Select the `[ACTIVE]` profile for the user you want the Yubikey to be linked to
* `A new key on my Yubikey`
* &#x2753; do this again, and this time write down the exact steps

The command will make the Yubikey generate two encryption keys, and add one of them as a "device" on your account.

> &#x2753; not sure what the other encryption key is used for, need to re-read that part of the whitepaper


## Remove a Key from your Account

```
foks key revoke
```

This command will revoke an existing key from your account. This adds an entry in the account's "blockchain" which says that the key should no longer be used. It also starts a process which re-encrypts any data which were previously accessible using the now-revoked key.

> &#x2753; haven't done this yet - try it and take notes


