#!/usr/bin/env bash
# RecoveryOS Stage 1b: Immediate ADB Backdoor & Bloatware Neutralization
# Target: Soyes XS18 Pro (Tigers TIS001_S4)
# Safely disables and strips active user-0 installations of pre-installed
# rootkits/backdoors, spec spoofers, and factory test packages without bricks.

set -uo pipefail

echo "[*] Waiting for ADB device..."
adb wait-for-device

TARGETS=(
  "com.abfota.systemUpdate"      # Redstone / Adups FOTA backdoor (uid:1000, /system/app/Rsota/Rsota.apk)
  "com.tyd.configdisplay"        # Tydtech ODM hardware spec spoofer (uid:1000, /system/app/ConfigDisplay/ConfigDisplay.apk)
  "com.example.switchbootanim"   # Clone boot animation switcher (uid:1000, /system/app/SwitchBootAnim/SwitchBootAnim.apk)
  "com.AgeTest"                  # Factory aging/burn-in test tool (uid:1000, /system/app/AgeTest1/AgeTest1.apk)
  "com.mediatek.factorymode"     # Freeme OS factory test mode (uid:1000, /system/app/FreemeFactoryMode/FreemeFactoryMode.apk)
  "com.dede.android_eggs"        # Bundled 3rd-party Easter Egg spoofer (/system/app/AndroidEggs/AndroidEggs.apk)
  "com.mediatek.duraspeed"       # MediaTek DuraSpeed task killer (/product/priv-app/DuraSpeed/DuraSpeed.apk)
  "com.aiworks.faceidservice"    # AIWorks FaceID daemon eating 61MB RAM continuously (/system/priv-app/FaceIdService/FaceIdService.apk)
)

for pkg in "${TARGETS[@]}"; do
  echo "------------------------------------------------------------"
  echo "[*] Neutralizing package: $pkg"
  adb shell am force-stop "$pkg" 2>&1 || true
  adb shell pm clear "$pkg" 2>&1 || true
  adb shell pm disable-user --user 0 "$pkg" 2>&1 || true
  adb shell pm uninstall -k --user 0 "$pkg" 2>&1 || true
done

echo "------------------------------------------------------------"
echo "[*] Verifying com.abfota.systemUpdate and com.aiworks.faceidservice are dead..."
adb shell "ps -A | grep -E 'abfota|configdisplay|faceid|AgeTest' || echo '[+] Clean: No target backdoor processes running!'"
echo "[+] Neutralization complete."
