# This file gets sourced by sync.sh It should be renamed as config.example.sh

# Depending on how cron runs on your machine, you will probably want to source
# your .bashrc to ensure your PATH gets built correctly.
source "$HOME/.bash_profile"

# Key used for encryption & signing only. It should be DIFFERENT from your primary GPG key used for decryption
# This MUST be the 8-character short key, which can be found by running "gpg --list-keys"
gpgEncryptionKeyId=

# Since this config file must be stored in plaintext it is STRONGLY recommended
# that you use a key that is different from your decryption key
gpgEncryptionKeyPassphrase=

# This is the ONLY key that can decrypt your data, so it should be secure and ideally backed up to more than one place
# This can be the 8-character short key or the email found by running "gpg --list-keys"
gpgDecryptionKeyId=

# Each folder listed here will be synced to all clouds. Examples here are only meant
# to show syntax. Feel free to remove/replace them with whatever you'd like
folders=( "$HOME/Projects" "$HOME/Documents/Taxes" )

# All folders listed above get synced to all services listed here. Examples here are only
# meant to show syntax. Feel free to remove/replace them with whatever you'd like
clouds=( "$HOME/Dropbox" "$HOME/Google Drive" )
