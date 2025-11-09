#!/bin/bash

### Script to archive logs from the CLI with the date and time
#Arguments
echo "______________________________________________________________"
echo "|''''''''''''''''''''''Log Archive Tool''''''''''''''''''''''|"
echo "| This script archives logs from the CLI with the date and   |"
echo "| time.                                                      |"
echo "|                                                            |"
echo "|                                                            |"
echo "|                                                            |"
echo "| Author:@OcePez                                             |"
echo "|____________________________________________________________|"
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
    printf "\r[✔] Logs archived successfully!        \n"
}


give_arguments_please(){
    echo "Please provide the log directory as an argument."
    if [ -z $1 ]; then
            echo "No log directory provided. Using default: $LOG_DIRECTORY"
            read -p "Log Directory (default: $LOG_DIRECTORY): " directory
    else
        echo "Using provided log directory: $1"
        directory=$1
    fi
    read -p "Archive output directory (default: $OUTPUT_DIR): " output_dir
    read -p "Number of days to keep (default: $DAYS_TO_KEEP): " date_to_keep
    read -p "Number of days to backup (default: $DAYS_TO_BACKUP): " date_to_backup
    read -p "Compression format (tar/gzip/zip, default: $COMPRESSION_FORMAT): " format
}
verify_arguments(){
    # if [ -z "$directory" ]; then |
    #     directory=$LOG_DIRECTORY |  <---> directory=${directory:-$LOG_DIRECTORY}
    # fi                           |
    directory=${directory:-$LOG_DIRECTORY}
    directory_backup="$directory/backup"
    output_dir=${output_dir:-$OUTPUT_DIR}
    date_to_keep=${date_to_keep:-$DAYS_TO_KEEP}
    date_to_backup=${date_to_backup:-$DAYS_TO_BACKUP}
    format=${format:-$COMPRESSION_FORMAT}
}
   give_arguments_please
    verify_arguments
#Get and verify arguments
while true; do
    echo "You will be archiving logs from $directory to $output_dir, keeping logs for $date_to_keep days and backing up logs older than $date_to_backup days in $format format."
    echo "Do you agree to proceed? (y/n) You can also stop the script (stop)."
    read proceed
    if [ "$proceed" == "y" ]; then
        break
    elif [ "$proceed" == "n" ]; then
        give_arguments_please
        verify_arguments
    elif [ "$proceed" == "stop" ]; then
        echo "Script stopped by user."
        exit 0
    fi
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

#CREATE CRON JOB FOR AUTOMATIC ARCHIVING
read -p "Do you want to create a cron job ?(y/n)" cronok
if [ "$cronok" != "y" ]; then
    echo "No cron job created."
else
    # Ask for schedule
    echo "Enter the cron schedule expression (e.g., '0 2 * * *' for daily at 2 AM)"
    read -p "Cron schedule: " cron_schedule

    # Get the full path to this script (so cron can find it)
    script_path="$(realpath ./log-archive-for-cron.sh)"
    bash_path="$(which bash)"
    # Add cron job safely and redirect output to a log file
    (crontab -l 2>/dev/null; echo "$cron_schedule $bash_path $script_path >> /tmp/log_archive_cron.log 2>&1") | crontab -

    echo "It will run at schedule: $cron_schedule" # crontab -l to verify
fi


#EMAIL THE LOGS (doesn't work on macOS by default, needs mailutils or similar)
read -p "Do you want to email the archived logs ?(y/n)" emailok
if [ "$emailok" != "y" ]; then
    echo "No email sent."
else
    read -p "Enter recipient email address: " email
    echo "Emailing the archived logs to $email ..."
    echo "Please find the archived logs attached." | mail -s "Archived Logs" -A "$output_dir/$name" "$email"
    echo "Email sent." 
fi