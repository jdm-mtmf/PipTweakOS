# RecoveryOS

An open-source custom ROM, debloating, and hardware rehabilitation project designed to transform resource-constrained, malware-laden clone Android devices with unique form factors into clean, reliable, community-supported hardware.

Our inaugural target device is the **Soyes XS18 Pro (`Tigers TIS001_S4`)**—an ultra-compact 3.0-inch mini smartphone (`MT6580`, `2 GB RAM`, `16 GB eMMC`, `Android 10 / VNDK 29.0`) that ships from the factory with `SELinux Permissive`, rootkit-level bloatware (`WELCOME_M52`), a misconfigured `1.72 GB` ZRAM swap causing severe CPU thrashing, and a hardcoded `3500 mAh` battery profile on a `900 mAh` physical cell.

---

## Baseline Hardware & Firmware Findings (`XS18 Pro` / `TIS001_S4`)

| Component | Stock Reported Value | Verified Reality / Architectural Finding |
| :--- | :--- | :--- |
| **Model / Board ID** | `XS18 Pro` / `Tigers TIS001_S4` | Build `R80K3H1_SYE_C08_XS18Pro_Q_WELCOME_M52_20251126_1836` |
| **SoC / Kernel** | MediaTek MT6580 | **32-bit MediaTek MT6580** (`armv7l`, Linux `4.9.188`) |
| **OS / Treble** | Android 10 (`QP1A.190711.020`, API 29) | **Project Treble (`VNDK 29.0`)**, **System-as-Root**, **Dynamic Partitions (`super`)**, **A-only** |
| **SELinux** | **`Permissive`** | Factory disabled enforcement to allow ODM background services/rootkits |
| **Memory & ZRAM** | **1.92 GB RAM** + **1.72 GB ZRAM** | Real **2 GB LPDDR3**, crippled by a ~90% ZRAM swap allocation thrashing the Cortex-A7 CPU |
| **Internal Storage** | **16 GB** | **16 GB eMMC** |
| **Battery** | **3500 mAh** Design / **900 mAh** Full-Charge (`25.7%` health) | True **900 mAh** Li-Po cell; hardcoded `3500 mAh` `power_profile.xml` skews fuel gauge |
| **Display** | **640 x 480** @ `160 ppi`, reported as `5.00"` | Physical **3.0" VGA panel**; hardcoded `160 ppi` causes Android to compute $\frac{800\text{ px}}{160\text{ ppi}} = 5.0"$ |

---

## Documentation & Community Walkthrough

### Core Reference Documentation
- [Exposed: What Was Faked, Why It Was Unsafe & How RecoveryOS Fixes It](docs/EXPOSED-SPOOFING-AND-SECURITY-REPORT.md): Plain-English overview of the security flaws and hardware spoofing discovered on the XS18 Pro.
- [01 — Device Profile (`XS18 Pro / TIS001_S4`)](docs/01-device-profile.md): Complete hardware, kernel, and partition specifications.
- [02 — Malware, Rootkit, and Security Audit](docs/02-malware-and-audit.md): Analysis of stock `SELinux Permissive` posture, ZRAM misconfiguration, and hardware spoofing.
- [03 — Tools, Third-Party Applications, and Environment](docs/03-tools-and-environment.md): Every on-device and host tool used in the project.

### Step-by-Step Community Walkthrough (`docs/walkthrough/`)
- [Walkthrough Overview & Safety Index](docs/walkthrough/README.md)
- [Stage 1 — Host Setup & Read-Only ADB Audit](docs/walkthrough/01-adb-audit.md)
- [Stage 2 — Full BROM Backup & NVRAM Preservation](docs/walkthrough/02-brom-backup.md)
- [Stage 3 — Bootloader Unlock & `vbmeta` Verification Disabling](docs/walkthrough/03-bootloader-unlock.md)
- [Stage 4 — Kernel Ramdisk (`boot.img`) & `vendor` Sanitization](docs/walkthrough/04-ramdisk-and-vendor-sanitization.md)
- [Stage 5 — Custom ROM / Treble GSI Flashing (`fastbootd`)](docs/walkthrough/05-custom-rom-gsi-flashing.md)
- [Stage 6 — Hardware Overlays, Battery Calibration & Radio Tuning](docs/walkthrough/06-hardware-overlays-and-tuning.md)

## Repository Layout

- `docs/` — Hardware profiles, security audits, tool inventories, and the stage-by-stage walkthrough.
- `device/soyes/xs18pro/` — Device-specific configurations, `fstab.mt6580` patches, and Runtime Resource Overlays (RRO).
- `scripts/` — Reproducible host shell scripts for auditing, backing up, and flashing.

## License

Licensed under the [Apache License, Version 2.0](LICENSE).
