
composer install --no-dev -o \
    && php artisan optimize \
    && php -d variables_order=EGPCS \
        /var/www/html/artisan \
        octane:start \
        --server=roadrunner \
        --host=0.0.0.0 \
        --rpc-port=6001 \
        --workers 50 \
        --port=80
