#!/usr/bin/env bash

# taken from https://unix.stackexchange.com/a/421403
bashget() {
  read proto server path <<< "${1//"/"/ }"
  DOC=/${path// //}
  HOST=${server//:*}
  PORT=${server//*:}
  [[ x"${HOST}" == x"${PORT}" ]] && PORT=80

  exec 3<>/dev/tcp/${HOST}/$PORT

  # send request
  echo -en "GET ${DOC} HTTP/1.0\r\nHost: ${HOST}\r\n\r\n" >&3

  # read the header, it ends in a empty line (just CRLF)
  while IFS= read -r line ; do 
      [[ "$line" == $'\r' ]] && break
  done <&3

  # read the data
  nul='\0'
  while IFS= read -d '' -r x || { nul=""; [ -n "$x" ]; }; do 
      printf "%s$nul" "$x"
  done <&3
  exec 3>&-
}

set -xeo pipefail
export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true

#
# Setup
#
echo "Setting up"

MY_USER=vagrant
groupadd $MY_USER
useradd -m -g $MY_USER $MY_USER

if [ "$LOC" == "" ]; then
    if (which curl > /dev/null); then
        LOC=$(curl -s http://cf-ns.cn/cdn-cgi/trace | grep loc | cut -c 5-)
    elif (which wget > /dev/null); then
        LOC=$(wget -O- http://cf-ns.cn/cdn-cgi/trace  | grep loc | cut -c 5-)
    else
        LOC=$(bashget http://cf-ns.cn/cdn-cgi/trace  | grep loc | cut -c 5-)
    fi
fi
if [ "$LOC" == "CN" ]; then
    sed -i 's#/archive.ubuntu.com/#/opentuna.cn/#g' /etc/apt/sources.list
fi

apt-get update -y
apt-get upgrade -y
apt-get install -y curl git wget unzip dos2unix build-essential locales software-properties-common tzdata subversion

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
    php7.4-fpm \
    php-apcu \
    php-imagick \
    php7.4-dev \
    php7.4-cli \
    php7.4-json \
    php7.4-intl \
    php7.4-mysql \
    php7.4-sqlite \
    php7.4-curl \
    php7.4-gd \
    php7.4-mbstring \
    php7.4-dom \
    php7.4-xml \
    php7.4-zip \
    php7.4-tidy \
    php7.4-bcmath

sed -i 's|display_errors = Off|display_errors = On|' /etc/php/7.4/fpm/php.ini
sed -i 's|memory_limit = 128M|memory_limit = -1|' /etc/php/7.4/fpm/php.ini
sed -i "s|www-data|$MY_USER|" /etc/php/7.4/fpm/pool.d/www.conf

#
# phpredis
#
echo "Installing: Redis"
mkdir -p /src/phpredis
git clone https://github.com/phpredis/phpredis.git /src/phpredis
cd /src/phpredis && git checkout 5.0.1 && phpize && ./configure && make && make install
rm -rf /src/phpredis
echo "extension=redis.so" > /etc/php/7.4/mods-available/redis.ini
ln -sf /etc/php/7.4/mods-available/redis.ini /etc/php/7.4/fpm/conf.d/20-redis.ini
ln -sf /etc/php/7.4/mods-available/redis.ini /etc/php/7.4/cli/conf.d/20-redis.ini

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
