#!/bin/bash

echo "========== Backup preparation started =========="

echo "--------> Paperless..."

docker exec paperless document_exporter /usr/src/paperless/backup

echo "--------> Gitea..."

set -Eeuo pipefail

echo "--------> Gitea..."

BACKUP_DIR="/home/jens/backups/gitea"
KEEP=1  # Nur das neueste behalten

mkdir -p "$BACKUP_DIR"

# 1) Alte temporäre Dateien entfernen
find "$BACKUP_DIR" -maxdepth 1 -type f -name '*.part' -delete || true

# 2) Neues Backup erzeugen (im Container, /backups ist auf $BACKUP_DIR gemountet)
docker exec -u git -w /backups gitea bash -lc '/usr/local/bin/gitea dump -c /etc/gitea/app.ini'

# 3) Prüfen, ob eine neue Datei entstanden ist
NEWEST="$(ls -1t "$BACKUP_DIR"/gitea-dump-* 2>/dev/null | head -n1 || true)"
if [[ -z "${NEWEST:-}" || ! -s "$NEWEST" ]]; then
  echo "✗ Kein gültiges Gitea-Backup gefunden – alte Backups bleiben erhalten."
  exit 1
fi

# 4) Ältere Backups löschen
DEL_LIST="$(ls -1t "$BACKUP_DIR"/gitea-dump-* 2>/dev/null | tail -n +$((KEEP+1)) || true)"
if [[ -n "${DEL_LIST:-}" ]]; then
  echo "Bereinige alte Backups:"
  echo "$DEL_LIST" | sed 's/^/  - /'
  echo "$DEL_LIST" | xargs -r rm -f
else
  echo "Nichts zu löschen – es existiert nur ${KEEP} Backup."
fi

echo "✓ Gitea-Backup erfolgreich: $(basename "$NEWEST")"

echo "--------> Pinging healthcheck..."

curl -m 10 --retry 5 https://hc-ping.com/7a592111-712b-4c68-841d-52b799fa237a

echo "========== Backup preparation ✅ =========="
