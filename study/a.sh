#!/bin/bash


 
#sed -i "s#root   html#root  home/www/html#g" c.conf
#sed -i "s#index  index.html index.htm#index     index.php#g" c.conf

sed -i '54i\location ~ \.php$ {' c.conf
sed -i '55i\	fastcgi_pass   127.0.0.1:9000;' c.conf
sed -i '56i\	fastcgi_index  index.php;' c.conf
sed -i '57i\	fastcgi_param  SCRIPT_FILENAME  $Document_root$fastcgi_script_name;' c.conf
sed -i '58i\	include        fastcgi_params; }' c.conf
