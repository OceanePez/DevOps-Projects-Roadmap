#!/bin/bash

### Script to archive logs from the CLI with the date and time for CRON JOB
#Arguments

LOG_DIRECTORY="/var/log"
DAYS_TO_KEEP=7
DAYS_TO_BACKUP=30
COMPRESSION_FORMAT="tar"
OUTPUT_DIR="/tmp"
#Functions

spinner() {
    local pid=$1
    local delay=0.1
    local spin='|/-\'
    while [ -d /proc/$pid ]; do
        for i in $(seq 0 3); do
            printf "\r[%c] Archiving logs..." "${spin:$i:1}"
            sleep $delay
        done
    done
}



while [[ "$#" -gt 0 ]]; do
    case $1 in
        --dir) LOG_DIRECTORY="$2"; shift ;;
        --output) OUTPUT_DIR="$2"; shift ;;
        --keep) DAYS_TO_KEEP="$2"; shift ;;
        --backup) DAYS_TO_BACKUP="$2"; shift ;;
        --format) COMPRESSION_FORMAT="$2"; shift ;;
        *) echo "Unknown parameter: $1" ;;
    esac
    shift
done

#ARCHIVE THE LOGS
case $format in
    tar)
        name=archived_logs_$(date +%Y%m%d_%H%M%S).tar.gz
        tar -czf "$name" -C "$directory" . &
        spinner $!  # $! = PID du dernier processus lancé

        ;;
    gzip)
        name=archived_logs_$(date +%Y%m%d_%H%M%S).gz
        tar -czf "$name" -C "$directory" . &
        ;;
    zip)
        name=archived_logs_$(date +%Y%m%d_%H%M%S).zip
        zip -r "$name" "$directory" &
        ;;
    *)
        echo "Invalid compression format. Using tar by default."
        name=archived_logs_$(date +%Y%m%d_%H%M%S).tar.gz
        tar -czf "$name" -C "$directory" . &

        ;;
esac

spinner $!  
if [ $? -eq 0 ]; then
    printf "\r[✔] Logs archived successfully!\n"
else
    printf "\r[✖] Archiving failed.\n"
fi
mkdir -p "$output_dir"
#MOVE THE ARCHIVE TO THE OUTPUT DIRECTORY
mv "$name" "$output_dir"

#REMOVE THE OLD ARCHIVE
find "$output_dir" -type f -name "archived_logs_*" -mtime +$date_to_keep -delete
