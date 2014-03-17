#!/usr/bin/env bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
logsdir="$dir/logs"
log="$logsdir/output-$(date -u +'%Y%m%d').txt"

mkdir -p "$logsdir"
echo "########################################################################" >> "$log"
echo "$(date -u +'%Y-%m-%dT%H:%M:%SZ') Running cloud-sync" >> "$log"
echo "$(date -u +'%Y-%m-%dT%H:%M:%SZ') Using bash version: $BASH_VERSION" >> "$log"

projectsdir="$HOME/Projects"

clouds=( "$HOME/Google Drive" "$HOME/Box Sync" "$HOME/Cloud Drive" )

for idx in "${!clouds[@]}"; do
	if [ ! -d "${clouds[$idx]}/$(basename $projectsdir)" ]; then
		echo "$(date -u +'%Y-%m-%dT%H:%M:%SZ') Directory does not exist. Creating ${clouds[$idx]}/$(basename $projectsdir)" >> "$log"
		mkdir -p "${clouds[$idx]}/$(basename $projectsdir)"
	fi
	echo "$(date -u +'%Y-%m-%dT%H:%M:%SZ') Syncing to cloud: ${clouds[$idx]}" >> "$log"
	rsync --exclude ".DS_Store" --exclude "*.orig" --exclude "*.bak" \
		--exclude "._*" --exclude "Thumbs.db" \
		-av "$projectsdir" "${clouds[$idx]}/" 2>&1 >> $log
done

echo "$(date -u +'%Y-%m-%dT%H:%M:%SZ') Finished sync" >> "$log"
