#!/bin/bash

echo "---> Backup preparation"

echo "-----> Paperless"

docker exec paperless document_exporter /usr/src/paperless/backup

echo "-----> Gitea"

docker exec -u git -it -w /backups gitea  bash -c '/usr/local/bin/gitea dump -c /etc/gitea/app.ini'

echo "-----> Delete old Mongo backups"

find /home/jens/backups/ -type f -name "*.archive" -mtime +30 -delete

echo "-----> Mongo"

docker exec mongo /backups/mongo_backup.sh

echo "---> Backup preparation DONE"

