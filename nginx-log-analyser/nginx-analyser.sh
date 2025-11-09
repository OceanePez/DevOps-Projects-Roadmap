#!/bin/bash
file=""
if [ $# -ne 1 ]; then
    $file="nginx-access.log"
fi

echo "Top 5 IP addresses with the most requests:"
awk '{print $1}' $file | sort | uniq -c | sort -nr |awk '{print $2, "-",$1, "requests"}'| head -n 5

echo "Top 5 most requested paths:"
awk '{print $7}' $file | sort | uniq -c | sort -nr |awk '{print $2, "-",$1, "requests"}'| head -n 5

echo "Top 5 response status codes:"
awk '{print $9}' $file | sort | uniq -c | sort -nr |awk '{print $2, "-",$1, "requests"}'| head -n 5

echo "Top 5 user agents:"
awk -F'"' '{print $6}' $file | sort | uniq -c | sort -nr |awk '{print $2, "-",$1, "requests"}'| head -n 5

# -F <==> Field Separator