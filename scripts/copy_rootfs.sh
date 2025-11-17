#!/bin/bash

set -euo pipefail

ROOTFS_TARBALL="$1"

if [[ ! -f "$ROOTFS_TARBALL" ]]; then
    echo "Error: Rootfs tarball not found: $ROOTFS_TARBALL"
    exit 1
fi

# Define partitions
ROOTA_PART="/dev/mmcblk0p2"
ROOTB_PART="/dev/mmcblk0p3"

# Mount points
MOUNT_ROOTA="/media/ROOTA"
MOUNT_ROOTB="/media/ROOTB"

# Create mount points if needed
sudo mkdir -p "$MOUNT_ROOTA" "$MOUNT_ROOTB"

echo "Unmounting partitions if already mounted..."
sudo umount "$MOUNT_ROOTA" || true
sudo umount "$MOUNT_ROOTB" || true

echo "Mounting ROOTA ($ROOTA_PART)..."
sudo mount "$ROOTA_PART" "$MOUNT_ROOTA"

echo "Mounting ROOTB ($ROOTB_PART)..."
sudo mount "$ROOTB_PART" "$MOUNT_ROOTB"

echo "Erasing old rootfs..."
sudo rm -rf "$MOUNT_ROOTA"/* "$MOUNT_ROOTB"/*

echo "Extracting rootfs to ROOTA..."
sudo tar -xpf "$ROOTFS_TARBALL" -C "$MOUNT_ROOTA"

echo "Extracting rootfs to ROOTB..."
sudo tar -xpf "$ROOTFS_TARBALL" -C "$MOUNT_ROOTB"

echo "Syncing and unmounting partitions..."
sync
sudo umount "$MOUNT_ROOTA" "$MOUNT_ROOTB"

echo "Completed.."

