#!/usr/bin/env bash

# Get the location this script is running in
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

logsdir="$dir/logs"
log="$logsdir/output-$(date -u +'%Y%m%d').txt"
syncPrefix=".CloudSync_"

if [ ! -f "$dir/excludes.txt" ]; then
	echo "Unable to find excludes.txt This is required for the script to run. Make sure it exists in the same directory as this script." | tee -a "$log"
	exit 1
fi

if [ ! $(command -v duplicity) ]; then
	echo "duplicity is required but is not installed! This is available via most package managers such as APT or Homebrew. Install and try again."
	exit 1
fi

if [ ! -f "$dir/config.sh" ]; then
	echo "Unable to find $dir/config.sh. Make sure it exists and try again."
	exit 1
fi

source "$dir/config.sh"
export PASSPHRASE="$gpgEncryptionKeyPassphrase"
export SIGN_PASSPHRASE="$gpgEncryptionKeyPassphrase"

mkdir -vp "$logsdir"
echo "########################################################################" | tee -a "$log"
echo "$(date -u +'%Y-%m-%dT%H:%M:%SZ') Running cloud-sync" | tee -a "$log"
echo "$(date -u +'%Y-%m-%dT%H:%M:%SZ') Using bash version: $BASH_VERSION" | tee -a "$log"
$(ulimit -n 1024) | tee -a "$log"

for fIdx in "${!folders[@]}"; do
	backupLocation="$(dirname ${folders[$fIdx]})/${syncPrefix}$(basename ${folders[$fIdx]})"
	$(mkdir -vp "$backupLocation") | tee -a "$log"
	duplicity \
			--verbosity 9 \
			--encrypt-key "$gpgDecryptionKeyId" \
			--sign-key "$gpgEncryptionKeyId" \
			--exclude-globbing-filelist "$dir/excludes.txt" \
			"${folders[$fIdx]}" \
			"file://${backupLocation}" \
			| tee -a "$log"
	for cIdx in "${!clouds[@]}"; do
		if [ ! -d "${clouds[$cIdx]}/$(basename ${folders[$fIdx]})" ]; then
			echo "$(date -u +'%Y-%m-%dT%H:%M:%SZ') Directory does not exist. Creating ${clouds[$cIdx]}/$(basename ${folders[$fIdx]})" | tee -a "$log"
			mkdir -vp "${clouds[$cIdx]}/$(basename ${folders[$fIdx]})"
		fi
		echo "$(date -u +'%Y-%m-%dT%H:%M:%SZ') Syncing to cloud: ${clouds[$cIdx]}" | tee -a "$log"
		cp -rv "${backupLocation}"/** "${clouds[$cIdx]}/$(basename ${folders[$fIdx]})/"
	done
done

echo "$(date -u +'%Y-%m-%dT%H:%M:%SZ') Finished sync" | tee -a "$log"
