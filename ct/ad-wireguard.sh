#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/mmarszal/ProxmoxVE/refs/heads/ad-wireguard/misc/build.func)
# Copyright (c) 2021-2025 tteck
# Author: tteck (tteckster)
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://www.wireguard.com/

# App Default Values
APP="Ad-Wireguard"
var_tags="network;vpn;adblock"
var_cpu="2"
var_ram="1024"
var_disk="4"
var_os="debian"
var_version="12"
var_unprivileged="1"

# App Output & Base Settings
header_info "$APP"
base_settings

# Core
variables
color
catch_errors

function update_script() {
    header_info
    check_container_storage
    check_container_resources
    if [[ ! -d /etc/wireguard ]]; then
        msg_error "No Wireguard Installation Found!"
        exit
    fi
    if [[ ! -d /opt/AdGuardHome ]]; then
        msg_error "No AdguardHome Installation Found!"
        exit
    fi
    apt-get update
    apt-get -y upgrade
    sleep 2
    cd /etc/wgdashboard/src
    ./wgd.sh update
    msg_ok AdGuardHome needs to be updated in its own user interface
    exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} WGDashboard Access it using the following URL:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:10086${CL}"
echo -e "${INFO}${YW} AdguardHome Access it using the following URL:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:3000${CL}"