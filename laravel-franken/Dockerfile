FROM dunglas/frankenphp

RUN mkdir -p /var/www/.composer; \
    chown -R www-data:www-data /var/www/.composer; \
    docker-php-ext-install sockets pcntl; \
    docker-php-ext-enable opcache;

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
COPY ./opcache.ini /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
COPY ./start.sh /start.sh

WORKDIR /var/www/html
CMD [ "sh", "/start.sh" ]

# for debuging
# CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"