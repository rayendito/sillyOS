#!/bin/bash
file="images/silly-os"
target_size=$((8 * 1024))  # 8KB in bytes
current_size=$(stat -f%z "$file")
echo "Size of $file: $current_size bytes"

# Calculate how many bytes are needed to reach 8KB
if [ "$current_size" -lt "$target_size" ]; then
    padding_size=$((target_size - current_size))
    # Use dd to append 0 bytes to the file
    dd if=/dev/zero bs=1 count="$padding_size" >> "$file"
    echo "Padded $file to 8KB"
else
    echo "$file is already 8KB or larger"
fi