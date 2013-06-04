inst-wp-with-wp-cli
===================

This is a shell script to install WordPress with [wp-cli](http://wp-cli.org/).

Some default values you may need to change as follow:
- Locale = ja
- Document root = /var/www
- Database user = root
- Datebase password = root

Before run the script, you may be better to change those default values.

The script will be:

1. Making a directory under the document root (you can specify it in the script) as wp_yyyymmdd_hhmmss like /var/www/wp_20130606_123456/
2. Downloading the latest WordPress to the direcotry above.
3. Making wp-config.php with the above values.
4. Creating a database with values in wp-config.php
5. Installing WordPress
6. Installing and activating plugins listed in plugins-list.txt
7. Installing themes listed in themes-list.txt
8. Creating an additional user as test1

That's it!
