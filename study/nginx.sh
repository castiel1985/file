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
yum install -y unzip
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
./configure --prefix=/usr/local/nginx --with-http_gzip_static_module --with-pcre=/usr/local/src/pcre --with-zlib=/usr/local/src/zlib --with-openssl=/usr/local/src/openssl

make && make install

ln -sf /usr/local/nginx/sbin/nginx /usr/bin/nginx


/usr/local/nginx/sbin/nginx -t

echo "************Install php ***********"

yum -y  install gcc gcc++ libxml2-devel curl-devel libjpeg-devel libpng-devel libc-client-devel freetype-devel unixODBC-devel libicu-devel libxslt-devel libmcrypt-devel
yum -y  install glibc-headers

cd  /usr/local/src

cd  php-7.1.3
./configure --prefix=/usr/local/php7 --with-config-file-path=/usr/local/php7/etc --with-config-file-scan-dir=/usr/local/php7/etc/php.d --with-fpm-user=www --with-fpm-group=www --enable-fpm --disable-fileinfo --enable-mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-iconv-dir=/usr/local --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-bcmath --enable-shmop --enable-exif --enable-sysvsem --with-curl --enable-mbregex --enable-inline-optimization --enable-mbstring  --with-gd --enable-gd-native-ttf --with-openssl --with-mhash --enable-pcntl --enable-sockets --with-xmlrpc --enable-ftp --enable-intl --with-xsl --with-gettext --enable-zip --enable-soap --disable-ipv6 --disable-debug
make &&make install

ln -sf /usr/local/php7/bin/php /usr/bin/php
ln -sf /usr/local/php7/sbin/php-fpm /usr/bin/php-fpm
ln -sf /usr/local/php7/bin/phpize /usr/bin/phpize
ln -sf /usr/local/php7/bin/pecl /usr/bin/pecl

cp /usr/local/src/php-7.1.3/php.ini-development /usr/local/php7/etc/php.ini
cp /usr/local/php7/etc/php-fpm.conf.default /usr/local/php7/etc/php-fpm.conf
cp /usr/local/php7/etc/php-fpm.d/www.conf.default /usr/local/php7/etc/php-fpm.d/www.conf
useradd www
/usr/bin/php-fpm





sed -i 's#/scripts#$Document_root#g' /usr/local/nginx/conf/nginx.conf 
mkdir -p /home/www/html
chmod +w /home/www/html
chown -R www:www /home/www/html




/usr/bin/nginx
netstat -tunpl
