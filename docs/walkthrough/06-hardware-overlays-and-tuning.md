# Stage 6: Hardware Overlays, Battery Calibration & Radio Tuning

## 1. Objective & Why It Matters
After booting a clean system image, we apply device-specific hardware fixes for the **Soyes XS18 Pro (`TIS001_S4`)**:
1. **Battery Capacity Fix (`3500 mAh -> 900 mAh`)**: Stock firmware hardcodes `3500 mAh` as the design capacity while the physical Li-Po cell is `900 mAh` (causing Android to report `25.7%` battery health and miscalculate discharge curves).
2. **Display Density Calibration (`640 x 480` on 3.0" Panel)**: Stock hardcodes `160 ppi` (`mdpi`), tricking Android into thinking the screen is `5.00 inches` ($\frac{800\text{ px}}{160\text{ ppi}} = 5.0"$).
3. **Radio / Baseband & Background Power Saving**: Restrict background wakeups and tune 2G/3G cellular sleep states to maximize battery life on the `900 mAh` cell and weak internal antennas.

## 2. PipTweakOS Hardware Fixes

### 2.1: Runtime Resource Overlay (RRO) for `power_profile.xml`
We compile a lightweight overlay APK (`PipTweakOS-XS18Pro-Overlay.apk`) placed in `/product/overlay/` (or `/system/product/overlay/`) with:
```xml
<?xml version="1.0" encoding="utf-8"?>
<device name="Android">
    <!-- True physical cell capacity measured by fuel gauge -->
    <item name="battery.capacity">900</item>
</device>
```

### 2.2: Display Density & UI Scaling (`480x640`)
Adjust display density via `wm density` or `build.prop` (`ro.sf.lcd_density`) so UI elements fit the 3.0-inch `480x640` screen cleanly without clipping:
```bash
# Test live via ADB without rebooting:
adb shell wm density 180
# Reset to default 160 if desired:
adb shell wm density reset
```

### 2.3: Baseband & Antenna Power Optimization
- Disable 4G/LTE phantom scanning if the board is a 3G-only `MT6580` variant (`Preferred network type: 3G/2G auto`), preventing the modem from burning battery hunting for unsupported bands.
- Enable aggressive Doze and Wi-Fi scan throttling.
