# Stage 5: Custom ROM / Treble GSI Flashing (`fastbootd`)

## 1. Objective & Why It Matters
Because the **Soyes XS18 Pro (`TIS001_S4`)** supports **Project Treble (`VNDK 29.0`)**, **System-as-Root**, and **Dynamic Partitions (`super`)**, its hardware-specific MediaTek drivers are isolated in the `vendor` partition. This allows us to completely replace the malware-infected stock `system` partition with a clean, open-source **32-bit ARM (`arm` / `armeabi-v7a`) Generic System Image (GSI)** or our custom-built **RecoveryOS** system image.

## 2. Target Image Architecture Requirements
Based on our verified hardware profile ([01-device-profile.md](../01-device-profile.md)):
- **CPU Architecture**: `arm` / `armeabi-v7a` (pure 32-bit kernel `armv7l` + 32-bit binder).
- **Partition Layout**: `ab` / System-as-Root (required for Dynamic Partition `super` devices even when Seamless Updates are A-only).
- **VNDK Compatibility**: `VNDK 29.0` (Android 10 Q / Android 11 R Go-edition lightweight targets).
- **GApps Variant**: `vanilla` (FOSS-only, lowest RAM footprint—recommended for 2 GB RAM / 900 mAh battery) or `go` (Android Go micro-GApps).

## 3. Step-by-Step Commands

### Step 3.1: Enter Userspace Fastboot (`fastbootd`)
Dynamic partitions (`system`, `vendor`, `product` inside `super`) cannot be resized or flashed from the legacy bootloader `fastboot`. You must boot into userspace `fastbootd`:
```bash
adb reboot fastboot
# Or from bootloader fastboot:
fastboot reboot fastboot
```

### Step 3.2: Free Space in `super` and Flash the Clean System Image
```bash
# Optional: delete logical product partition if extra space is needed inside super
fastboot delete-logical-partition product

# Erase and flash the new clean system image
fastboot erase system
fastboot flash system recoveryos-arm32-ab-vanilla.img

# Perform a clean userdata format before first boot
fastboot -w
fastboot reboot
```

## 4. Under the Hood
- **`super` Dynamic Partition**: Instead of fixed eMMC partition boundaries, `super` uses the Linux Device Mapper (`dm-linear`) managed by `fastbootd` to dynamically allocate extents for `system`, `vendor`, and `product`.

## 5. Troubleshooting & Rollback
- If the device bootloops on a specific GSI build, hold Power to shut down and restore `backups/stock_R80K3H1/super.img` via `mtkclient` (`mtk w super backups/stock_R80K3H1/super.img`).
