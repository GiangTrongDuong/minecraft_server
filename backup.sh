#!/bin/bash

BASE_DIR="/var/lib/pufferpanel/servers"
BACKUP_DIR="/backups"
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")

echo "[Backup] Starting backup at $TIMESTAMP"

# Loop through each server
for SERVER_ID in $(ls -1 $BASE_DIR); do
    WORLD_PATH="$BASE_DIR/$SERVER_ID/mc/world"

    if [ -d "$WORLD_PATH" ]; then
        ZIP_NAME="world-${SERVER_ID}-${TIMESTAMP}.zip"
        ZIP_PATH="$BACKUP_DIR/$ZIP_NAME"
        zip -r "$ZIP_PATH" "$WORLD_PATH" > /dev/null

        echo "[Backup] Backed up $WORLD_PATH to $ZIP_PATH"
    else
        echo "[Backup] World folder not found for server $SERVER_ID"
    fi
done

echo "[Backup] All eligible worlds backed up."

