# RecoveryOS Automation Scripts

This directory contains host-side shell and Python scripts to automate non-destructive device auditing, partition backups, and image preparation.

## Planned Scripts
- `01-adb-audit.sh` — Runs Stage 1 read-only ADB data collection (`getprop`, package list with APK paths, `/proc/partitions`, `/proc/meminfo`, `/proc/swaps`, mount points, and battery stats).
- `02-backup-partitions.sh` — Runs Stage 2 `mtkclient` full partition backup (`nvram`, `nvdata`, `proinfo`, `protect1`, `protect2`, `seccfg`, `lk`, `boot`, `recovery`, `vbmeta`, `super`) and generates `SHA256SUMS`.
