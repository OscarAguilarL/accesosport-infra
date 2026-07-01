#!/bin/bash
set -euo pipefail

TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_DIR="/tmp/pg-backups"
S3_BUCKET="${S3_BACKUP_BUCKET:-accesosport-db-backups}"

mkdir -p "$BACKUP_DIR"

docker exec accesosport-postgres pg_dump \
  -U "${DB_USERNAME}" -d "${DB_NAME_PROD}" \
  | gzip > "$BACKUP_DIR/prod-$TIMESTAMP.sql.gz"

docker exec accesosport-postgres pg_dump \
  -U "${DB_USERNAME}" -d "${DB_NAME_STAGING}" \
  | gzip > "$BACKUP_DIR/staging-$TIMESTAMP.sql.gz"

aws s3 cp "$BACKUP_DIR/prod-$TIMESTAMP.sql.gz" \
  "s3://$S3_BUCKET/prod/$TIMESTAMP.sql.gz"

aws s3 cp "$BACKUP_DIR/staging-$TIMESTAMP.sql.gz" \
  "s3://$S3_BUCKET/staging/$TIMESTAMP.sql.gz"

rm -f "$BACKUP_DIR/prod-$TIMESTAMP.sql.gz" "$BACKUP_DIR/staging-$TIMESTAMP.sql.gz"
echo "Backup completado: $TIMESTAMP"
