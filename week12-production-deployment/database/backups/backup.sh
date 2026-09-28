#!/usr/bin/env bash
# database/backups/backup.sh
# ─────────────────────────────────────────────────────────────────────────────
# PostgreSQL backup script – timestamped gzip-compressed pg_dump.
#
# USAGE:
#   chmod +x database/backups/backup.sh
#   ./database/backups/backup.sh
#
# ENVIRONMENT VARIABLES (all have defaults matching Docker Compose .env):
#   PGHOST     – Postgres host          (default: localhost)
#   PGPORT     – Postgres port          (default: 5432)
#   PGDATABASE – Database name          (default: shopdb)
#   PGUSER     – Database user          (default: shopuser)
#   PGPASSWORD – Database password      (default: shoppass)
#   BACKUP_DIR – Where to store backups (default: ./database/backups)
#   RETENTION_DAYS – Days to keep       (default: 7)
#
# RESTORE INSTRUCTIONS:
#   ── Docker Compose ──────────────────────────────────────────────────────
#   gunzip -c backup_20240101_120000.sql.gz | \
#     docker exec -i week12_postgres_1 psql -U shopuser -d shopdb
#
#   ── Kubernetes (kubectl exec) ─────────────────────────────────────────
#   # 1. Copy the backup file into the pod
#   kubectl cp backup_20240101_120000.sql.gz shop/<postgres-pod>:/tmp/
#   # 2. Restore inside the pod
#   kubectl exec -n shop <postgres-pod> -- bash -c \
#     "gunzip -c /tmp/backup_20240101_120000.sql.gz | psql -U shopuser -d shopdb"
#
#   ── pg_restore (for custom-format dumps, not used here) ──────────────
#   pg_restore -h $PGHOST -U $PGUSER -d $PGDATABASE backup.dump
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail   # Exit on error, unbound var, or pipe failure

# ── Configuration (env vars with defaults) ────────────────────────────────
PGHOST="${PGHOST:-localhost}"
PGPORT="${PGPORT:-5432}"
PGDATABASE="${PGDATABASE:-shopdb}"
PGUSER="${PGUSER:-shopuser}"
export PGPASSWORD="${PGPASSWORD:-shoppass}"   # pg_dump reads this from env

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${BACKUP_DIR:-${SCRIPT_DIR}}"
RETENTION_DAYS="${RETENTION_DAYS:-7}"

TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_FILE="${BACKUP_DIR}/backup_${PGDATABASE}_${TIMESTAMP}.sql.gz"

# ── Pre-flight checks ──────────────────────────────────────────────────────
if ! command -v pg_dump &>/dev/null; then
  echo "ERROR: pg_dump not found. Install postgresql-client." >&2
  exit 1
fi

mkdir -p "${BACKUP_DIR}"

# ── Run pg_dump and compress on-the-fly ───────────────────────────────────
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting backup of '${PGDATABASE}' on ${PGHOST}:${PGPORT}..."

pg_dump \
  --host="${PGHOST}" \
  --port="${PGPORT}" \
  --username="${PGUSER}" \
  --dbname="${PGDATABASE}" \
  --no-password \
  --format=plain \
  --verbose \
  2>/tmp/pg_dump_stderr.log \
  | gzip -9 > "${BACKUP_FILE}"

BACKUP_SIZE="$(du -sh "${BACKUP_FILE}" | cut -f1)"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup complete: ${BACKUP_FILE} (${BACKUP_SIZE})"

# ── Retention cleanup: remove backups older than RETENTION_DAYS ───────────
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Cleaning up backups older than ${RETENTION_DAYS} days..."
DELETED=0
while IFS= read -r old_backup; do
  rm -f "${old_backup}"
  echo "  Deleted: ${old_backup}"
  DELETED=$((DELETED + 1))
done < <(find "${BACKUP_DIR}" -name "backup_*.sql.gz" -mtime "+${RETENTION_DAYS}" -type f)

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Cleanup done. ${DELETED} old backup(s) removed."
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup job finished successfully."
