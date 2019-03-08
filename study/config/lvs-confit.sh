#!/bin/bash

net
 sysctl -w net.ipv4.ip_forward=1
 ipvsadm -A -t 192.168.3.111:80 -s rr
 ipvsadm -a -t 192.168.3.111:80 -r 172.16.50.133 -m
 ipvsadm -a -t 192.168.3.111:80 -r 172.16.50.1 -m

