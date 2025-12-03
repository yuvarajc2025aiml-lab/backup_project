#!/bin/bash

# =========================================================
#         LINUX AUTOMATED BACKUP SCRIPT (UBUNTU)
# =========================================================
# Features:
#  ✔ Compresses source directory
#  ✔ Adds timestamp to backup files
#  ✔ Ensures backup directory exists
#  ✔ Generates detailed logs
#  ✔ Safe for cron automation
# =========================================================

# -------- CONFIGURATIONS --------
SOURCE_DIR="$HOME/backup_project/data"
BACKUP_DIR="$HOME/backup_project/backups"
LOG_FILE="$BACKUP_DIR/backup.log"

# -------- PREPARE DIRECTORIES --------
mkdir -p "$BACKUP_DIR"

# -------- TIMESTAMP --------
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="backup_${TIMESTAMP}.tar.gz"
BACKUP_PATH="${BACKUP_DIR}/${BACKUP_FILE}"

# -------- LOGGING FUNCTION --------
log() {
    local STATUS="$1"
    local MESSAGE="$2"
    echo "$(date +"%Y-%m-%d %H:%M:%S") | ${STATUS} | ${MESSAGE}" >> "$LOG_FILE"
}

log "INFO" "Backup process started."

# -------- CHECK SOURCE DIRECTORY --------
if [ ! -d "$SOURCE_DIR" ]; then
    log "ERROR" "Source directory does not exist: $SOURCE_DIR"
    echo "Backup FAILED ❌ — Source directory missing!"
    exit 1
fi

# -------- CREATE BACKUP FILE --------
tar -czf "$BACKUP_PATH" -C "$SOURCE_DIR" . 2>> "$LOG_FILE"

# -------- CHECK TAR RESULT --------
if [ $? -eq 0 ]; then
    log "SUCCESS" "Backup successfully created: $BACKUP_PATH"
    echo "Backup completed successfully! 🎉"
else
    log "ERROR" "Backup failed while compressing files."
    echo "Backup FAILED ❌ — Check log file: $LOG_FILE"
    exit 1
fi

exit 0
