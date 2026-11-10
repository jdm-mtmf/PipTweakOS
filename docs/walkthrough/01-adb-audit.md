# Stage 1: Host Setup & Read-Only ADB Audit

## 1. Objective & Why It Matters
Before unlocking the bootloader or altering any partition on the **Soyes XS18 Pro (`Tigers TIS001_S4`)**, we perform a non-destructive, read-only audit over **Android Debug Bridge (ADB)**. This captures the exact partition table, mount flags, pre-installed APK paths (including hidden rootkits/adware), and kernel logs from the live stock build (`R80K3H1_SYE_C08_XS18Pro_Q_WELCOME_M52_20251126_1836`).

## 2. Tools & Prerequisites
- **Host OS**: Linux (recommended) with `adb` and `fastboot` installed (`android-tools` / `android-sdk-platform-tools`).
- **USB Cable**: Data-capable USB Type-C cable.
- **On the Phone**:
  1. Open **Settings → About Phone** and tap **Build Number** 7 times until *"You are now a developer!"* appears.
  2. Navigate to **Settings → System → Developer Options**.
  3. Enable **OEM Unlocking** (allows bootloader unlock in Stage 3).
  4. Enable **USB Debugging**.

## 3. Step-by-Step Commands

### Step 3.1: Verify USB Enumeration & ADB Authorization
Plug the powered-on phone into your computer and run:
```bash
adb devices -l
```
**Expected Output**:
- A prompt on the phone screen asking to *"Allow USB debugging?"* — check **Always allow from this computer** and tap **Allow**.
- Terminal output showing your device in the `device` state.

### Step 3.2: Capture System Properties, Packages & Partition Layout
Run the following read-only inspection commands (or run `scripts/01-adb-audit.sh` once connected):
```bash
mkdir -p audit_output
adb shell getprop > audit_output/getprop.txt
adb shell pm list packages -f -U > audit_output/packages_full.txt
adb shell cat /proc/partitions > audit_output/partitions.txt
adb shell cat /proc/meminfo > audit_output/meminfo.txt
adb shell cat /proc/swaps > audit_output/swaps.txt
adb shell mount > audit_output/mounts.txt
adb shell ls -la /dev/block/by-name/ > audit_output/by-name.txt
```

## 4. Under the Hood
- `/dev/block/by-name/` maps human-readable partition names (`boot`, `vbmeta`, `super`, `nvram`, `nvdata`, `recovery`) to raw `/dev/block/mmcblk0p*` eMMC block devices.
- `pm list packages -f -U` maps every installed package to its exact APK file in `/system/priv-app`, `/system/app`, `/vendor/app`, or `/product/app`, revealing where the `WELCOME_M52` adware/rootkit packages reside.

## 5. Troubleshooting & Rollback
- **No device listed in `adb devices`**: Toggle USB mode in the notification shade from *Charging Only* to *File Transfer (MTP)*, or check `lsusb` on Linux for a MediaTek vendor ID (`0e8d`).
- **Risk Level**: Zero. All commands in Stage 1 are strictly read-only.
