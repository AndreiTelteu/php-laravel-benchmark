FROM serversideup/php:beta-unit

RUN mkdir -p /var/www/.composer; \
    chown -R www-data:www-data /var/www/.composer; \
    docker-php-ext-enable opcache

COPY ./opcache.ini /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
COPY config.json /etc/unit/config.d/config.json
