# Installing FOKS

> &#x2139;&#xFE0F; This page is just a rough outline of what I want to cover.

## Installing FOKS

The [official directions](https://foks.pub/#download) have quick directions on how to install the software. Below is essentially a copy of the official directions.

* macOS

    * If [Homebrew](https://brew.sh/) is not installed, install it.
        ```
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        ```

    * Install the `foks` package.
        ```
        brew isntall foks
        ```
* Linux

    In addition to installing the software, these commands will install the apt/yum repository *containing* the foks software, so that normal `apt`/`dnf`/`yum` commands will work as expected.

    * Debian-ish: as root
        ```
        curl -fsSL https://pkgs.foks.pub/install.sh  | sh
        ```

    * Redhat-ish: as root
        ```
        curl -fsSL https://pkgs.foks.pub/install.sh | sh
        ```

    In addition, if you plan to use a Yubikey, you will need to install the `pcscd` software.

    * Debian-ish: as root
        ```
        apt install pcscd libpcsclite-dev
        ```
    * Redhat-ish: as root &#x2757;&#xFE0F; not tested yet
        ```
        yum install pcscd
        ```

* windows

    * [Here's a nickel, kid. Get yourself a better computer.](https://jms1.pub/funny/heres-a-nickel.jpg)

        But seriously ... the only windows machine I own is an old laptop running "windows 7", which I haven't booted up in probably two years ... and because it's windows, I haven't connected it to *any* network in at least five years. (I only keep it around to program radios that [CHIRP](https://chirpmyradio.com/projects/chirp/wiki/Home) doesn't support.)

    * The official directions say to run this command.
        ```
        winget install foks
        ```

## Upgrading FOKS

Install the new software over the existing software.

* macOS
    ```
    brew update && brew upgrade foks
    ```
* Linux
    * Debian-ish: as root
        ```
        apt update && apt upgrade foks
        ```
    * Redhat-ish: as root
        ```
        dnf check-update && dnf update foks
        ```
        * or `yum check-update && dnf update foks`, depending on which distro/version you're using

* windows

    The official directions don't mention upgrading, and I don't have a windows machine to try it. I would *assume* that this "winget" thing has a `winget update` command that could be used to upgrade the software? If anybody knows, please let me know, or even better, open a pull request and update this page.


## Installing on [Tails](https://tails.net/)

> &#x1F6D1; If you are seeing this, the directions below are what I think *should* work, but there are some permission-related issues I need to figure out first.

Last tried using Tails 6.18, note that Tails 7.0 is out now so I need to revisit this.

* If the stick doesn't have persistent storage (have not tried this)
    * Download `.deb` file by hand
        * [github releases](https://github.com/foks-proj/go-foks/releases)
        * download `foks_n.n.n_amd64.deb`
    * `sudo apt install ./foks_n.n.n_amd64.deb`
    * `foks ctl start`

* If the stick does have persistent storage (tried, not successful yet)
    * as `amnesia` user
        * download `.list` and `.gpg` files (as `amnesia` user, `curl` doesn't seem to want to work for root)
        * edit `foks.list`
            * URL needs to start with `tor+http`
            * &#x2753; may need to change path to PGP key
    * as root
        * set up persistent `/etc/apt/sources.list.d/`
        * set up persistent `/usr/share/keyrings/`
            * &#x1F6D1; doesn't work, `_apt` user can't traverse `/live/persistence/TailsData_unlocked` so the symlinks are not usable
            * if there's a bind-mounted directory we can use (so symlinks aren't being followed) then we *should* be able to store the `.gpg` file there and adjust the filename in the `foks.list` file
        * install `foks.list` and `.gpg` files
    * reboot
    * `sudo apt install foks`
    * when pop-up asks if you want it to be persistent, say yes
