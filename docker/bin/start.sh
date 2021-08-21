#!/bin/bash
echo 'starting php-fpm'
php-fpm7.4
echo 'starting nginx'

nginx -g 'daemon off;'
