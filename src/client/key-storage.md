# Secret Key Storage

> &#x2139;&#xFE0F; This page is just a rough outline of what I want to cover.


This page will talk about how "device keys" are stored on computers.

* `foks skm info`
    * `T` field values - from  `proto/lib/common.go`
        ```
        const (
                SecretKeyStorageType_PLAINTEXT          SecretKeyStorageType = 0
                SecretKeyStorageType_ENC_PASSPHRASE     SecretKeyStorageType = 1
                SecretKeyStorageType_ENC_MACOS_KEYCHAIN SecretKeyStorageType = 2
                SecretKeyStorageType_ENC_NOISE_FILE     SecretKeyStorageType = 3
                SecretKeyStorageType_ENC_KEYCHAIN       SecretKeyStorageType = 4
        )
        ```
    * other fields will depend on `T`

* 0 = Plain text
    * is this used at all?

* 1 = Passphrase
    * `foks passphrase` command
        * difference between `set` and `change`?

* 2 = macOS Keychain
    * default on macOS
    * has `f2` dictionary with `Account`, `Service`, and `SecretBox` keys
    * explain: item containing device key is flagged to allow `foks` to access it without additional authorization
        * this allows FOKS to log into acct without asking for auth
        * this also allows `foks key switch` without asking for auth, which can *seem* insecure
    * how to change this
        * find item in keychain
        * click "Access Control"
        * remove `foks` from list &#x21D2; require approval via GUI pop-up (clicking "always allow" will add `foks` back to the list)
        * maybe turn on "Ask for Keychain password" &#x21D2; when the GUI pop-up appears, it will require you to enter the "keychain password" (usually same as macOS login password) before clicking "allow" or "always allow"

* 3 = Noise File
    * default on linux if no GUI is present
    * has `f3` dictionary with `Filename`, and `SecretBox` keys
    * filename is in `$HOME/.config/foks/`, contains random garbage - presumably used to decrypt `foks-secrets` file in same directory

* 4 = Keychain
    * linux/gnome keychain?
