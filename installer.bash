#!/usr/bin/env /bin/bash
. files/english.bash
. files/functions.bash

set -e
while getopts ":hv" arg; do
    case $arg in
        v)
            verbose="True"
            log Info "Verbosity enabled"
            ;;
        h)
            echo "$_usage"
            exit 0
            ;;
    esac
done

is_arch() {
    source /etc/lsb-release
    if [ DISTRIB_DESCRIPTION="Arch Linux" ]; then
        if_verbose log Info "Arch detected"
        bash files/main.bash
    else
        log Error "Please use this script on Arch, not a derivative or another distro."
        exit 1
    fi
}
is_arch
