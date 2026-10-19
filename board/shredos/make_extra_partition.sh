#!/bin/bash -e

# This file produces the extra FAT16 partition for the shredos_iso_extra_*_defconfig configurations.
# The partition is appended to the ISO, so that when written to USB a writeable partition is available.
#
# At runtime find_shredos_boot_disc.sh identifies this partition as the PDF report/log
# archive destination by the matching /boot/version.txt; the etc/shredos/shredos_exclude_disc
# marker additionally excludes the whole boot USB drive from nwipe's drive enumeration.

rm "${BINARIES_DIR}"/extra.vfat || true

dd if=/dev/zero of="${BINARIES_DIR}/extra.vfat" bs=1M count=200 || exit 1
"$HOST_DIR"/sbin/mkfs.vfat -F16 -n REPORTS "${BINARIES_DIR}/extra.vfat" || exit 1

"$HOST_DIR"/bin/mmd -i "${BINARIES_DIR}/extra.vfat" ::/boot ::/etc ::/etc/shredos || exit 1

"$HOST_DIR"/bin/mcopy -p -m -i "${BINARIES_DIR}/extra.vfat" board/shredos/fsoverlay/etc/shredos/version.txt ::/boot/version.txt || exit 1
"$HOST_DIR"/bin/mcopy -p -m -i "${BINARIES_DIR}/extra.vfat" board/shredos/shredos_exclude_disc ::/etc/shredos/shredos_exclude_disc || exit 1
"$HOST_DIR"/bin/mcopy -p -m -i "${BINARIES_DIR}/extra.vfat" board/shredos/README.txt ::/README.txt || exit 1
"$HOST_DIR"/bin/mcopy -p -m -i "${BINARIES_DIR}/extra.vfat" board/shredos/autorun.inf ::/autorun.inf || exit 1
"$HOST_DIR"/bin/mcopy -p -m -i "${BINARIES_DIR}/extra.vfat" board/shredos/shredos.ico ::/shredos.ico || exit 1

exit 0
