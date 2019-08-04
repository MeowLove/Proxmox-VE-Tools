#!/bin/bash

## License: GPL
## An instruction set that initializes the Proxmox Virtual Environment
## Proxmox-VE-Tools - MeowLove (CXT)
## Proxmox Virtual Environment Tools (https://github.com/MeowLove/Proxmox-VE-Tools)

## You need to install PVE6.X to use it, either through ISO or Network-Reinstall-System-Modify
## Network-Reinstall-System-Modify (https://github.com/MeowLove/Network-Reinstall-System-Modify)
## Technical support is provided by the CXT (CXTHHHHH.com)

## Author:
## WebSite: https://www.cxthhhhh.com
## Written By CXT (CXTHHHHH.com)


echo -e "\n\n\n"
clear
echo -e "\n"
echo "---------------------------------------------------------------------------------------------------------------------"
echo -e "\033[33m Initializes 6.X - Proxmox VE Tools V1.0.5 2019/08/06 \033[0m"
echo -e "\033[33m An instruction set that initializes the Proxmox Virtual Environment \033[0m"
echo -e "\n"
echo -e "\033[33m You need to read the following tutorial in detail: \033[0m"
echo -e "\033[33m https://www.cxthhhhh.com/ \033[0m"
echo "---------------------------------------------------------------------------------------------------------------------"
echo -e "\n"
sleep 5s

echo -e "\033[37m Modify Subscription (pve-no-subscription)... \033[0m"
mv /etc/apt/sources.list.d/pve-enterprise.list /etc/apt/sources.list.d/pve-enterprise.list.bak
echo -e 'deb http://download.proxmox.com/debian/pve buster pve-no-subscription
deb http://deb.debian.org/debian experimental main' > /etc/apt/sources.list.d/pve-enterprise.list
wget http://download.proxmox.com/debian/proxmox-ve-release-6.x.gpg -O /etc/apt/trusted.gpg.d/proxmox-ve-release-6.x.gpg
chmod +r /etc/apt/trusted.gpg.d/proxmox-ve-release-6.x.gpg
echo -e "\033[32m Modify Subscription (pve-no-subscription)...OK \033[0m"
sleep 1s

echo -e "\033[37m Update Proxmox and Debian to the latest and install common software... \033[0m"
apt remove os-prober -y
apt update -y && apt dist-upgrade -y
apt update -y && apt full-upgrade -y
apt install -y vim curl wget lrzsz odhcp6c nano isc-dhcp-server net-tools sudo p7zip-full
echo -e "\033[32m Update Proxmox and Debian to the latest and install common software...OK \033[0m"
sleep 1s

echo -e "\033[37m Cancel management panel login subscription reminder... \033[0m"
sed -i.bak "s/data.status !== 'Active'/false/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
systemctl restart pveproxy.service
echo -e "\033[32m Cancel management panel login subscription reminder...OK \033[0m"
sleep 1s

echo -e "\033[37m System variable file to enable forwarding and network optimization... \033[0m"
echo -e 'net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
net.ipv4.ip_forward = 1
net.ipv6.conf.vmbr0.autoconf = 0
net.ipv6.conf.vmbr0.accept_ra = 2
net.ipv6.conf.default.proxy_ndp = 1
net.ipv6.conf.default.forwarding = 1
net.ipv6.conf.all.forwarding = 1
net.ipv6.conf.all.proxy_ndp = 1' > /etc/sysctl.conf
sysctl -p
echo -e "\033[32m System variable file to enable forwarding and network optimization...OK \033[0m"
sleep 1s

echo -e "\033[37m PVE panel SSL certificate customization (protection of privacy)... \033[0m"
wget --no-check-certificate -qO /etc/pve/local/pve-ssl.pem 'https://raw.githubusercontent.com/MeowLove/Proxmox-VE-Tools/master/CoreFiles/pve-ssl/pve-ssl_empty.pem'
wget --no-check-certificate -qO /etc/pve/local/pve-ssl.key 'https://raw.githubusercontent.com/MeowLove/Proxmox-VE-Tools/master/CoreFiles/pve-ssl/pve-ssl_empty.key'
systemctl restart pveproxy
echo -e "\033[32m PVE panel SSL certificate customization (protection of privacy)...OK \033[0m"
sleep 1s

echo -e "\033[37m Download System Template (ISO)... \033[0m"
wget --no-check-certificate -qO /var/lib/vz/template/iso/Boot-Legacy(netboot.xyz).iso 'https://raw.githubusercontent.com/MeowLove/Proxmox-VE-Tools/master/CoreFiles/iso/Boot-Legacy(netboot.xyz).iso'
wget --no-check-certificate -qO /var/lib/vz/template/iso/Boot-EFI(netboot.xyz).iso 'https://raw.githubusercontent.com/MeowLove/Proxmox-VE-Tools/master/CoreFiles/iso/Boot-EFI(netboot.xyz).iso'
systemctl restart pveproxy
echo -e "\033[32m Download System Template (ISO)...OK \033[0m"
sleep 1s

echo -e "\033[37m Configure DHCP (10.0.0.1/8, routers 10.0.0.1)... \033[0m"
mv /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.bak
echo -e 'INTERFACES="vmbr1"' > /etc/default/isc-dhcp-server
mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak
echo -e 'default-lease-time 600;
max-lease-time 7200;
option subnet-mask 255.0.0.0;
option broadcast-address 10.255.255.255;
option routers 10.0.0.1;
option domain-name-servers 1.1.1.1, 8.8.8.8;
option domain-name "pve-test.tools.cxthhhhh.com";
option netbios-name-servers 10.0.0.1;

subnet 10.0.0.0 netmask 255.0.0.0 {
range 10.0.0.10 10.0.0.254;
}' > /etc/dhcp/dhcpd.conf
echo -e "\033[32m Configure DHCP (10.0.0.0/8, routers 10.0.0.1)...OK \033[0m"
sleep 1s

echo -e "\033[37m Update Gurb2 to clean up invalid Debian kernel... \033[0m"
dpkg --list | egrep -i --color 'linux-image|linux-headers'
apt remove linux-image-amd64 'linux-image-4.19*' -y
update-grub
echo -e "\033[32m Update Gurb2 to clean up invalid Debian kernel...OK \033[0m"
sleep 1s

echo -e "\n"
echo -e "\033[32m Please follow the tutorial to configure the Networks NIC settings (vim /etc/network/interfaces) \033[0m"
echo -e "\033[32m After the setup is complete, please restart the server (reboot) \033[0m"
echo "---------------------------------------------------------------------------------------------------------------------"
echo -e "\033[33m Initializes 6.X - Proxmox VE Tools V1.0.5 2019/08/06 \033[0m"
echo -e "\033[33m An instruction set that initializes the Proxmox Virtual Environment \033[0m"
echo -e "\n"
echo -e "\033[33m You need to read the following tutorial in detail: \033[0m"
echo -e "\033[33m https://www.cxthhhhh.com/ \033[0m"
echo "---------------------------------------------------------------------------------------------------------------------"
echo -e "\n"
exit