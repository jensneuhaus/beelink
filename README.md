# Beelink Scripts

## `backup_preparation.sh` - Dient dazu, Backup vorzubereiten bevor es weiterverarbeitet wird

```bash 
./backup_preparation.sh
========== Backup preparation started ==========
--------> Paperless...
No passphrase was given, sensitive fields will be in plaintext
100%|██████████| 10115/10115 [00:10<00:00, 989.85it/s]
--------> Gitea...
2025/11/08 13:15:06 ...s/storage/storage.go:176:initAttachments() [I] Initialising Attachment storage with type: local
2025/11/08 13:15:06 ...les/storage/local.go:33:NewLocalStorage() [I] Creating new Local Storage at /var/lib/gitea/data/attachments
2025/11/08 13:15:06 ...s/storage/storage.go:166:initAvatars() [I] Initialising Avatar storage with type: local
2025/11/08 13:15:06 ...les/storage/local.go:33:NewLocalStorage() [I] Creating new Local Storage at /var/lib/gitea/data/avatars
2025/11/08 13:15:06 ...s/storage/storage.go:192:initRepoAvatars() [I] Initialising Repository Avatar storage with type: local
2025/11/08 13:15:06 ...les/storage/local.go:33:NewLocalStorage() [I] Creating new Local Storage at /var/lib/gitea/data/repo-avatars
2025/11/08 13:15:06 ...s/storage/storage.go:186:initLFS() [I] Initialising LFS storage with type: local
2025/11/08 13:15:06 ...les/storage/local.go:33:NewLocalStorage() [I] Creating new Local Storage at /var/lib/gitea/git/lfs
2025/11/08 13:15:06 ...s/storage/storage.go:198:initRepoArchives() [I] Initialising Repository Archive storage with type: local
2025/11/08 13:15:06 ...les/storage/local.go:33:NewLocalStorage() [I] Creating new Local Storage at /var/lib/gitea/repo-archive
2025/11/08 13:15:06 ...s/storage/storage.go:208:initPackages() [I] Initialising Packages storage with type: local
2025/11/08 13:15:06 ...les/storage/local.go:33:NewLocalStorage() [I] Creating new Local Storage at /var/lib/gitea/packages
2025/11/08 13:15:06 ...s/storage/storage.go:219:initActions() [I] Initialising Actions storage with type: local
2025/11/08 13:15:06 ...les/storage/local.go:33:NewLocalStorage() [I] Creating new Local Storage at /var/lib/gitea/actions_log
2025/11/08 13:15:06 ...s/storage/storage.go:223:initActions() [I] Initialising ActionsArtifacts storage with type: local
2025/11/08 13:15:06 ...les/storage/local.go:33:NewLocalStorage() [I] Creating new Local Storage at /var/lib/gitea/actions_artifacts
2025/11/08 13:15:06 cmd/dump.go:172:runDump() [I] Dumping local repositories... /var/lib/gitea/git/repositories
2025/11/08 13:16:02 cmd/dump.go:217:runDump() [I] Dumping database...
2025/11/08 13:16:36 cmd/dump.go:229:runDump() [I] Adding custom configuration file from /etc/gitea/app.ini
2025/11/08 13:16:36 cmd/dump.go:244:runDump() [I] Custom dir /var/lib/gitea/custom is inside data dir /var/lib/gitea, skipped
2025/11/08 13:16:36 cmd/dump.go:256:runDump() [I] Packing data directory.../var/lib/gitea
2025/11/08 13:18:17 cmd/dump.go:335:runDump() [I] Finish dumping in file /backups/gitea-dump-1762607706.zip
--------> Pinging healthcheck...
OK========== Backup preparation ✅ ==========
```

## `disk_usage_report.sh`

```bash
./disk_usage_report.sh
===== WEEKLY REPORT - 2025-11-08 13:23:28 – START =====
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100     2  100     2    0     0     15      0 --:--:-- --:--:-- --:--:--    15
OK===== WEEKLY REPORT - 2025-11-08 13:23:32 – ENDE =====
```

