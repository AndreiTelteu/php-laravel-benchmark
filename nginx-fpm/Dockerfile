FROM serversideup/php:beta-8.3-fpm-nginx

RUN mkdir -p /var/www/.composer; \
    chown -R www-data:www-data /var/www/.composer; \
    echo "" >> /usr/local/etc/php-fpm.d/docker-php-serversideup-pool.conf; \
    echo "pm.max_requests = \${PHP_FPM_PM_MAX_REQUESTS}" >> /usr/local/etc/php-fpm.d/docker-php-serversideup-pool.conf; \
    docker-php-ext-enable opcache

COPY ./opcache.ini /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
