# Projects CloudSync

A small shell script used to keep my Projects folder in sync with a few cloud storage services that don't support symlinked folders. This script:

  - Allows me to keep my `~/Projects` folder living in my home directory, and then have it synced with a number of cloud storage providers to maximize redundancy of my personal project and documents data.
  - Only copies over files that changed since the last sync
  - Writes a log file of its output, rolling over to a new log file each day
  - Run every X minutes via crontab to keep my backups current

To set things up, clone this repo, and then setup your crontab job to run this script every 15 minutes:

```bash
echo "*/15 * * * * ~/Projects/cloud-sync/sync.sh" >> ~/.crontab
crontab ~/.crontab
```

This script was made to solve a very specific (and probably rare) use-case. Feel free to adapt it for your own uses. If you think this would be of use to you but you're unfamiliar with the tools don't hesitate to contact me for help getting things started.
