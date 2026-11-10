# Stage 4: Kernel Ramdisk (`boot.img`) & `vendor` Sanitization

## 1. Objective & Why It Matters
Even if you replace the `system` partition with a clean custom ROM, persistent rootkits or misconfigurations residing in `boot.img` (the initial ramdisk) or the `vendor` logical partition will survive. Specifically, on the **Soyes XS18 Pro (`TIS001_S4`)**, we must:
1. Inspect `boot.img` (`Linux 4.9.188`) and `/vendor/etc/init/` for rogue `WELCOME_M52` services.
2. Fix `/vendor/etc/fstab.mt6580` to lower `zram0` swap from the crippling **`1.72 GB`** (90% of RAM) down to **`512 MB`**, stopping the constant Cortex-A7 CPU swap thrashing.

## 2. Tools & Prerequisites
- `magiskboot` or `unpack_bootimg` / `mkbootimg` (AOSP boot image tools).
- `lpunpack` and `lpmake` (for unpacking/repacking the `super.img` dynamic partition if editing offline, or root shell / `fastbootd` remount).
- Optional: **Magisk** app (if patching `boot.img` for user-controlled root access with superuser prompts).

## 3. Step-by-Step Workflow (To Be Populated During Live Audit)

### Step 3.1: Unpack and Inspect `boot.img`
```bash
mkdir -p work/boot
cd work/boot
unpack_bootimg --boot_img ../../backups/stock_R80K3H1/boot.img --out .
```
Inspect extracted kernel command line (`cmdline`) and ramdisk `.rc` files for:
- `androidboot.selinux=permissive`
- Injected daemon definitions or custom `.sh` scripts executed as `root`.

### Step 3.2: Audit `/vendor` & Fix `fstab.mt6580` ZRAM Allocation
Locate the `zram0` entry in `/vendor/etc/fstab.mt6580` (or `init.mt6580.rc`):
- **Stock (Broken)**: Allocates ~`1.72 GB` (`zramsize=90%` or `1845493760` bytes) on a `1.92 GB` RAM device.
- **RecoveryOS Patch**: Set `zramsize=536870912` (`512 MB`) and configure `/proc/sys/vm/swappiness` to `40`.

## 4. Under the Hood
- **Why 1.72 GB ZRAM destroys battery life**: Every swapped memory page is compressed and decompressed in software by the 32-bit `MT6580` CPU (`ARM Cortex-A7`). When stock bloatware fills RAM, the CPU gets trapped in a swap storm, draining the `900 mAh` battery in under an hour.

## 5. Troubleshooting & Rollback
- If a modified `boot.img` fails to boot, run `mtk w boot backups/stock_R80K3H1/boot.img` to immediately restore the working kernel image.
