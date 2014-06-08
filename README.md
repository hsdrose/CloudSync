# Secure CloudSync

A tiny script to backup important files to multiple cloud services using strong, proven encryption.

This script:

  - Backs up any folder you specify to all cloud services you have on your machine.
  - Only copies files that have changed since the last sync
  - Keeps your data secure. It uses GPG encryption to ensure you are the only person who can access your data.
  - Is designed to run without any user interaction so it can be configured as a cron task

Please keep in mind the limitations of this script:

  - It doesn't physically upload anything. All it does is copy the _encrypted and incremental_ backups of your data to other folders on your machine. Individual cloud providers' official apps are used to watch their respective folders and upload changes as they come in.
  - The encryption key's passphrase must be stored in cleartext in a file you create and control. This is a limitation in the way [Duplicity](http://duplicity.nongnu.org/) (the tool that powers this script) is designed to work. Fortunately, this key is only used for _encryption_. _Decryption_ is done using a key whose passphrase never gets stored.
  - No checks are done to ensure the backup sizes don't go over the storage limits of individual cloud services. Watch your cloud capacity carefully. The backed up data is compressed which helps to mitigate this problem.
  - There is no automated script for recovery of encrypted of data. You must decrypt your backups manually using Duplicity on the command line. See the instructions below for how to do this.

## Getting Started

To get started, you'll need a Mac or Linux machine. Then do the following steps:

  1. Install [GnuPG](https://www.gnupg.org/) and [duplicity](http://duplicity.nongnu.org/). These are available via [Homebrew on OS X](http://brew.sh/), as well as Debian, Ubuntu and Fedora GNU/Linux distributions.
  2. Setup 2 keys with GPG. If you [follow these instructions](http://www.madboa.com/geek/gpg-quickstart/) key generation is pretty easy. The first key you need is main GPG key which is used for _decryption_ of backups (if you already use GPG you have already have this), and the second being your backup key, which will be used only for _encryption_ of backups. This backup key will also need to have its passphrase be stored in a plain text file, so *it is important that it is different from your main key*.
  3. Clone this repo
  4. Copy `config.example.sh` and rename it as `config.sh`.
  5. Update config.sh with relevant values.
  6. Setup your crontab job to run this script every 15 minutes:

```bash
echo "*/15 * * * * ~/Projects/cloud-sync/sync.sh" >> ~/.crontab
crontab ~/.crontab
```

## Data Recovery and Decryption

This script uses Duplicity (essentially a wrapper for GPG and rdiff) to create its backup files. Data recovery is performed directly with duplicity.

First, make sure the *public key* (matching the "`gpgEncryptionKeyId`" in your `conf.sh`) of the key used to encrypt your backups is in your GPG keychain. Then make sure both the *public and private key* (matching the "`gpgDecryptionKeyId`" in your config.sh) are available in your GPG keychange. The easiest way to do this is to make have a backup of the `~/.gpg/` folder from the machine you made the original backups from.

In all examples below, `gpgDecryptionKeyId` and `gpgEncryptionKeyId` correspond to the IDs used in your `config.sh`.

To completely restore an entire backup folder, run:

```bash
duplicity restore --encrypt-key "gpgDecryptionKeyId" --sign-key "gpgEncryptionKeyId" file:///FULL_PATH_TO_BACKUP_FOLDER /OUTPUT_PATH/
```

To see a list of all files in a backup, run:

```bash
duplicity list-current-files --encrypt-key "gpgDecryptionKeyId" --sign-key "gpgEncryptionKeyId" file:///FULL_PATH_TO_BACKUP_FOLDER
```

To restore a single file from a backup, note the path as it was displayed from the previous command then run:
```bash
duplicity restore --file-to-restore "PATH_LISTED_FROM_COMMAND_ABOVE" --encrypt-key "gpgDecryptionKeyId" --sign-key "gpgEncryptionKeyId" file:///FULL_PATH_TO_BACKUP_FOLDER /OUTPUT_PATH/
```

Duplicity also allows you to restore old versions of files using a `--time` flag. See the [Duplicity documentation](http://duplicity.nongnu.org/duplicity.1.html) for more details and a full set of available options.


This script was made to solve a very specific (and probably rare) use-case. Feel free to adapt it for your own uses. If you think this would be of use to you but you're unfamiliar with the tools don't hesitate to contact me for help getting things started.
