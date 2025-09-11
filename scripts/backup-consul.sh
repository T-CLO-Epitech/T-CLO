#!/bin/bash
# Backup Terraform state from Consul KV

# === Configuration ===
CONSUL_ADDR="http://37.59.113.68:8500"          # Change to your consul address
CONSUL_KEY="terraform/test"                 # KV key where tfstate is stored
BACKUP_DIR="/home/azureuser/app/backup"       # Directory to store backups
LOG_FILE="/home/azureuser/app/backup/tfstate_backup.log"
KEEP_DAYS=7                                  # Keep backups for 7 days

# === Ensure dirs exist ===
mkdir -p "$BACKUP_DIR"
touch "$LOG_FILE"

# === Timestamp ===
DATE=$(date +'%Y-%m-%d_%H-%M-%S')
BACKUP_FILE="$BACKUP_DIR/tfstate_$DATE.zip"

# === Fetch tfstate JSON from Consul ===
curl -s "${CONSUL_ADDR}/v1/kv/${CONSUL_KEY}?raw" -o "/tmp/tfstate_${DATE}.json"
if [ $? -ne 0 ] || [ ! -s "/tmp/tfstate_${DATE}.json" ]; then
    echo "[$DATE] ERROR: Failed to fetch tfstate from Consul" >> "$LOG_FILE"
    exit 1
fi

# === Compress ===
zip -j "$BACKUP_FILE" "/tmp/tfstate_${DATE}.json" >> "$LOG_FILE" 2>&1
rm -f "/tmp/tfstate_${DATE}.json"

# === Cleanup old backups ===
find "$BACKUP_DIR" -type f -name "tfstate_*.zip" -mtime +$KEEP_DAYS -exec rm -f {} \; >> "$LOG_FILE" 2>&1

echo "[$DATE] Backup completed: $BACKUP_FILE" >> "$LOG_FILE"
