#!/bin/bash

# Description:
# WordPress installation script using wp-cli.
# 
# wp-cli: http://wp-cli.org/
# 
# Warning:
# This script is for developing WordPress themes and/or plugins on your LOCAL machine.
# So, when you use this script on a remote server, please revise the script as you need.
# 
# Version: 0.1
# 
# License:
# Released under the GPL license
# http://www.gnu.org/copyleft/gpl.html
# 
# Copyright 2013 (email : tekapo@gmail.com)
# 
#  This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA

# Set default parameters.

SELF_DIR=`dirname $0`

WEB_SERVER_PROCESS_NAME='httpd'
MYSQL_PROCESS_NAME='mysqld'

CURRENT_DATE=`date '+%Y%m%d'`
CURRENT_TIME=`date '+%H%M%S'`

CURRENT_DATE_TIME="${CURRENT_DATE}_${CURRENT_TIME}"

DOCUMENT_ROOT='/var/www'

WP_LOCALE='ja'

DBNAME="wp_test_${CURRENT_DATE_TIME}"
DBUSER='root'
DBPASSWORD='root'

DOMAIN='localhost'

WP_URL=''
WP_TITLE=''
WP_ADMIN_NAME='admin'
WP_ADMIN_PASSWORD='admin'
WP_ADMIN_EMAIL='admin@example.com'

WP_ADDITIONAL_USER_NAME='test1'
WP_ADDITIONAL_USER_PASSWORD='test1'
WP_ADDITIONAL_USER_EMAIL='test1@example.com'

WP_INSATALL_DIR="wp_${CURRENT_DATE_TIME}"
WP_INSTALL_FULL_PATH="${DOCUMENT_ROOT}/${WP_INSATALL_DIR}"

PLUGINS_LIST='plugins-list.txt'
THEMES_LIST='themes-list.txt'

PLUGINS_LIST_FULL_PATH="${SELF_DIR}/${PLUGINS_LIST}"
THEMES_LIST_FULL_PATH="${SELF_DIR}/${THEMES_LIST}"

# Show the warning

cat << HEREDOC
WARNING:

This script is for developing WordPress themes and/or plugins on your LOCAL machine.
So, when you use this script on a remote server, please revise the script as you need.

HEREDOC

# Check if the wp-cli command is installed or not

if ! type "wp" > /dev/null
	then
		echo 'wp-cli is not installed. Please see wp-cli.org for further information about the installing.'
		exit
fi

# Check if the web server is running.
# Ah, the process name may be the one for nginx, so commented out this section.
 
# if ! ps ax | grep -v grep | grep $WEB_SERVER_PROCESS_NAME > /dev/null
# then
#     echo "$WEB_SERVER_PROCESS_NAME service not running. You may check the status."
#     exit
# fi

# TODO: Check if MySQL is running.

# if ! ps ax | grep -v grep | grep $MYSQL_PROCESS_NAME > /dev/null
# then
#     echo "$MYSQL_PROCESS_NAME service not running. You may check the status."
#     exit
# fi

# TODO: Show the parameters, and press Y to go, N to exit.

# echo "Current date and time: ${CURRENT_DATE_TIME}"
# echo "Making directory based on the current date and time as follows: ${WP_INSTALL_FULL_PATH}"

#if [N]
#	then
#	exit
#fi

# Start installing.

# Making the directory for the WordPress installation.

mkdir ${WP_INSTALL_FULL_PATH}

# Downloading the latest WordPress.

echo "Downloading the latest WordPress to: ${WP_INSTALL_FULL_PATH}"

wp core download \
	--locale=${WP_LOCALE} \
	--path=${WP_INSTALL_FULL_PATH}

# cd to the WordPress root directory just installed. 

cd ${WP_INSTALL_FULL_PATH}

# Create wp-config.php.

wp core config \
	--dbname=${DBNAME} \
	--dbuser=${DBUSER} \
	--dbpass=${DBPASSWORD}

# Create a database.
# TODO: If it doesn't work, show the error message and exit

wp db create

# Install WordPress

if ["${WP_URL}" = '']
	then
		WP_URL="${DOMAIN}/${WP_INSATALL_DIR}"
fi

if ["${WP_TITLE}" = '']
	then
		WP_TITLE="wp_test_${CURRENT_DATE_TIME}"
fi

wp core install \
	--url=${WP_URL} \
	--title=${WP_TITLE} \
	--admin_name=${WP_ADMIN_NAME} \
	--admin_password=${WP_ADMIN_PASSWORD} \
	--admin_email=${WP_ADMIN_EMAIL}


# Install and activate plugins.

if [ -e "${PLUGINS_LIST_FULL_PATH}" ]
	then
		for PLUGIN in $(cat ${PLUGINS_LIST_FULL_PATH})
			do
				wp plugin install ${PLUGIN} --activate
			done
fi

# Install themes 
# TODO: activate one of them.

if [ -e "${THEMES_LIST_FULL_PATH}" ]
	then
		for THEME in $(cat ${THEMES_LIST_FULL_PATH})
			do
				wp theme install ${THEME}
			done
fi

# TODO: Add other users.

# while read USERS
#	do
		wp user create ${WP_ADDITIONAL_USER_NAME} ${WP_ADDITIONAL_USER_EMAIL} ${WP_ADDITIONAL_USER_PASSWORD}
#	done <${WP_ADDITIONAL_USERS_LSIT}

# TODO: Set the settings like the permalink structure and so on.

# TODO: Show the install results.

cat << HEREDOC

WordPress is installed as below:

Now you can open http://${WP_URL}

HEREDOC

cd