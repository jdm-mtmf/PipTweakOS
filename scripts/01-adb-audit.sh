#!/usr/bin/env bash
# RecoveryOS Stage 1: Non-Destructive Read-Only ADB Audit Script
# Target: Soyes XS18 Pro (Tigers TIS001_S4)

set -euo pipefail

OUT_DIR="audit_output/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$OUT_DIR"

echo "[*] Checking ADB connection..."
adb wait-for-device
adb devices -l > "$OUT_DIR/adb_devices.txt"

echo "[*] Dumping system properties (getprop)..."
adb shell getprop > "$OUT_DIR/getprop.txt"

echo "[*] Dumping installed packages with APK paths and UIDs..."
adb shell pm list packages -f -U > "$OUT_DIR/packages_full.txt"
adb shell pm list packages -s -f > "$OUT_DIR/packages_system.txt"
adb shell pm list packages -3 -f > "$OUT_DIR/packages_thirdparty.txt"

echo "[*] Dumping CPU, memory, ZRAM swap, and storage partitions..."
adb shell cat /proc/cpuinfo > "$OUT_DIR/cpuinfo.txt"
adb shell cat /proc/meminfo > "$OUT_DIR/meminfo.txt"
adb shell cat /proc/swaps > "$OUT_DIR/swaps.txt"
adb shell cat /proc/partitions > "$OUT_DIR/partitions.txt"
adb shell df -h > "$OUT_DIR/df.txt"
adb shell mount > "$OUT_DIR/mounts.txt"
adb shell ls -la /dev/block/by-name/ > "$OUT_DIR/by-name.txt" 2>&1 || true

echo "[*] Dumping kernel version, cmdline, and SELinux status..."
adb shell uname -a > "$OUT_DIR/uname.txt"
adb shell cat /proc/cmdline > "$OUT_DIR/cmdline.txt" 2>&1 || true
adb shell getenforce > "$OUT_DIR/selinux.txt" 2>&1 || true

echo "[*] Dumping battery, display, and running processes..."
adb shell dumpsys battery > "$OUT_DIR/dumpsys_battery.txt"
adb shell wm size > "$OUT_DIR/display_size.txt"
adb shell wm density > "$OUT_DIR/display_density.txt"
adb shell ps -A > "$OUT_DIR/processes.txt"

echo "[+] Audit complete! Saved to $OUT_DIR"
