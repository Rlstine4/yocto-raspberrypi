#!/bin/bash
set -e

BOOT_DEV="/dev/mmcblk0p1"
MOUNT_POINT="/mnt/BOOT"
YOCTO_DEPLOY_DIR="/workspace/yocto-raspberrypi/poky/build/tmp/deploy/images/raspberrypi4-64"

# Create mount point if it doesn't exist
sudo mkdir -p $MOUNT_POINT

# Mount the BOOT partition
echo "Mounting $BOOT_DEV to $MOUNT_POINT..."
sudo mount $BOOT_DEV $MOUNT_POINT

# Backup old kernel just in case
#if [ -f "$MOUNT_POINT/kernel8.img" ]; then
#    echo "Backing up old kernel..."
#    sudo cp $MOUNT_POINT/kernel8.img $MOUNT_POINT/kernel8.img.bak
#fi

# Copy the kernel
echo "Copying Yocto kernel..."
sudo cp $YOCTO_DEPLOY_DIR/Image $MOUNT_POINT/kernel8.img

# Copy Device Tree blobs
echo "Copying DTBs..."
sudo cp $YOCTO_DEPLOY_DIR/*.dtb $MOUNT_POINT/

# Copy overlays
echo "Copying overlays..."
sudo cp -r $YOCTO_DEPLOY_DIR/overlays/* $MOUNT_POINT/overlays/

# Sync to ensure everything is written
sync

# Unmount the BOOT partition
echo "Unmounting..."
sudo umount $MOUNT_POINT

echo "Kernel, DTBs, and overlays updated."

