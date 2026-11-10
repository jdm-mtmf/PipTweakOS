# Stage 3: Bootloader Unlock & `vbmeta` Verification Disabling

## 1. Objective & Why It Matters
To boot a sanitized `boot.img`, modified `vendor` partition, or custom Project Treble Generic System Image (GSI), we must unlock the bootloader (`lk` / `seccfg`) and disable Android Verified Boot 2.0 (`AVB` / `dm-verity`) in the `vbmeta` partition.

> [!WARNING]
> Unlocking the bootloader triggers a mandatory factory reset (`userdata` wipe). Ensure your Stage 2 backup is complete before proceeding.

## 2. Tools & Prerequisites
- Completed **Stage 1** (`OEM Unlocking` enabled in Developer Options) and **Stage 2** (full partition backup).
- `adb`, `fastboot`, and `mtkclient`.

## 3. Step-by-Step Commands

### Option A: Unlock via `mtkclient` (Direct `seccfg` Unlock)
With the phone powered off:
```bash
mtk e metadata,userdata
mtk da seccfg unlock
```

### Option B: Unlock via Standard `fastboot`
If unlocking via bootloader fastboot mode:
```bash
adb reboot bootloader
fastboot devices
fastboot flashing unlock
# Or on older MT6580 Little Kernel builds:
fastboot oem unlock
```
Press **Volume Up** on the phone screen to confirm bootloader unlock.

### Step 3.3: Disable AVB / `dm-verity` using Stock `vbmeta.img`
Using the `vbmeta.img` backed up in Stage 2:
```bash
fastboot --disable-verity --disable-verification flash vbmeta backups/stock_R80K3H1/vbmeta.img
```

## 4. Under the Hood
- **`seccfg`**: MediaTek's security configuration partition storing the lock state flag (`LK_UNLOCK`).
- **`vbmeta`**: Holds cryptographic hash descriptors for `boot`, `system`, and `vendor`. Passing `--disable-verity --disable-verification` sets flag `0x03` in the `vbmeta` header so the kernel and bootloader accept modified partitions without signature errors.

## 5. Troubleshooting & Rollback
- To re-lock or restore stock verification at any time, flash the unmodified `backups/stock_R80K3H1/vbmeta.img` and `seccfg.bin` via `mtkclient`.
