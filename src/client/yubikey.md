# Yubikeys

> &#x2139;&#xFE0F; This page is just a rough outline of what I want to cover.

## Basics

* Hardware
    * Yubikeys are little computers, running "apps"
    * different hardware has different connectivity options (USB-A, USB-C, Lightning, NFC)
    * firmware is loaded at the factory, cannot be upgraded
        * Yubico has a history of "making it right" in case of bugs, several years ago they sent me a replacement Yubikey Neo due to a [security issue in the firmware](https://developers.yubico.com/ykneo-openpgp/SecurityAdvisory%202015-04-14.html).
* PIV app must be enabled
* FOKS (and common sense) requires that the PIN, PUK, and admin key cannot be default values
* [Yubikey Manager](https://www.yubico.com/support/download/yubikey-manager/) GUI program
    * deprecated after 2026-02-19
    * Yubico Authenticator is recommended, but seems to be missing functionality
* [Yubico Authenticator](https://www.yubico.com/products/yubico-authenticator/)
    * can enable/disable PIV app
    * cannot (yet?) set PIN/PUK codes
* [ykman](https://docs.yubico.com/software/yubikey/tools/ykman/)


### Debian 12

After installing FOKS

* `apt install pcscd` is necessary to interact with Yubikeys
    * this will start a background service as soon as it's installed
* `foks ctl start` is necessary for FOKS to work
* `foks key use-yubikey` - log into acct using Yubikey
* `foks key new` - create permanent key for device and "switch" to it
* physically remove yubikey
* `foks key remove` - remvoe yubikey

## Yubikey PIV app setup

### Install `ykman`

* macOS: `brew install ykman`
* others: &#x21D2; [Yubico Documentation](https://docs.yubico.com/software/yubikey/tools/ykman/Install_ykman.html)

### Show high-level status of Yubikey

```
$ ykman info
Device type: YubiKey 5C NFC
Serial number: 12345678
Firmware version: 5.4.3
Form factor: Keychain (USB-C)
Enabled USB interfaces: FIDO, CCID
NFC transport is enabled

Applications    USB             NFC
Yubico OTP      Disabled        Disabled
FIDO U2F        Enabled         Enabled
FIDO2           Enabled         Enabled
OATH            Disabled        Disabled
PIV             Enabled         Disabled
OpenPGP         Enabled         Enabled
YubiHSM Auth    Disabled        Disabled
```

### Enable the PIV app (if needed)

Some Yubikey devices support NFC in addition to USB. Apps can be enabled or disabled for each connection type. On my Yubikey I have the PIV app enabled for USB but disabled for NFC.

```
$ ykman config usb --enable piv
USB configuration changes:
  Enable PIV
Proceed? [y/N]: y
USB application configuration updated.
```

```
$ ykman config nfc --disable piv
NFC configuration changes:
  Disable PIV
Proceed? [y/N]: y
NFC application configuration updated.
```


### Reset the PIV app

If you're not 100% sure about the app's state, and you don't have any keys stored in the app that you can't afford to lose, you can reset the app back to its factory default state.

```
$ ykman piv reset
WARNING! This will delete all stored PIV data and restore factory settings. Proceed? [y/N]: y
Resetting PIV data...
Reset complete. All PIV data has been cleared from the YubiKey.
Your YubiKey now has the default PIN, PUK and Management Key:
        PIN:    123456
        PUK:    12345678
        Management Key: 010203040506070801020304050607080102030405060708
```


### Show status of the PIV app

After factory reset:

```
$ ykman piv info
PIV version:              5.4.3
PIN tries remaining:      3/3
PUK tries remaining:      3/3
Management key algorithm: TDES
WARNING: Using default PIN!
WARNING: Using default PUK!
WARNING: Using default Management key!
CHUID: No data available
CCC:   No data available
```

After changing PIN/PUK/Management key, and adding FOKS keys:

```
$ ykman piv info
PIV version:              5.4.3
PIN tries remaining:      3/3
PUK tries remaining:      3/3
Management key algorithm: TDES
Management key is stored on the YubiKey, protected by PIN.
CHUID: No data available
CCC:   No data available
Slot 82 (RETIRED1):
  Private key type: ECCP256

Slot 83 (RETIRED2):
  Private key type: ECCP256
```

### Generate a new random management key

It is possible to have the Yubikey generate a random PIV management key. However if you do this, you won't know what the key is, and therefore won't be able to perform any operations which *need* the management key.

We're going to generate the management key on the computer first. This allows us to store the key somewhere secure (i.e. in FOKS, 1Password, or some other secure storage) in case we need it in the future.

The commands shown below will generate a random key by reading 24 bytes from `/dev/urandom` and converting them to hex.

```
$ MKEY="$( head -c24 /dev/urandom | xxd -p -c0 )"
$ echo $MKEY
6c0113005314e3f7f07255e85696e9638e9da4dd1ac819ca
```

```
$ ykman piv access change-management-key \
    --management-key     010203040506070801020304050607080102030405060708 \
    --new-management-key "$MKEY"
New management key set.
```

### Change PIN and PUK

PUK is used to "unlock" a Yubikey after too many bad PIN attempts.

PIN and PUK must be 6-8 characters long. Any alphanumeric characters will work, however for compatibilty you may want to stick with digits.

```
$ ykman piv access change-pin --pin 123456 --new-pin 654321
New PIN set.
```

```
$ ykman piv access change-puk --puk 12345678 --new-puk 87654321
New PUK set.
```

