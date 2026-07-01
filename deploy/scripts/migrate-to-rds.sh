#!/bin/bash
set -euo pipefail

RDS_ENDPOINT="${RDS_ENDPOINT:?Configurar RDS_ENDPOINT antes de ejecutar}"
BACKUP_DIR="/tmp/rds-migration"
mkdir -p "$BACKUP_DIR"

docker exec accesosport-postgres pg_dump \
  -U "${DB_USERNAME}" -d "${DB_NAME_PROD}" -Fc \
  > "$BACKUP_DIR/prod-migration.dump"

docker exec accesosport-postgres pg_dump \
  -U "${DB_USERNAME}" -d "${DB_NAME_STAGING}" -Fc \
  > "$BACKUP_DIR/staging-migration.dump"

PGPASSWORD="${DB_PASSWORD}" pg_restore \
  -h "$RDS_ENDPOINT" -p "${RDS_PORT:-5432}" -U "${DB_USERNAME}" \
  -d "${DB_NAME_PROD}" --no-owner "$BACKUP_DIR/prod-migration.dump"

PGPASSWORD="${DB_PASSWORD}" pg_restore \
  -h "$RDS_ENDPOINT" -p "${RDS_PORT:-5432}" -U "${DB_USERNAME}" \
  -d "${DB_NAME_STAGING}" --no-owner "$BACKUP_DIR/staging-migration.dump"

echo "PASO MANUAL: actualizar DB_HOST=$RDS_ENDPOINT en el .env del servidor"
echo "Luego: docker compose restart backend"

rm -f "$BACKUP_DIR/prod-migration.dump" "$BACKUP_DIR/staging-migration.dump"
