# Key Storage

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

* macOS Keychain authorization
    * explain: item containing device key is flagged to allow `foks` to access it without additional authorization
        * allows FOKS to log into acct without asking for auth
        * allows `foks key switch` without asking for auth
    * how to change this
        * find item in keychain
        * click "Access Control"
        * remove `foks` from list &#x21D2; require approval via GUI pop-up
        * maybe turn on "Ask for Keychain password" &#x21D2; the GUI pop-up will require you to enter the "keychain password" (usually same as macOS login password)
