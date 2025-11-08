#!/bin/bash


echo "----------------------------------------"
echo "----------Server logs report------------"
echo "----------------------------------------"

echo $(date)
echo "OS Version"
cat /etc/os-release | awk "/VERSION/" | head -n 1
echo "----------------------------------------"
uptime -p
#total cpu usage
echo "----------------------------------------"
echo "CPU Usage :"
mpstat 1 1 | awk '/Moyenne/ {printf "CPU usage: %.2f%%\n", 100-$NF}'
#Total memory usage (Free vs Used including percentage)
echo "Memory usage :"
free --human
echo "----------------------------------------"
#Total disk usage (Free vs Used including percentage)
df -h
echo "----------------------------------------"
#Top 5 processes by CPU usage
echo "Top 5 processes by CPU usage"
ps aux --sort=-%cpu |head -n 6
echo "----------------------------------------"
echo "Top 5 processes by memory usage"
#Top 5 processes by memory usage
ps aux --sort=-%mem |head -n 6

echo "----------------------------------------"

echo "Users connected:"
who
echo "----------------------------------------"


echo "Failed Logins"
echo "Failed login attempts:"
if [ -f "/var/log/auth.log" ]; then
    grep "Failed password" /var/log/auth.log | wc -l
else
    echo "Auth log not accessible or doesn't exist."
fi
echo "----------------------------------------"