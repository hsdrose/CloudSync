#!/usr/bin/env bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
logsdir="$dir/logs"
log="$logsdir/output-$(date -u +'%Y%m%d').txt"

mkdir -p "$logsdir"
echo "########################################################################" >> "$log"
echo "$(date -u +'%Y-%m-%dT%H:%M:%SZ') Running cloud-sync" >> "$log"
echo "$(date -u +'%Y-%m-%dT%H:%M:%SZ') Using bash version: $BASH_VERSION" >> "$log"

projectsdir="$HOME/Projects"

# Each folder listed here will be synced to all clouds
folders=( "$HOME/Projects" "$HOME/Documents/Taxes" )
# All folders listed above get synced to all services listed here
clouds=( "$HOME/Google Drive" "$HOME/Box Sync" "$HOME/Cloud Drive" "$HOME/Dropbox" )

for fIdx in "${!folders[@]}"; do
	for cIdx in "${!clouds[@]}"; do
		if [ ! -d "${clouds[$cIdx]}/$(basename ${folders[$fIdx]})" ]; then
			echo "$(date -u +'%Y-%m-%dT%H:%M:%SZ') Directory does not exist. Creating ${clouds[$cIdx]}/$(basename ${folders[$fIdx]})" >> "$log"
			mkdir -p "${clouds[$cIdx]}/$(basename ${folders[$fIdx]})"
		fi
		echo "$(date -u +'%Y-%m-%dT%H:%M:%SZ') Syncing to cloud: ${clouds[$cIdx]}" >> "$log"
		rsync --exclude ".DS_Store" --exclude "*.orig" --exclude "*.bak" \
			--exclude "._*" --exclude "Thumbs.db" --exclude "node_modules"\
			-av "${folders[$fIdx]}" "${clouds[$cIdx]}/" 2>&1 >> $log
	done
done

echo "$(date -u +'%Y-%m-%dT%H:%M:%SZ') Finished sync" >> "$log"
