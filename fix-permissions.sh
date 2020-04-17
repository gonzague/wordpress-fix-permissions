#!/bin/bash
#
# This script configures WordPress file permissions based on recommendations
# from http://codex.wordpress.org/Hardening_WordPress#File_permissions
#
# Author: Mostly based on Michael Conigliaro's script - https://gist.github.com/macbleser/9136424 
#

## To run the script, download it, allow execution ( chmod +x command ) and then run it as ./fix-permissions.sh and specify the folder to fix
## For example :
## ./fix-permissions /var/www/wordpress

## Alter the following variables as per your setup otherwise the script will not do anygood to you
WP_OWNER=www-data # &lt;-- wordpress owner
WP_GROUP=www-data # &lt;-- wordpress group
WP_ROOT=$1 # &lt;-- wordpress root directory
WS_GROUP=www-data # &lt;-- webserver group

echo " __        __            _ ____                    ";
echo " \ \      / /__  _ __ __| |  _ \ _ __ ___  ___ ___ ";
echo "  \ \ /\ / / _ \| '__/ _\` | |_) | '__/ _ \/ __/ __| ";
echo "   \ V  V / (_) | | | (_| |  __/| | |  __/\__ \__ \ ";
echo "  __\_/\_/ \___/|_|__\__,_|_|   |_|  \___||___/___/ ";
echo " |  ___(_)_  __ |  _ \ ___ _ __ _ __ ___  ___       ";
echo " | |_  | \ \/ / | |_) / _ \ '__| '_ \` _ \/ __|     ";
echo " |  _| | |>  <  |  __/  __/ |  | | | | | \__ \     ";
echo " |_|   |_/_/\_\ |_|   \___|_|  |_| |_| |_|___/     ";
echo "                                                   ";

echo "####################################################";
echo "Time to fix permissions for $1";
 
# allow wordpress to manage wp-config.php (but prevent world access)
echo "changing wp-config group"
chgrp ${WS_GROUP} ${WP_ROOT}/wp-config.php
echo "changing wp-config perms"
chmod 660 ${WP_ROOT}/wp-config.php
 
# allow wordpress to manage .htaccess
touch ${WP_ROOT}/.htaccess
echo "changing wp-htaccess group"
chgrp ${WS_GROUP} ${WP_ROOT}/.htaccess
echo "changing wp-config perms"
chmod 664 ${WP_ROOT}/.htaccess

# reset to safe defaults

echo "Changing user and group - this can take a while";
find ${WP_ROOT} -exec chown ${WP_OWNER}:${WP_GROUP} {} \;

echo "Changing directory perms";
find ${WP_ROOT} -type d -exec chmod 755 {} \;

echo "Changing file perms"
find ${WP_ROOT} -type f -exec chmod 644 {} \;
 
 
# allow wordpress to manage wp-content
echo "changing wp-content group"
find ${WP_ROOT}/wp-content -exec chgrp ${WS_GROUP} {} \;
echo "changing wp-content directory permissions"
find ${WP_ROOT}/wp-content -type d -exec chmod 775 {} \;
echo "changing wp-content file permissions"
find ${WP_ROOT}/wp-content -type f -exec chmod 664 {} \;
