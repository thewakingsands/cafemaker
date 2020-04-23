#!/usr/bin/env bash

set -e
set -x
export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true

#
# Setup
#
echo "Setting up"

MY_USER=vagrant
groupadd $MY_USER
useradd -m -g $MY_USER $MY_USER

apt-get update -y
apt-get upgrade -y
apt-get install -y curl git build-essential locales software-properties-common tzdata subversion

ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
dpkg-reconfigure -f noninteractive tzdata

locale-gen en_GB.UTF-8

#
# NGINX
#
echo "Installing: NGINX"
add-apt-repository ppa:nginx/stable -y
apt-get update
apt-get install -y nginx
rm /etc/nginx/sites-available/default
cp /vagrant/vm/VagrantfileNginxCommon /etc/nginx/sites-available/common
cp /vagrant/vm/VagrantfileNginxDefault /etc/nginx/sites-available/default
cp /vagrant/vm/VagrantfileNginx.conf /etc/nginx/nginx.conf
sed -i 's#error_log /dev/null#error_log stderr#' /etc/nginx/nginx.conf

nginx -t

#
# PHP + Composer + Imagick
#
echo "Installing: PHP + Composer"
add-apt-repository ppa:ondrej/php -y
apt-get update -y
apt-get install -y \
    php7.3-fpm \
    php-apcu \
    php-imagick \
    php7.3-dev \
    php7.3-cli \
    php7.3-json \
    php7.3-intl \
    php7.3-mysql \
    php7.3-sqlite \
    php7.3-curl \
    php7.3-gd \
    php7.3-mbstring \
    php7.3-dom \
    php7.3-xml \
    php7.3-zip \
    php7.3-tidy \
    php7.3-bcmath

sed -i 's|display_errors = Off|display_errors = On|' /etc/php/7.3/fpm/php.ini
sed -i 's|memory_limit = 128M|memory_limit = -1|' /etc/php/7.3/fpm/php.ini
sed -i "s|www-data|$MY_USER|" /etc/php/7.3/fpm/pool.d/www.conf

#
# phpredis
#
echo "Installing: Redis"
mkdir -p /src/phpredis
git clone https://github.com/phpredis/phpredis.git /src/phpredis
cd /src/phpredis && git checkout 5.0.1 && phpize && ./configure && make && make install
rm -rf /src/phpredis
echo "extension=redis.so" > /etc/php/7.3/mods-available/redis.ini
ln -sf /etc/php/7.3/mods-available/redis.ini /etc/php/7.3/fpm/conf.d/20-redis.ini
ln -sf /etc/php/7.3/mods-available/redis.ini /etc/php/7.3/cli/conf.d/20-redis.ini

# composer
curl https://getcomposer.org/installer > /tmp/composer-installer.php
php /tmp/composer-installer.php --install-dir=/usr/local/bin --filename=composer
rm /tmp/composer-installer.php
cd /vagrant
composer install --no-scripts

echo 0 > ./git_version.txt
echo 'docker' >> ./git_version.txt
date +%s >> ./git_version.txt

#
# Finish
#
echo "Finishing up ..."
mkdir -p /vagrant_xivapi /vagrant_mogboard
mkdir -p /run/php
chown $MY_USER:$MY_USER /vagrant_xivapi /vagrant_mogboard
chmod -R 777 /vagrant_xivapi /vagrant_mogboard
chmod +x /cafemaker/bin/*.sh

apt-get remove -y software-properties-common 
apt-get purge -y build-essential
apt-get autoremove -y
apt-get autoclean -y
apt-get clean -y
rm -rf /var/lib/apt/lists/*
