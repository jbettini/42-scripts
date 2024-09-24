#!bin/bash

TXT_RED="\033[1;31m"
TXT_GREEN="\033[1;32m"
TXT_YELLOW="\033[1;33m"
TXT_BLUE="\033[1;34m"
FANCY_RESET="\033[0m"

set -eu

print_color () {
    echo -e "$1$2$FANCY_RESET"
}

cd ~
mkdir -vp sgoinfre/vms

pushd sgoinfre/vms

    print_color "$TXT_YELLOW" "Creating an virtual hard disk ...\n"
    curl -Os https://chuangtzu.ftp.acc.umu.se/debian-cd/current/amd64/iso-cd/debian-12.7.0-amd64-netinst.iso

    qemu-img create -f qcow2 mydebian.qcow2 20G &>/dev/null

    print_color "$TXT_YELLOW" "Starting script created in \"~/sgoinfre/vms/start_debian\"\n"
    cat > start_debian << EOF
#!bin/bash

qemu-system-x86_64 \
   -m 8G \
   -smp 8 \
   -cpu host \
   -net user,hostfwd=tcp::22222-:22 \
   -net nic \
   -enable-kvm \
   -daemonize \
   -hda ~/sgoinfre/vms/mydebian.qcow2
   # if u want to use yout vm in fullscreen uncomment the following lines
   #-vga virtio
   #-full-screen
EOF
    print_color "$TXT_YELLOW" "Starting Debian installation...\n"
    qemu-system-x86_64 \
        -m 8G \
        -smp 8 \
        -cpu host \
        -net user,hostfwd=tcp::22222-:22 \
        -net nic \
        -enable-kvm \
        -cdrom debian-12.7.0-amd64-netinst.iso \
        -daemonize \
        -hda mydebian.qcow2
    sleep 5
    rm -rf ~/sgoinfre/vms/debian-12.7.0-amd64-netinst.iso
popd