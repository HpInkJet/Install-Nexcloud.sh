#!/bin/bash

# update package manager
sudo apt-get update

# install Apache web server
sudo apt-get install apache2

# enable Apache modules
sudo a2enmod rewrite
sudo a2enmod headers
sudo a2enmod env
sudo a2enmod dir
sudo a2enmod mime

# install PHP and required modules
sudo apt-get install php libapache2-mod-php php-common php-mbstring php-xmlrpc php-soap php-apcu php-smbclient php-ldap php-redis php-gd php-xml php-intl php-json php-imagick

# install MariaDB database server
sudo apt-get install mariadb-server

# create a new database and user for Nextcloud
sudo mysql -u root -p

# enter the following commands in the MariaDB prompt:

# create a new database
CREATE DATABASE nextcloud;

# create a new user and grant permissions
GRANT ALL ON nextcloud.* TO 'nextcloud'@'localhost' IDENTIFIED BY 'password';

# exit the MariaDB prompt
EXIT;

# download and install Nextcloud
wget https://download.nextcloud.com/server/releases/nextcloud-20.0.1.zip
unzip nextcloud-20.0.1.zip
sudo mv nextcloud /var/www/html/

# give ownership of the Nextcloud directory to the Apache user
sudo chown -R www-data:www-data /var/www/html/nextcloud/

# create a new virtual host for Nextcloud
sudo nano /etc/apache2/sites-available/nextcloud.conf

# add the following content to the virtual host file:

<VirtualHost *:80>
    ServerAdmin admin@example.com
    DocumentRoot /var/www/html/nextcloud/

    <Directory /var/www/html/nextcloud/>
        Options +FollowSymlinks
        AllowOverride All
        Require all granted

        <IfModule mod_dav.c>
            Dav off
        </IfModule>

        SetEnv HOME /var/www/html/nextcloud
        SetEnv HTTP_HOME /var/www/html/nextcloud
    </Directory>
</VirtualHost>

# save and close the file

# enable the virtual host and disable the default virtual host
sudo a2ensite nextcloud
sudo a2dissite 000-default.conf

# restart Apache web server
sudo systemctl restart apache2
