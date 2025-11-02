#!/bin/bash
#
# Generate restore commands for Redmine database
# Usage: ./generate-restore-commands.sh <backup.sql>
#

set -euo pipefail

# Check arguments
if [ $# -ne 1 ]; then
    echo "Usage: $0 <backup.sql>" >&2
    echo "" >&2
    echo "Example:" >&2
    echo "  $0 backup.sql" >&2
    exit 1
fi

BACKUP_FILE="$1"

# Check if backup file exists
if [ ! -f "$BACKUP_FILE" ]; then
    echo "Error: Backup file '$BACKUP_FILE' not found" >&2
    exit 1
fi

# Check if .env file exists
if [ ! -f .env ]; then
    echo "Error: .env file not found" >&2
    exit 1
fi

# Load environment variables
source .env

# Check required variables
if [ -z "${POSTGRES_USER:-}" ] || [ -z "${POSTGRES_DB:-}" ]; then
    echo "Error: POSTGRES_USER or POSTGRES_DB is not set in .env" >&2
    exit 1
fi

# Get absolute path of backup file
BACKUP_FILE_ABS=$(realpath "$BACKUP_FILE")

# Generate commands
cat <<EOF
docker compose up -d postgres
docker cp "${BACKUP_FILE_ABS}" redmine-postgres:/tmp/backup.sql
docker compose exec -T postgres psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -f /tmp/backup.sql
docker compose exec postgres rm /tmp/backup.sql
EOF
