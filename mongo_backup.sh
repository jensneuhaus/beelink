#!/bin/bash
mongodump --archive=/backups/mongodb_backup_$(date +"%Y%m%d_%H%M%S").archive \
          --username=$MONGO_INITDB_ROOT_USERNAME \
          --password=$MONGO_INITDB_ROOT_PASSWORD \
          --authenticationDatabase=admin
