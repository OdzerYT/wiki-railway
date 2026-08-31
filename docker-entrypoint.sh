#!/bin/bash
set -e

cp /var/www/html/LocalSettings.php.example /var/www/html/LocalSettings.php

sed -i "s|\$wgDBserver = .*|\$wgDBserver = getenv('MYSQLHOST');|" /var/www/html/LocalSettings.php
sed -i "s|\$wgDBname = .*|\$wgDBname = getenv('MYSQLDATABASE');|" /var/www/html/LocalSettings.php
sed -i "s|\$wgDBuser = .*|\$wgDBuser = getenv('MYSQLUSER');|" /var/www/html/LocalSettings.php
sed -i "s|\$wgDBpassword = .*|\$wgDBpassword = getenv('MYSQLPASSWORD');|" /var/www/html/LocalSettings.php

exec apache2-foreground
