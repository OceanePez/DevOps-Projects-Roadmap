#!/bin/bash
KEY_PATH=./static-server.pem
REMOTE_USER=ubuntu
REMOTE_HOST=XXXXXXX
REMOTE_DIR=/var/www/staticserver
LOCAL_DIR=./Static-Site-Server

echo "Deploying to $REMOTE_USER@$REMOTE_HOST ..."
rsync -avz -e "ssh -i $KEY_PATH" --delete "$LOCAL_DIR/" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR/"
echo "Deployment done."
