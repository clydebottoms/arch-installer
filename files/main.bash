#!/bin/bash
# This script tries to put as much gibberish as possible in other files to allow easy editing (and also so it's easier to read)
. files/english.bash
. files/functions.bash

# Partitioning
read -n 1 -srp "$_intro"

clear
lsblk
selectpart ESP
selectpart root

mkfs.fat
cryptsetup -y -v luksFormat 

# Check maximum cpu arch level
determine_level
