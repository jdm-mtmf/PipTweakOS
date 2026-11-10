# Stage 2: Full BROM Backup & NVRAM Preservation

## 1. Objective & Why It Matters
MediaTek `MT6580` devices expose a hardware-level **BootROM (BROM)** and **Preloader** interface over USB while powered off. Before unlocking the bootloader (which wipes `userdata`) or flashing any partition, we extract a complete binary backup of the factory partitions—most importantly `nvram`, `nvdata`, `proinfo`, `protect1`, and `protect2` (which store the device's IMEI, MAC addresses, and RF antenna calibration).

## 2. Tools & Prerequisites
- **[mtkclient](https://github.com/bkerler/mtkclient)**: Open-source MediaTek BROM/Preloader dump and flash tool.
- `udev` rules configured on Linux for MediaTek USB IDs (`0e8d:0003` BROM, `0e8d:2000` Preloader).

## 3. Step-by-Step Commands

### Step 3.1: Power Off the Phone Completely
Disconnect the USB cable and power off the **Soyes XS18 Pro**. Wait 10 seconds for the PMIC to fully shut down.

### Step 3.2: Dump Critical Radio, Boot & System Partitions
Start `mtkclient` in read mode before plugging the phone in:
```bash
mkdir -p backups/stock_R80K3H1
mtk r nvram,nvdata,proinfo,protect1,protect2,seccfg,lk,boot,recovery,vbmeta,super \
  backups/stock_R80K3H1/nvram.bin,backups/stock_R80K3H1/nvdata.bin,backups/stock_R80K3H1/proinfo.bin,backups/stock_R80K3H1/protect1.bin,backups/stock_R80K3H1/protect2.bin,backups/stock_R80K3H1/seccfg.bin,backups/stock_R80K3H1/lk.bin,backups/stock_R80K3H1/boot.img,backups/stock_R80K3H1/recovery.img,backups/stock_R80K3H1/vbmeta.img,backups/stock_R80K3H1/super.img
```
While `mtkclient` waits for the device, hold **Volume Down** (or connect directly if Preloader auto-shakes) and plug in the USB-C cable.

### Step 3.3: Verify Backup Checksums
```bash
sha256sum backups/stock_R80K3H1/* > backups/stock_R80K3H1/SHA256SUMS
```

## 4. Under the Hood
- **`nvram` / `nvdata` / `protect1` / `protect2`**: Contains NVRAM calibration tables for the 2G/3G RF front-end and IMEI numbers. Never share these files publicly (`.gitignore` blocks them automatically).
- **`lk.bin` (Little Kernel)**: The bootloader binary responsible for `fastboot` and hardware initialization.
- **`boot.img`**: Contains the `Linux 4.9.188 (armv7l)` kernel zImage and the initial ramdisk (`init.rc`).
- **`super.img`**: Dynamic partition container holding logical partitions (`system`, `vendor`, `product`).

## 5. Troubleshooting & Rollback
- If the phone boots into the charging animation instead of connecting to `mtkclient`, unplug USB, power off again, and hold **Volume Down** (or **Volume Up**) while inserting the USB cable.
- With `backups/stock_R80K3H1/` safely stored on your PC, the device is now **unbrickable**: even if `system` or `boot` fails to boot, `mtk w` can restore the exact factory state in minutes.
