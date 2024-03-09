
composer install --no-dev -o \
    && php artisan optimize \
    && php -d variables_order=EGPCS \
        /var/www/html/artisan \
        octane:start \
        --server=frankenphp \
        --host=0.0.0.0 \
        --admin-port 81 \
        --port=80
