#!/bin/bash

echo 1 > /proc/sys/net/ipv4/ip_forward
ipv=/sbin/ipvsadm
vip=192.168.188.120
rs1=192.168.188.107
rs2=192.168.188.110
#注意这里的网卡名字
ifdown eth0
ifup eth0
ifconfig eth0:2 $vip broadcast $vip netmask 255.255.255.255 up
route add -host $vip dev eth0:2
$ipv -C
$ipv -A -t $vip:80 -s wrr
$ipv -a -t $vip:80 -r $rs1:80 -g -w 1
$ipv -a -t $vip:80 -r $rs2:80 -g -w 1
