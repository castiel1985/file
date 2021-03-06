#!/bin/bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH


if [ $(id -u) != "0" ]; then
	echo "you must be root to run the script"
	exit 1
fi

yum update  -y
yum -y install gcc-c++
yum -y install make
yum -y install perl 
yum install -y unzip net-tools vim
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

ln -s /usr/local/lib/libiconv.so.2 /usr/lib64/
cd  /usr/local/src
unzip php-7.1.3.zip
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





#sed -i 's#/scripts#$Document_root#g' /usr/local/nginx/conf/nginx.conf 
sed -i "s#root   html#root  /home/www#g" /usr/local/nginx/conf/nginx.conf
sed -i "s#index  index.html index.htm#index	index.php#g" /usr/local/nginx/conf/nginx.conf
 
sed -i '56i\location ~ \\.php$ {' /usr/local/nginx/conf/nginx.conf
sed -i '57i\    fastcgi_pass   127.0.0.1:9000;' /usr/local/nginx/conf/nginx.conf
sed -i '58i\    fastcgi_index  index.php;' /usr/local/nginx/conf/nginx.conf
sed -i '59i\    fastcgi_param  SCRIPT_FILENAME  /home/www/$fastcgi_script_name;' /usr/local/nginx/conf/nginx.conf
#sed -i '59i#	fastcgi_param  SCRIPT_FILENAME  /home/www$fastcgi_script_name;'
sed -i '60i\    include        fastcgi_params; }' /usr/local/nginx/conf/nginx.conf


mkdir -p /home/www
chmod 777 /home/www
chown -R www:www /home/www


cat <<EOF>/home/www/index.php
<?php
	echo  "php+nginx";
?>
EOF

chmod 777 index.php

/usr/bin/nginx
netstat -tunpl

echo '*******'

curl http://127.0.0.1
