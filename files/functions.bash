#!/bin/bash
log() {
    echo "[$1] $2"
}

if_verbose() {
    if [ "$verbose" = "True" ]; then
        "$@"
    fi
}

normalize_blk() {
    if [[ $1 == /dev/* ]]; then
        block_device="$1"
    else
        block_device="/dev/$1"
    fi
}

selectpart() {
    while [ -z $continue ]; do
        read -p "$_selectpart $1$2: " "$1"
        normalize_blk "${!1}"
        if blkid | grep -q "$block_device" && [[ $block_device != /dev/ ]]; then
            if_verbose log Info "Valid block device selected"
            local continue=1
        else
            log Error "invalid block device selected, please try again."
        fi
    done
}

# https://unix.stackexchange.com/a/631320
# Measures CPU architecture level based on supported extensions
exts=$(grep '^flags\b' </proc/cpuinfo | head -n 1)
exts=" ${flags#*:} "

has_extensions() {
  for ext; do
    case "$exts" in
      *" $ext "*) :;;
      *)
        return 1;;
    esac
  done
}

determine_level() {
  level=0
  has_extensions lm cmov cx8 fpu fxsr mmx syscall sse2 || return 0
  level=1
  has_extensions cx16 lahf_lm popcnt sse4_1 sse4_2 ssse3 || return 0
  level=2
  has_extensions avx avx2 bmi1 bmi2 f16c fma abm movbe xsave || return 0
  level=3
  has_extensions avx512f avx512bw avx512cd avx512dq avx512vl || return 0
  level=4
}

