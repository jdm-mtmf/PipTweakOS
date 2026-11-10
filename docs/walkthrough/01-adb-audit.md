# Stage 1: Host Setup & Read-Only ADB Audit

## 1. Objective & Why It Matters
Before unlocking the bootloader or altering any partition on the **Soyes XS18 Pro (`Tigers TIS001_S4`)**, we perform a non-destructive, read-only audit over **Android Debug Bridge (ADB)**. This captures the exact partition table, mount flags, pre-installed APK paths (including hidden rootkits/adware), and kernel logs from the live stock build (`R80K3H1_SYE_C08_XS18Pro_Q_WELCOME_M52_20251126_1836`).

## 2. Tools & Prerequisites
- **Host OS**: Linux (native or WSL2 on Windows) with `adb` and `fastboot` installed (`/usr/local/bin/adb`).
- **WSL2 USB Passthrough (Windows Hosts Only)**:
  Because WSL2 does not expose physical Windows USB ports to Linux by default, open **PowerShell as Administrator** on Windows and run:
  ```powershell
  # Install usbipd-win if not already installed:
  winget install --interactive --exact dorssel.usbipd-win

  # Refresh PATH in the current PowerShell session (or open a new Admin PowerShell window):
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

  # List connected USB devices and find the BUSID for the XS18 Pro / MediaTek device:
  usbipd list

  # Bind and attach the device to WSL2 (replace <BUSID> e.g. 1-1):
  # Note: If UsbDk is installed on Windows, use --force and unplug/replug the USB cable once before attaching:
  usbipd bind --force --busid <BUSID>
  usbipd attach --wsl --busid <BUSID> --auto-attach
  ```
  *(Note: `--auto-attach` ensures that when the phone reboots into Fastboot or MediaTek BROM mode, Windows automatically re-attaches it to WSL2!)*
- **Linux `udev` Permissions for MediaTek (`0e8d`)**:
  So non-root commands (`adb`, `fastboot`, `mtkclient`) can access `/dev/bus/usb` without `no permissions` errors, add the MediaTek vendor rule on Linux/WSL2:
  ```bash
  echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="0e8d", MODE="0666", GROUP="plugdev"' | sudo tee /etc/udev/rules.d/51-android-mediatek.rules
  sudo udevadm control --reload-rules && sudo udevadm trigger
  sudo chmod -R a+rw /dev/bus/usb/
  adb kill-server && adb start-server
  ```
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
Run the automated Stage 1 read-only audit script:
```bash
./scripts/01-adb-audit.sh
```

### Step 3.3: Immediate Backdoor & Spoofer Neutralization (Pre-Flash Safety)
Before moving to Stage 2, immediately kill and strip the active **Redstone/Adups OTA backdoor (`com.abfota.systemUpdate`)**, the **ODM Spec Spoofer (`com.tyd.configdisplay`)**, and unremoved `uid:1000` factory test packages for the current user (`--user 0`):
```bash
./scripts/01b-adb-neutralize-backdoors.sh
```
This stops `com.abfota.systemUpdate` (`PID 1572`, 70 MB RAM) and `com.aiworks.faceidservice` (61 MB RAM), freeing over **130 MB of RAM** immediately without risking a bootloop.

## 4. Under the Hood
- `/dev/block/by-name/` maps human-readable partition names (`boot`, `vbmeta`, `super`, `nvram`, `nvdata`, `recovery`) to raw `/dev/block/mmcblk0p*` eMMC block devices.
- `pm list packages -f -U` maps every installed package to its exact APK file in `/system/priv-app`, `/system/app`, `/vendor/app`, or `/product/app`, revealing where the `WELCOME_M52` adware/rootkit packages reside.

## 5. Troubleshooting & Rollback
- **No device listed in `adb devices`**: Toggle USB mode in the notification shade from *Charging Only* to *File Transfer (MTP)*, or check `lsusb` on Linux for a MediaTek vendor ID (`0e8d`).
- **Risk Level**: Zero. All commands in Stage 1 are strictly read-only.
