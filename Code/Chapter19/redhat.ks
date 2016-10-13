install
reboot
url --url=$tree
key --skip
firstboot --disable
auth --enablemd5 --useshadow
bootloader --loader=mbr
keyboard us
lang en_AU
timezone  Australia/Melbourne
rootpw --iscrypted $1$V.rhw$VUj.euMxoV9WkcQSanpGi0
firewall --enabled --http --ssh --smtp  
selinux --disabled
network --bootproto=dhcp --device=eth0 --onboot=on
clearpart --all ?initlabel
autopart
%packages
@ Administration Tools
@ Server Configuration Tools
@ System Tools
@ Text-based Internet
dhcp
