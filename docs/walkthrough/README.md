# RecoveryOS Walkthrough: Soyes XS18 Pro (`Tigers TIS001_S4`)

Welcome to the step-by-step community tutorial for reclaiming the **Soyes XS18 Pro (`Tigers TIS001_S4`)** from stock malware, rootkits, and factory misconfigurations.

> [!CAUTION]
> **Golden Rule Before Flashing**: Never format all flash or overwrite partitions before completing [Stage 2 — Full BROM Backup & NVRAM Preservation](02-brom-backup.md). MediaTek `MT6580` devices store unique cellular calibration and IMEI data in `nvram`, `nvdata`, `proinfo`, `protect1`, and `protect2`.

## Walkthrough Stages

1. **[Stage 1 — Host Setup & Read-Only ADB Audit](01-adb-audit.md)**
   Enable USB Debugging, connect to a Linux host, and run a non-destructive audit of running processes, pre-installed packages, mount points, and partition layout.
2. **[Stage 2 — Full BROM Backup & NVRAM Preservation](02-brom-backup.md)**
   Use `mtkclient` via the MediaTek BootROM/Preloader interface to dump the full partition table and safely back up `nvram`, `nvdata`, `boot`, `vbmeta`, and `super`.
3. **[Stage 3 — Bootloader Unlock & `vbmeta` Verification Disabling](03-bootloader-unlock.md)**
   Unlock the bootloader and disable Android Verified Boot (`dm-verity` / AVB 2.0) on `vbmeta` so modified `boot` and `system` images can boot cleanly.
4. **[Stage 4 — Kernel Ramdisk (`boot.img`) & `vendor` Sanitization](04-ramdisk-and-vendor-sanitization.md)**
   Unpack `boot.img` (`Linux 4.9.188`) and audit `/vendor` to strip `WELCOME_M52` rootkits/daemons and reduce `zram0` swap in `fstab.mt6580` from `1.72 GB` to a sane `512 MB`.
5. **[Stage 5 — Custom ROM / Treble GSI Flashing (`fastbootd`)](05-custom-rom-gsi-flashing.md)**
   Flash a clean, open-source 32-bit (`arm` / `armeabi-v7a`, `VNDK 29.0`) Project Treble Generic System Image or RecoveryOS image into the `super` dynamic partition.
6. **[Stage 6 — Hardware Overlays, Battery Calibration & Radio Tuning](06-hardware-overlays-and-tuning.md)**
   Install the RecoveryOS Runtime Resource Overlay (`power_profile.xml`) to fix the `3500 mAh -> 900 mAh` battery spoof, calibrate `480x640` display density, and optimize cellular/Wi-Fi antenna power states.
