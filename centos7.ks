#version=RHEL7
cdrom
install

url --url=http://mirror.centos.org/centos/$releasever/os/$basearch/

text
poweroff
skipx

keyboard --vckeymap=jp --xlayouts='jp'
lang ja_JP.UTF-8
timezone  Asia/Tokyo --isUtc

auth --enableshadow --passalgo=sha512

network --onboot yes --device eth0 --bootproto dhcp --noipv6 --hostname=centos7

repo --name="CentOS" --baseurl=http://mirror.centos.org/centos/$releasever/os/$basearch/ --cost=100
repo --name="Updates" --baseurl=http://mirror.centos.org/centos/$releasever/updates/$basearch/ --cost=100

firstboot --enabled
ignoredisk --only-use=sda

firewall --enabled --service=ssh
rootpw vagrant
selinux --disabled
bootloader --location=mbr --append="norhgb net.ifnames=0 biosdevname=0"

logging --level=debug

zerombr

clearpart --all --initlabel
autopart --type=lvm --nohome

reboot --eject

%packages --ignoremissing
@Base
@Core
-aic94xx-firmware
-alsa-*
-btrfs-progs*
-centos-logos
-dracut-config-rescue
-dracut-network
-microcode_ctl
-NetworkManager*
-ivtv-firmware
-iwl*firmware
-plymouth*
%end


%post --log=/var/log/ks.post.log
#!/bin/bash
set -x

sudo yum update -y
sudo yum install perl wget git open-vm-tools -y
echo 'vagrant ALL=(ALL)  ALL'   >> /etc/sudoers.d/vagrant
echo 'Defaults:root requiretty' >> /etc/sudoers.d/vagrant
sed s/PasswordAuthentication\ yes/PasswordAuthentication\ no/ -i /etc/ssh/sshd_config

/bin/rm -f /etc/udev/rules.d/70-persistent-net.rules
yum clean all
/bin/rm -f /var/log/*

%end

reboot
