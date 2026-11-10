# Tools, Third-Party Applications, and Environment

This document tracks every diagnostic application, flashing utility, driver, and filesystem tool used throughout the RecoveryOS project so community members can reproduce the workflow cleanly.

## 1. On-Device Diagnostic Applications
- **DevInfo** (Google Play Store)
  - **Purpose**: Initial user-space inspection of reported system properties, API level, security patch date, build fingerprint, SoC identifier, and sensor/memory readouts prior to ADB/root access.
  - **Caveat**: Reads standard Android system APIs and `/proc` nodes, which may be hooked or spoofed by modified stock firmware on clone devices.

## 2. Host Utilities (Planned / Recommended)
- **ADB & Fastboot (`android-tools`)**: For shell access, property dumps (`getprop`), package auditing (`pm list packages -f`), and bootloader unlocking.
- **mtkclient**: Open-source MediaTek BROM/Preloader exploitation and partition backup/restore tool (critical for dumping full flash and `nvram`/`nvdata` before modifying partitions).
- **SP Flash Tool v5**: MediaTek scatter-based partition flashing tool.
