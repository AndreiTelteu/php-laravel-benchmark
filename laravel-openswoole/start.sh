
composer install --no-dev -o \
    && php artisan optimize \
    && php -d variables_order=EGPCS \
        /var/www/html/artisan \
        octane:start \
        --server=swoole \
        --host=0.0.0.0 \
        --workers 100 \
        --port=80
