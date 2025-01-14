#!/usr/bin/env bash

log() {
    echo "$1" | tee -a installer.log
}
# this must be before installer_x86_64.sh
# because this will install some basic tools which are required by installer_x86_64.sh
# such as curl, etc.
if grep -i ubuntu /etc/os-release; then
    bash installer_ubuntu.sh
elif grep -i centos /etc/os-release; then
    bash installer_centos.sh
elif grep -i archlinux /etc/os-release; then
    bash installer_archlinux.sh
else
    log "Now only support ubuntu"
fi

if arch | grep 'x86_64'; then
    bash installer_x86_64.sh
else
    log "Now only support x86_64"
fi

