FROM serversideup/php:beta-8.3-cli

RUN mkdir -p /var/www/.composer; \
    chown -R www-data:www-data /var/www/.composer; \
    docker-php-ext-install sockets; \
    pecl install openswoole; \
    docker-php-ext-enable opcache openswoole;

COPY ./opcache.ini /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
COPY ./start.sh /start.sh

CMD [ "sh", "/start.sh" ]

# for debuging
# CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"