#!/bin/sh

OUTPUT=$(cat /etc/*release)
if  echo $OUTPUT | grep -q "Ubuntu 18.04" ; then
apt update
                SERVER_OS="Ubuntu"
elif echo $OUTPUT | grep -q "Ubuntu 20.04" ; then
apt update
                SERVER_OS="Ubuntu20"
elif echo $OUTPUT | grep -q "Ubuntu 22.04" ; then
apt update
                SERVER_OS="Ubuntu22"
else
                echo -e "\Only supported on Ubuntu 18.04, Ubuntu 20.04, Ubuntu 20.10, and Ubuntu 22.04 \n"
                exit 1
fi

# update system
apt update

# upgrade system
apt upgrade -y && apt dist-upgrade -y

# remove unused files
apt autoremove -y

# install sudo
apt install sudo -y

# install tools
sudo apt-get install software-properties-common wget curl nano -y

# remove apache2 from machine
sudo apt purge apache2* -y

# remove unused files
sudo apt autoremove -y

# add nginx repository
sudo add-apt-repository ppa:ondrej/nginx -y

# update repository
sudo apt update && sudo apt dist-upgrade -y

# install nginx latest version
sudo apt install nginx -y

# add php repository
sudo add-apt-repository ppa:ondrej/php -y

# install php 7.4
sudo apt install php7.4-fpm php7.4-common php7.4-mysql php7.4-xml php7.4-xmlrpc php7.4-curl php7.4-gd php7.4-imagick php7.4-cli php7.4-dev php7.4-imap php7.4-mbstring php7.4-opcache php7.4-redis php7.4-soap php7.4-zip php7.4-mailparse php7.4-gmp -y

# install mariadb server
sudo apt install mariadb-server -y

# manual setup mariadb
# sudo mysql_secure_installation

# download nginx config
wget https://raw.githubusercontent.com/rydhoms/lemp-install/main/example.com -O /etc/nginx/sites-available/example.com

# link downloaded nginx config to sites-enabled
sudo ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/

# unlink the default configuration file from the /sites-enabled/ directory
sudo unlink /etc/nginx/sites-enabled/default

# restart nginx
sudo service nginx restart

# restart php-fpm
sudo service php7.4-fpm restart

# restart mariadb
sudo service mariadb restart

# write php info
echo -e "<?php\n phpinfo()\n?>" >> /var/www/html/info.php

echo "Installation completed"
echo "You can access your web on your IP or domain pointing to your IP"
echo "you access php info on http://your-domain.com/info.php"
echo "after installation complete, you need to configure mariadb with this command:"
echo "sudo mysql_secure_installation"
