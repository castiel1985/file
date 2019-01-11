#!/bin/bash

mkdir /home/castiel/www
cat <<EOF>/home/castiel/www/index.php
<?php
        echo  "php+nginx";
?>
EOF

