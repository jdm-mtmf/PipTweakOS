# PipTweakOS Automation Scripts

This directory contains host-side shell and Python scripts to automate non-destructive device auditing, partition backups, and image preparation.

## Scripts
- `01-adb-audit.sh` — Runs Stage 1 read-only ADB data collection (`getprop`, package list with APK paths, `/proc/partitions`, `/proc/meminfo`, `/vendor/etc/fstab*`, mount points, and battery stats).
- `01b-adb-neutralize-backdoors.sh` — Immediately stops, clears, disables, and uninstalls (`--user 0`) the active Redstone/Adups OTA backdoor (`com.abfota.systemUpdate`), the ODM spec spoofer (`com.tyd.configdisplay`), and `uid:1000` factory test bloatware.
- `02-backup-partitions.sh` — Runs Stage 2 `mtkclient` full partition backup (`nvram`, `nvdata`, `proinfo`, `protect1`, `protect2`, `seccfg`, `lk`, `boot`, `recovery`, `vbmeta`, `super`) and generates `SHA256SUMS`.
