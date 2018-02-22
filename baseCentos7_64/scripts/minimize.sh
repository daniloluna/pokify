#!/bin/sh

# Zero the empty space to minimize image size
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# Remove bash history
cat /dev/null > ~/.bash_history && history -c && exit

# Add `sync` so Packer doesn't quit too early, before the large file is deleted.
sync
