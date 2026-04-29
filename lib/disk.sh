blk_uuid() { # usage: blk_uuid <DEVICE>
  : "${1:?blk_uuid: missing DEVICE}"

  blkid --match-tag UUID --output value -- "$1" || return 1
}