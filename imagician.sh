#!/usr/bin/env bash
# imagician.sh - Downloads and SHA256SUM/SHA512SUM verififes Linux ISOs

# Check if Images Directory exists

if [ -e ~/Images]
then
    echo "Images directory already exists."
else
    mkdir -p ~/Images
    echo "Images directory not found!"
    echo "Creating Images directory in homedir."
fi

# VARIABLES #

## ALP VARS ##
alpimage=alpine-standard-3.24.2
alpurl="https://dl-cdn.alpinelinux.org/alpine/v3.24/releases/x86_64"

## ARC VARS ##
arcimage=archlinux-2026.10.01
arcurl="https://mirror.rackspace.com/archlinux/iso/2026.10.01"

## DEB VARS ##
debimage=debian-13.7.0
deburl="https://cdimage.debian.org/debian-cd/13.7.0/amd64/iso-cd"

## NIX VARS ##
niximage=nixos-26.05
nixurl="https://channels.nixos.org/$niximage"

## SUS VARS ##
susimage=Leap-16.0
susurl="htttps://download.opensuse.org/distribution/leap/16.0/offline"

## UBU VARS ##
ubuimage=ubuntu-26.04-desktop-amd64
ubuurl="https://releases.ubuntu.com/resolute"

# FUNCTIONS#

dl-ver-alp() {
    echo "Creating folder for $alpimage..."
    mkdir -p ~/Images/$alpimage
    echo "Downloading $alpimage..."
        wget --no-verbose --show-progress -P ~/Images/$alpimage $alpurl/$alpimage-x86_64.iso
    echo "Downloading $alpimage checksums..."
        wget --no-verbose --show-progress -P ~/Images/$alpimage $alpurl/$alpimage-x86_64.iso.sha256

    echo "Verifying $alpimage..."
    cd ~/Images/$alpimage
    head -n 1 $alpimage-x86_64.iso.sha256 | sha256sum --check
    }

dl-ver-arc() {
    echo "Creating folder for $arcimage..."
    mkdir -p ~/Images/$arcimage
    echo "Downloading $arcimage..."
        wget --no-verbose --show-progress -P ~/Images/$arcimage $arcurl/$arcimage-x86_64.iso
    echo "Downloading $arcimage checksums..."
        wget --no-verbose --show-progress -P ~/Images/$arcimage $arcurl/sha256sums.txt

    echo "Verifying $arcimage..."
    cd ~/Images/$arcimage
    head -n 1 sha256sums.txt | sha256sum --check
}

dl-ver-deb() {
    echo "Creating folder for $debimage"
    mkdir -p ~/Images/$debimage
    echo "Downloading $debimage..."
        wget --no-verbose --show-progress -P ~/Images/$debimage $deburl/$debimage-amd64-netinst.iso
    echo "Downloading $debimage checksums..."
        wget --no-verbose --show-progress -P ~/Images/$debimage $deburl/SHA256SUMS

    echo "Verifying $debimage..."
    cd ~/Images/$debimage
    head -n 1 SHA256SUMS | sha256sum --check
    }

dl-ver-nix(){
    echo "Creating folder for $niximage"
    mkdir -p ~/Images/$niximage
    echo "Downloading $niximage..."
        wget --no-verbose --show-progress -P ~/Images/$niximage $nixurl/latest-nixos-graphical-x86_64-linux.iso
        # Extra step to rename the nixos image so that the checksum can validate
        mv ~/Images/$niximage/latest-nixos-graphical-x86_64-linux.iso ~/Images/$niximage/nixos-graphical-26.05.11680.6fcc160353f6-x86_64-linux.iso
        # Note to future self: Make the above name change a variable, you moron

        echo "Verifying $niximage..."
        cd ~/Images/$niximage
        head -n 1 latest-nixos-graphical-x86_64-linux.iso.sha256 | sha256sum --check
}

dl-ver-sus() {
    echo "Creating folder for $susimage"
    mkdir -p ~/Images/$susimage
    echo "Downloading $susimage..."
        wget --no-verbose --show-progress -P ~/Images/$susimage $susurl/Leap-16.0-online-installer-x86_64.install.iso
    echo "Downloading $susimage checksums..."
        wget --no-verbose --show-progress -P ~/Images/$susimage $susurl/Leap-16.0-online-installer-x86_64.install.iso.sha512
    
    echo "Verifying $susimage..."
    cd ~/Images/$susimage
    head -n 1 $susimage-online-installer-x86_64.install.iso.sha512 | sha512sum --check
}

dl-ver-ubu() {
    echo "Creating folder for $ubuimage"
    mkdir -p ~/Images/$ubuimage
    echo "Downloading $ubuimage..."
        wget --no-verbose --show-progress -P ~/Images/$ubuimage $ubuurl/ubuntu-26.04-desktop-amd64.iso
    echo "Downloading $ubuimage checksums..."
        wget --no-verbose --show-progress -P ~/Images/$ubuimage $ubuurl/SHA256SUMS

    echo "Verifying $ubuimage..."
    cd ~/Images/$ubuimage
    head -n 1 SHA256SUMS | sha256sum --check
}

dl-ver-all() {
    dl-ver-alp;
    dl-ver-arc;
    dl-ver-deb;
    dl-ver-sus;
    dl-ver-ubu;
}

OPTS=$(getopt -o "" -l "alpine,arch,debian,nixos,opensuse,ubuntu,all" -- "$@")
eval set -- "$OPTS"

while true; do
    case "$1" in
        --alpine) dl-ver-alp; shift ;;
        --arch) dl-ver-arc; shift ;;
        --debian) dl-ver-deb; shift ;;
        --nixos) dl-ver-nix; shift ;;
        --opensuse) dl-ver-sus; shift ;;
        --ubuntu) dl-ver-ubu; shift ;;
        --all) dl-ver-all; shift ;;
        --) shift; break ;;
        *) echo "Invalid option: $1"; exit 1 ;;
    esac
done