# Soyes XS18 Pro (`Tigers TIS001_S4`) Device Configuration

This directory stores device-specific overlays, partition configurations, and system properties for the **Soyes XS18 Pro** (`R80K3H1_SYE_C08_XS18Pro_Q_WELCOME_M52`).

## Planned Files
- `overlay/frameworks/base/core/res/res/xml/power_profile.xml` — Corrects reported battery design capacity from the spoofed `3500 mAh` to the true `900 mAh` cell.
- `rootdir/vendor/etc/fstab.mt6580` — Reduces `zram0` swap allocation from `1.72 GB` down to `512 MB`.
- `system.prop` — Display density, Dalvik heap sizing for `2 GB` RAM, and radio power-saving properties.
