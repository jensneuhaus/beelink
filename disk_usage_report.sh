#!/bin/bash
# Beelink Weekly/System Report + Docker-Abschnitt
# Hinweis: Für Mailversand muss 'mail' (bsd-mailx / mailutils) vorhanden sein.

set -euo pipefail
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

EMAIL="kontakt@jensneuhaus.de"  # Deine E-Mail-Adresse
HOSTNAME=$(hostname)

# ---- Speicherstatus Root ----
USAGE=$(df --output=pcent / | tail -n 1 | tr -dc '0-9')

if [ "$USAGE" -ge 90 ]; then
  SUBJECT="[BEELINK] Speicherplatz-Report: ${USAGE}% (WARNUNG!)"
else
  SUBJECT="[BEELINK] Speicherplatz-Report: ${USAGE}%"
fi

DISK_INFO=$(df -h)
DIR_DETAILS=$(du -sxh /home/jens/backups /home/jens/docker /home/jens/pgbackups /var/log /var/lib/docker /tmp /usr 2>/dev/null | sort -rh)
RAM_INFO=$(free -h | awk '/Mem:/ {print}')
UPTIME_INFO=$(uptime)
LAST_LOGIN=$(last -n 5 | head -5)
FAILED_LOGINS=$(journalctl -u ssh --since "1 day ago" 2>/dev/null | grep 'Failed password' | tail -5 || true)

# ---- Docker-Abschnitt (optional, falls Docker vorhanden) ----
have_docker=false
if command -v docker >/dev/null 2>&1; then
  have_docker=true
fi

DOCKER_HEADER=""
DOCKER_PS_TABLE=""
DOCKER_RESTARTS=""
DOCKER_EXITED=""
DOCKER_DANGLING=""
DOCKER_DF=""

if $have_docker; then
  # Laufende Container kompakt
  DOCKER_PS_TABLE=$(docker ps --format "table {{.Names}}\t{{.Status}}\t{{.RunningFor}}" 2>/dev/null || true)

  # Restart-Zähler (Top 20)
  # RestartCount kommt aus docker inspect; wir schneiden führenden Slash vom Namen ab.
  if [ -n "$(docker ps -q 2>/dev/null)" ]; then
    DOCKER_RESTARTS=$(docker inspect -f '{{.Name}}: {{.RestartCount}}' $(docker ps -q) 2>/dev/null \
      | sed 's#^/##' | sort -k2 -nr | head -n 20)
  fi
  DOCKER_RESTARTS=${DOCKER_RESTARTS:-"(keine aktiven Container / keine Daten)"}

  # Exited-Container (Top 20)
  DOCKER_EXITED=$(docker ps -a --filter status=exited \
    --format "table {{.Names}}\t{{.Status}}\t{{.RunningFor}}" 2>/dev/null || true)
  [ -z "$DOCKER_EXITED" ] && DOCKER_EXITED="(keine exited Container)"

  # Dangling Volumes (verwaist)
  DOCKER_DANGLING=$(docker volume ls -f dangling=true --format '{{.Name}}' 2>/dev/null | sort | head -n 50 || true)
  [ -z "$DOCKER_DANGLING" ] && DOCKER_DANGLING="(keine)"

  # docker system df (Speicher)
  DOCKER_DF=$(docker system df 2>/dev/null || true)

  DOCKER_HEADER="------------------------------------------------
🐳 Docker-Status
"
fi

# ---- Mailtext zusammensetzen ----
MESSAGE=$(cat <<EOF
📢 **Systemstatus für $HOSTNAME**
------------------------------------------------
📂 Speicher belegt: ${USAGE}%

📌 Festplattenstatus (/):
$DISK_INFO

📁 Wichtige Verzeichnisse:
$DIR_DETAILS

🖥️ RAM-Nutzung:
$RAM_INFO

📈 Systemlast & Laufzeit:
$UPTIME_INFO

👤 Letzte erfolgreichen Logins:
$LAST_LOGIN

🔐 Letzte fehlgeschlagene SSH-Logins (24h):
$FAILED_LOGINS

$DOCKER_HEADER
▶ Laufende Container:
${DOCKER_PS_TABLE:-"(Docker nicht verfügbar)"}

🔁 Restart-Counter (Top 20):
${DOCKER_RESTARTS:-"(Docker nicht verfügbar)"}

🧟 Exited-Container:
${DOCKER_EXITED:-"(Docker nicht verfügbar)"}

🧹 Dangling Volumes:
${DOCKER_DANGLING:-"(Docker nicht verfügbar)"}

🧮 docker system df:
${DOCKER_DF:-"(Docker nicht verfügbar)"}
------------------------------------------------
EOF
)

# ---- E-Mail versenden ----
if command -v mail >/dev/null 2>&1; then
  printf "%s\n" "$MESSAGE" | mail -s "$SUBJECT" "$EMAIL"
else
  # Fallback: lokal loggen
  LOGFILE="/var/log/beelink_weekly_report.log"
  echo "WARN: 'mail' nicht gefunden – schreibe nach $LOGFILE"
  {
    echo "SUBJECT: $SUBJECT"
    echo "$MESSAGE"
    echo
  } | sudo tee -a "$LOGFILE" >/dev/null
fi

# Healthcheck (optional)
curl -m 10 --retry 5 https://hc-ping.com/44fb309b-6197-48c4-aeb8-2f9b1259288a 2>&1 || true



