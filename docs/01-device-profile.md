# Device Profile: Soyes XS18 Pro / Tigers TIS001_S4

## Overview
- **Marketed / Clone Name**: Soyes XS18 Pro
- **Internal Board / Firmware ID**: Tigers `TIS001_S4` (`ro.product.board`: `r80h1_sye_c08`)
- **Upstream Donor Firmware Fingerprint**: `iku/A25/A25:10/QP1A.190711.020/mp1V986:user/release-keys` (May 31, 2020 ODM base re-packaged on Nov 26, 2025)
- **USB Vendor / Product ID (ADB/MTP)**: `0e8d:201d` (`TIGERS TIS001_S4`, Serial `0123456789ABCDEF`)
- **Form Factor**: 3.0-inch Ultra-Compact Mini Smartphone (~90 x 46 x 10.5 mm, ~55g)

## System & Build Details (Verified via Stage 1 ADB Audit)
- **Android Version Name**: Android 10 (Quince Tart, Go Edition `10_202009.go`, `ro.config.low_ram=true`)
- **API Level**: `29` (`VNDK 29.0`)
- **Build ID**: `QP1A.190711.020`
- **Build Number**: `R80K3H1_SYE_C08_XS18Pro_Q_WELCOME_M52_20251126_1836`
- **Build Fingerprint**: `TIGERS/TIS001_S4/TIS001_S4:10/QP1A.190711.020/mp1V986:user/release-keys`
- **Baseband Version**: `MOLY.WR8.W1449.MD.WG.MP.V350.3` (`2024/11/28 16:46`, `LENTEK_Q0MP1_K80_BSP_HSPA_HW`, 2G/3G `W/G`)
- **Security Patch Level**: `2020-10-05`
- **SELinux Status**: **`Permissive`** (`getenforce` returns `Permissive`)
- **Encryption**: File-Based Encryption (`ro.crypto.type=file`, `adiantum` cipher on `f2fs` `/data`)

## Verified Hardware Specifications

| Component | Stock Reported / Configured | Verified Hardware Reality (`ADB` / `/proc` / `dumpsys`) |
| :--- | :--- | :--- |
| **SoC / Chipset** | **MediaTek MT6580** | **MediaTek MT6580** (4x ARMv7 Cortex-A7 `0xc07` rev 3 @ 1.3 GHz, Mali-400 GPU) |
| **Connectivity SoC** | `0x6580` | MediaTek MT6580 integrated Wi-Fi/BT/GPS (`patch 20200629194517a`) |
| **Touchscreen IC** | _N/A_ | FocalTech / SemiConductor **`tlsc6x`** (`irq/261-tlsc6x_`) |
| **RAM** | `2009708 kB` (**1.92 GB**) | **2 GB LPDDR3** (`ro.vendor.mtk_config_max_dram_size=0x80000000`) |
| **ZRAM Swap** | `1808732 kB` (**1.72 GB**) | **`zramsize=90%,max_comp_streams=1`** in `/vendor/etc/fstab.mt6580` (single-stream compression bottleneck across 4 cores!) |
| **Storage (eMMC)** | **16 GB** | **16 GB eMMC** (`11120000.mmc`): `system` (`679M`), `vendor` (`97M`), `product` (`613M`), `userdata` (`12G` `f2fs`), `cache` (`104M`) |
| **Display** | `480 x 640` @ `160 dpi` (`5.00"`) | Physical **3.0" 480x640 panel** (`ro.sf.lcd_density=160` causes `800px / 160dpi = 5.0"` calculation) |
| **Battery** | `3500 mAh` (`persist.sys.selbattery=3500`) | **`900 mAh` (`Charge counter: 900000` uAh)** @ `4.36V` full charge |

## eMMC Partition Map (`/dev/block/platform/bootdevice/by-name/`)

| Partition Name | Block Device | Mount / Role | Backup Priority |
| :--- | :--- | :--- | :--- |
| `preloader_a` / `b` | `/dev/block/mmcblk0boot0` / `boot1` | MediaTek Preloader / DRAM init | **Critical** |
| `proinfo` | `/dev/block/mmcblk0p1` | Product info / serial / board config | **Critical (Unique)** |
| `nvram` | `/dev/block/mmcblk0p2` | RF calibration & IMEI NVRAM | **Critical (Unique)** |
| `protect1` | `/dev/block/mmcblk0p3` | `/mnt/vendor/protect_f` (ext4 modem calibration) | **Critical (Unique)** |
| `protect2` | `/dev/block/mmcblk0p4` | `/mnt/vendor/protect_s` (ext4 modem calibration) | **Critical (Unique)** |
| `seccfg` | `/dev/block/mmcblk0p5` | Bootloader lock state & security config | **High** |
| `lk` / `lk2` | `/dev/block/mmcblk0p6` / `p7` | Little Kernel bootloader (`fastboot`) | **High** |
| `boot` | `/dev/block/mmcblk0p8` | Linux `4.9.188` kernel + ramdisk | **High** |
| `recovery` | `/dev/block/mmcblk0p9` | Stock recovery image | **High** |
| `para` | `/dev/block/mmcblk0p10` | `/misc` bootloader control block | Standard |
| `logo` | `/dev/block/mmcblk0p11` | Boot splash screen | Standard |
| `dtbo` | `/dev/block/mmcblk0p12` | Device Tree Blob Overlay | **High** |
| `vbmeta` | `/dev/block/mmcblk0p13` | Root Android Verified Boot (`AVB 1.1`) descriptor | **High** |
| `vbmeta_system` | `/dev/block/mmcblk0p14` | System AVB descriptor (trusts `q-gsi`, `r-gsi`, `s-gsi` keys!) | **High** |
| `vbmeta_vendor` | `/dev/block/mmcblk0p15` | Vendor AVB descriptor | **High** |
| `frp` | `/dev/block/mmcblk0p17` | Factory Reset Protection (`/persistent`) | Standard |
| `tee1` / `tee2` | `/dev/block/mmcblk0p18` / `p19` | Beanpod / iTrusty TEE (`3.4`) | **High** |
| `nvdata` | `/dev/block/mmcblk0p20` | `/mnt/vendor/nvdata` (ext4 NVRAM runtime copy) | **Critical (Unique)** |
| `md_udc` | `/dev/block/mmcblk0p21` | `/metadata` (ext4 FBE & dynamic partition metadata) | Standard |
| `super` | `/dev/block/mmcblk0p26` | Dynamic partition container (`system` `dm-3`, `vendor` `dm-4`, `product` `dm-5`) | **High** |
| `cache` | `/dev/block/mmcblk0p27` | `/cache` (`104 MB` ext4) | Low |
| `userdata` | `/dev/block/mmcblk0p28` | `/data` (`12 GB` `f2fs`, `adiantum` FBE) | User Data |
