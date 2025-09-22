# Creating a User

> &#x2139;&#xFE0F; This page is just a rough outline of what I want to cover.

## Select a server

### `foks.app` and `vh.foks.app`

The `foks.app` and `vh.foks.app` servers will be offered by default.

**These servers are a paid service**. The servers themselves are owned by Max, the primary developer of FOKS.

* `foks.app` offers individual user accounts.
* `w.foks.app` offers virtual hosting (i.e. using your own hostname, but hosted on the `foks.app` server)
* [This page](https://w.foks.app) explains more about how it works, and includes pricing.

Non-paid accounts are only usable for *simple* experimentation. Each non-paid user has a very small usage limit (3 MiB).

### Other servers - list?

Building/hosting a list of other FOKS servers is on the roadmap.

> &#x2753; The whitepaper &#xA7; 3.7 talks about a "beacon server", could this be used to generate a list?
>
> If so, I'm assuming FOKS servers notify the beacon server about their existence. Some server owners may not want their server listed, is there a way to either (1) tell the beacon server not to include the server in a publicly visible list, or (2) tell *this* server not to send any information to the beacon server?

### Build and host your own server

I am planning to document how to build a FOKS server [on this site](../server/setup.md), however I haven't actually *done* it yet. (I've tried once, ran into a problem, and haven't had time to get back to it.)

For now, see [Max's documentation](https://github.com/foks-proj/go-foks/blob/main/docs/server.md) in the source code.

## `foks signup`

Once you've selected a server, run the `foks signup` command to create a new user account on that server.

* `foks signup`
    ```
    $ foks signup
    ╔══════════════════════════════════════════════════════════╗
    ║                                                          ║
    ║ 🔑 Welcome to the Federated Open Key Service -- FOKS! 🔑 ║
    ║                                                          ║
    ╚══════════════════════════════════════════════════════════╝

    Let's signup

      🆗 Press <Enter> to get started
      ☮️  Or <Ctrl+C> or <Esc> at any time to quit
    ```

* Select a server.
    ```
    ┌────────────────────────────────────────────┐
    │ ✓ Using a local device key (not a yubikey) │
    └────────────────────────────────────────────┘

        Select a home server

       > 🏠 foks.app     (perfect for individuals and small teams)
         🏢 vh.foks.app  (team admins: stand-up a virtual server)
         🏄‍♂️ -            (specify a custom server)
    ```

* Enter your email address. This is so the server operator has a way to contact you in case of problems.
    ```
    ┌────────────────────────────────────────────┐
    │ ✓ Using a local device key (not a yubikey) │
    │ ✓ Using FOKS host: foks.app                │
    └────────────────────────────────────────────┘

        What's your email address?


        > xxxxx@example.com

       ✅ Email accepted; push <return> to continue
    ```

* If you have one, enter your "invite code". I suspect this was needed at the very beginning, however this is no longer required.
    ```
    ┌────────────────────────────────────────────┐
    │ ✓ Using a local device key (not a yubikey) │
    │ ✓ Using FOKS host: foks.app                │
    │ ✓ Email: xxxxx@example.com                 │
    └────────────────────────────────────────────┘

        Enter your optional invite code (or leave blank to skip)


        >
    ```

* Choose a username on the server.
    ```
    ┌────────────────────────────────────────────┐
    │ ✓ Using a local device key (not a yubikey) │
    │ ✓ Using FOKS host: foks.app                │
    │ ✓ Email: xxxxx@example.com                 │
    └────────────────────────────────────────────┘

        Pick a username (3-25 characters, with some Latin Unicode, hypens, periods, and underscores)


        > example123

       ✅ Username available; push <return> to continue
    ```

* Choose a device name.
    ```
    ┌────────────────────────────────────────────┐
    │ ✓ Using a local device key (not a yubikey) │
    │ ✓ Using FOKS host: foks.app                │
    │ ✓ Email: xxxxx@example.com                 │
    │ ✓ Username: example123                     │
    └────────────────────────────────────────────┘

        Pick a device name:


        > MyComputer

       ✅ Device name accepted; push <return> to continue
    ```

* The user account is created, and you will see a summary.
    ```
    ┌────────────────────────────────────────────┐
    │ ✓ Using a local device key (not a yubikey) │
    │ ✓ Using FOKS host: foks.app                │
    │ ✓ Email: xxxxx@example.com                 │
    │ ✓ Username: example123                     │
    │ ✓ Device name: MyComputer                  │
    └────────────────────────────────────────────┘

     🔑 Welcome to FOKS 🔑

      Your account is now ready to use. Have fun, and remember,
      not your keys, not your data!


     Next Steps You Might Consider️:

        🔑 Create a backup key          foks key new
        📄 Store files and string data  foks kv put
        🔀 Host a git repository        foks git create
        🤝 Create a team                foks team create
        🌐 Setup billing via web        foks admin web



     ✌️  Press any key to exit.
    ```


## Create a backup key

> &#x2757;&#xFE0F; **MAKE SURE TO CREATE A BACKUP KEY!**
>
> This is the #1 most important thing to remember about FOKS. I *cannot* stress this strongly enough.
>
> Any data *stored* in your FOKS account is encrypted using "device keys". If you lose all of your devices, you will *cryptographically* lose access to all data stored in the account. There is nothing that the server owner, or Max, can do to help you regain access to your data.

If all of your devices are lost, a backup key will allow you to regain access to the account, including the data *stored* in the account.

If your account only *has* a single device key, the `foks key ls` command will warn you about this:

```
$ foks key ls
┌───────────────────────────────────────────────────────────────────────────────────┐
│ All keys for 👤 example123 @ foks.app                                             │
├────────┬────────────┬────────┬────────────┬───────────────────────────────────────┤
│ ACTIVE │ NAME       │ TYPE   │ CREATED    │ ID                                    │
├────────┼────────────┼────────┼────────────┼───────────────────────────────────────┤
│ *      │ MyComputer │ device │ 2025-09-21 │ .4FYMa91Exxxxxxxxxxxxxxxxxxxxxxxxxxxx │
└────────┴────────────┴────────┴────────────┴───────────────────────────────────────┘
┌──────────────────────────────────────────────────────┐
│ All profiles available on this machine               │
├────────┬────────────┬──────────┬────────┬────────────┤
│ ACTIVE │ USERNAME   │ HOSTNAME │ TYPE   │ KEY NAME   │
├────────┼────────────┼──────────┼────────┼────────────┤
│ *      │ example123 │ foks.app │ device │ MyComputer │
└────────┴────────────┴──────────┴────────┴────────────┘

 ☠️ ☠️  DATA LOSS WARNING ☠️️ ☠️

 You only have one active device; if you lose access to it, you will lose access to all
 data stored in this account. FOKS uses true end-to-end encryption, so your service provider
 does not store backup keys. Protect yourself! Try:

      🛟 foks key new

 If you prefer to YOLO it and dismiss this warning without action, the command is:

      🔥 foks notify clear-device-nag
```

(There's no way to show it using Markdown, but the "DATA LOSS WARNING" message will be printed in red. It's meant to get your attention.)

As you can see, there *is* a way to disable this warning without creating a backup key, however that is NOT a good idea.

**To create a backup key** ...

* Run `foks key new`.
    ```
    $ foks key new
    ╔══════════════════════════════════════════════════════════╗
    ║                                                          ║
    ║ 🔑 Welcome to the Federated Open Key Service -- FOKS! 🔑 ║
    ║                                                          ║
    ╚══════════════════════════════════════════════════════════╝

    Let's make a new key

      🆗 Press <Enter> to get started
      ☮️  Or <Ctrl+C> or <Esc> at any time to quit
    ```

    Hit ENTER.

* The next question is, who to create a key for. This is because it's possible for a single computer to be attached to multiple FOKS accounts, normally on different servers but possibly on the same server.
    ```
        Who needs a new key?

         🆕 A new user on this device
       > 👤 example123 @ foks.app <📱 device: MyComputer> [ACTIVE]
    ```

    Be sure to select the active account (use the &#x2191; and &#x2193; keys) before hitting ENTER. (Selecting "A new user on this device" will start the process of adding this computer as a device on an existing FOKS account. This is covered on the [Working with Keys and Devices](keys.md#add-a-computer) page.

* The next screen asks what type of key you want to create. At the moment there's only one option, but if there are multiple options in the future, be sure to select "A new backup key".
    ```
    Why type of key do you want to make?

   > 💾 A new backup key (to write down on paper)
    ```

* The new backup key will be created and printed to the screeen.

    ```
     💾 New Backup Key Activated 💾

      Here is your key. Please write it down and keep it in a safe place:


          evoke 3992 antenna 1804 rebel 8192 nasty 337 target 7177 burger 1010 car 5506 maze 994 rely



     ✌️  Press any key to exit.
    ```

    **Save the key somewhere safe.** The most common way to do this would be to write it on paper and physically store it somewhere safe, such as a bank safety deposit box.

    **This is the ONLY time the backup key will be shown.** Once this terminal window is gone, there is no way to show the backup key again.

Future `foks key ls` commands will show the backup key as a key on the account.

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



Note about macOS Keychain &#x21D2; [Key Storage](key-storage.md) page
