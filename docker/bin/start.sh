#!/bin/bash
echo 'starting php-fpm'
php-fpm7.3
echo 'starting nginx'

nginx -g 'daemon off;'
