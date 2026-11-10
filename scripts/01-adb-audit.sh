#!/usr/bin/env bash
# RecoveryOS Stage 1: Non-Destructive Read-Only ADB Audit Script
# Target: Soyes XS18 Pro (Tigers TIS001_S4)

set -uo pipefail

OUT_DIR="audit_output/latest"
mkdir -p "$OUT_DIR"

echo "[*] Checking ADB connection..."
adb wait-for-device
adb devices -l > "$OUT_DIR/adb_devices.txt" 2>&1 || true

echo "[*] Dumping system properties (getprop)..."
adb shell getprop > "$OUT_DIR/getprop.txt" 2>&1 || true

echo "[*] Dumping installed packages with APK paths and UIDs..."
adb shell pm list packages -f -U > "$OUT_DIR/packages_full.txt" 2>&1 || true
adb shell pm list packages -s -f > "$OUT_DIR/packages_system.txt" 2>&1 || true
adb shell pm list packages -3 -f > "$OUT_DIR/packages_thirdparty.txt" 2>&1 || true
adb shell pm list packages -d -f > "$OUT_DIR/packages_disabled.txt" 2>&1 || true

echo "[*] Dumping CPU, memory, ZRAM swap, and storage partitions..."
adb shell cat /proc/cpuinfo > "$OUT_DIR/cpuinfo.txt" 2>&1 || true
adb shell cat /proc/meminfo > "$OUT_DIR/meminfo.txt" 2>&1 || true
adb shell free -m > "$OUT_DIR/free.txt" 2>&1 || true
adb shell dumpsys meminfo > "$OUT_DIR/dumpsys_meminfo.txt" 2>&1 || true
adb shell cat /proc/partitions > "$OUT_DIR/partitions.txt" 2>&1 || true
adb shell df -h > "$OUT_DIR/df.txt" 2>&1 || true
adb shell mount > "$OUT_DIR/mounts.txt" 2>&1 || true
adb shell ls -la /dev/block/by-name/ /dev/block/platform/*/by-name/ /dev/block/mapper/ > "$OUT_DIR/by-name.txt" 2>&1 || true

echo "[*] Dumping fstab, init scripts, and app directories..."
adb shell "cat /vendor/etc/fstab* /system/etc/fstab* 2>/dev/null" > "$OUT_DIR/fstab.txt" 2>&1 || true
adb shell "ls -la /system/priv-app /system/app /vendor/app /vendor/priv-app /product/app /product/priv-app /product/overlay /vendor/overlay 2>/dev/null" > "$OUT_DIR/app_dirs.txt" 2>&1 || true
adb shell "ls -la /system/etc/init /vendor/etc/init /init*.rc 2>/dev/null" > "$OUT_DIR/init_dirs.txt" 2>&1 || true
adb shell "cat /vendor/etc/init/*.rc /init*.rc 2>/dev/null" > "$OUT_DIR/init_rc_contents.txt" 2>&1 || true

echo "[*] Checking for hidden su binaries or rootkit daemons..."
adb shell "which su; ls -la /system/bin/su /system/xbin/su /sbin/su /vendor/bin/su /product/bin/su 2>/dev/null" > "$OUT_DIR/su_check.txt" 2>&1 || true
adb shell uname -a > "$OUT_DIR/uname.txt" 2>&1 || true
adb shell getenforce > "$OUT_DIR/selinux.txt" 2>&1 || true
adb shell id > "$OUT_DIR/id.txt" 2>&1 || true

echo "[*] Dumping battery, display, radio, and running processes..."
adb shell dumpsys battery > "$OUT_DIR/dumpsys_battery.txt" 2>&1 || true
adb shell wm size > "$OUT_DIR/display_size.txt" 2>&1 || true
adb shell wm density > "$OUT_DIR/display_density.txt" 2>&1 || true
adb shell ps -A -o USER,PID,PPID,VSZ,RSS,WCHAN,ADDR,S,NAME > "$OUT_DIR/processes.txt" 2>&1 || true
adb shell netstat -tulnp > "$OUT_DIR/netstat.txt" 2>&1 || true

echo "[+] Audit complete! Saved to $OUT_DIR"
