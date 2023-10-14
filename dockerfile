FROM php:7.4
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
COPY . /var/www/html
WORKDIR /var/www/html
RUN composer install --no-scripts --no-autoloader
RUN php artisan key:generate
EXPOSE 80
CMD ["php", "-S", "0.0.0.0:80"]