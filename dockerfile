FROM php:7.4
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-scripts --no-autoloader
RUN php artisan key:generate
COPY wohhale /var/www/html/wohhale
WORKDIR /var/www/html/wohhale
EXPOSE 80
CMD ["php", "-S", "0.0.0.0:80"]