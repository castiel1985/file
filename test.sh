#!/bin/bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH


if [ $(id -u) != "0" ]; then
	echo "you must be root to run the script"
	exit 1
fi

yum update
yum -y install gcc-c++
yum -y install make
yum -y install perl
cd /usr/local/src

tar zxvf pcre-8.40.tar.gz
mv pcre-8.40 pcre 
cd pcre
./configure
make && make install
cd ..


tar zxvf zlib-1.2.11.tar.gz
mv zlib-1.2.11 zlib 
cd zlib
./configure
make && make install
cd ..

tar zxvf openssl-1.0.2o.tar.gz
mv openssl-1.0.2o openssl
cd openssl
./config
make && make install
cd ..

unzip nginx-1.10.3.zip
cd nginx-1.10.3
./configure --prefix=/usr/local/nginx --with-http_gzip_static_module --http-client-body-temp-path=/var/temp/nginx/client --http-proxy-temp-path=/var/temp/nginx/proxy --http-fastcgi-temp-path=/var/temp/nginx/fastcgi --http-uwsgi-temp-path=/var/temp/nginx/uwsgi --http-scgi-temp-path=/var/temp/nginx/scgi --with-pcre=/usr/local/src/pcre --with-zlib=/usr/local/src/zlib --with-openssl=/usr/local/src/openssl

make && make install

