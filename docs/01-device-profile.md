# Device Profile: Soyes XS18 Pro / Tigers TIS001_S4

## Overview
- **Marketed / Clone Name**: Soyes XS18 Pro
- **Internal Board / Firmware ID**: Tigers `TIS001_S4`
- **Form Factor**: 3.0-inch Ultra-Compact Mini Smartphone (~90 x 46 x 10.5 mm, ~55g)
- **Diagnostic Source (Initial)**: `DevInfo` (Google Play Store)

## System & Build Details (Reported via `DevInfo`)
- **Android Version Name**: Android 10 (Quince Tart)
- **API Level**: `29`
- **Build ID**: `QP1A.190711.020` (Standard AOSP Android 10 release tag)
- **Build Number**: `R80K3H1_SYE_C08_XS18Pro_Q_WELCOME_M52_20251126_1836`
  - `R80K3H1`: Base board / ODM software revision identifier (`R80` = MT6580 Android 10 BSP family)
  - `SYE_C08_XS18Pro`: Customer/Brand code (`SYE` = Soyes, `C08` = variant, `XS18Pro` = model)
  - `Q`: Android 10 (Quince Tart) target branch
  - `WELCOME_M52`: ODM / sub-brand build flavor ("WELCOME" / M52 board config)
  - `20251126_1836`: Build timestamp (`2025-11-26 18:36`)
- **Build Time**: `26 NOV 2025 04:37:09 CST`
- **Security Patch Level**: `2020-10-05` (October 5, 2020)
- **Root Status (Userland `su`)**: Not Yet Rooted (no user-accessible `su` binary exposed)
- **SELinux Status**: **`Permissive`** *(Critical finding: stock firmware ships with SELinux disabled/permissive, typical of clone ROMs running unprivileged/rogue system daemons)*

## Kernel & Partition Architecture
- **Kernel Version**: `4.9.188`
- **Kernel Architecture**: `armv7l` (32-bit ARM kernel & userland)
- **Project Treble**: **Supported (`VNDK 29.0`)**
- **System-as-Root (SAR)**: **Supported**
- **Dynamic Partitions (`super`)**: **Supported** (logical partitions `system`, `vendor`, `product` inside `super`)
- **Seamless Updates (A/B)**: **Not Supported** (A-only physical partition layout; note that Dynamic Partition GSIs use the `ab`/SAR image format even on non-A/B devices)
- **Flash Protocol**: MediaTek Preloader / BROM (`mtkclient` / SP Flash Tool v5)
- **Critical Backup Partitions**: `nvram`, `nvdata`, `proinfo`, `protect1`, `protect2`, `seccfg`, `lk`, `boot`, `recovery`, `vbmeta`, `super`

## Reported vs. Verified Hardware Specifications

With `QP1A.190711.020`, `VNDK 29.0`, and `Linux 4.9.188 (armv7l)`, `DevInfo` reads the genuine underlying **MediaTek MT6580**, **Android 10 (32-bit)**, **2 GB RAM**, and **16 GB eMMC** hardware, while exposing hardcoded ODM misconfigurations in battery design capacity (`3500 mAh` vs. `900 mAh`), display DPI (`160 ppi` -> `5.0"`), and ZRAM (`1.72 GB`).

| Component | Reported by Device / `DevInfo` | Architectural Assessment / Verification Needed |
| :--- | :--- | :--- |
| **SoC / Chipset** | **MediaTek MT6580** | **Verified 32-bit MediaTek MT6580** (Quad-Core ARM Cortex-A7 @ 1.3 GHz, matching `armv7l` kernel and `R80K3H1` board ID) |
| **Architecture / ABI** | **`armv7l`** | **Verified 32-bit (`armeabi-v7a`)** — both kernel and binder are 32-bit |
| **Android Version** | **Android 10 (`QP1A.190711.020`, API 29)** | **Verified Android 10 (VNDK 29.0)** running on Linux `4.9.188` |
| **RAM** | **1.92 GB** (`SWAP/ZRAM`: **1.72 GB**) | **2 GB LPDDR3** physical RAM (with an overly aggressive ~90% `1.72 GB` ZRAM swap configuration causing heavy CPU thrashing on Cortex-A7) |
| **Storage (eMMC)** | **16 GB** | **16 GB eMMC** (standard for the 2 GB / 16 GB `XS18 Pro` configuration; partition layout to be verified via `/proc/partitions`) |
| **Display Resolution** | **640 x 480** @ **160 ppi (mdpi)**, **60 Hz**, No HDR, reported as **5.00"** | **480x640 VGA panel (~3.0" physical)**. Android computes `5.00"` because the kernel panel driver hardcodes `160 dpi` (`sqrt(640² + 480²) / 160 = 800 / 160 = 5.0"`), whereas true physical density on a 3.0" screen is ~267 ppi. |
| **Modem / Baseband** | _TBD_ | _Verify baseband version & radio bands_ |
| **Battery** | **3500 mAh** Design Cap (`4.22V`), **900 mAh** Est. Full-Charge (`25.7%` Health) | **900 mAh physical Li-Po cell**. The ODM hardcoded `3500 mAh` in `power_profile.xml`/kernel, causing Android to miscalculate `900 / 3500 = 25.7%` battery health and skew fuel-gauge discharge curves. |
