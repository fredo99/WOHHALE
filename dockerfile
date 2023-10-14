# Menggunakan image PHP-FPM Alpine sebagai base image
FROM php:7.4-fpm-alpine

# Instal dependensi yang diperlukan oleh Laravel
RUN apk --no-cache add \
    build-base \
    libzip-dev \
    zip \
    unzip \
    mysql-client \
    && docker-php-ext-install zip pdo_mysql

# Set direktori kerja di dalam container
WORKDIR /var/www/html

# Instal Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Menyalin file-file proyek Laravel ke dalam container
COPY . /var/www/html

# Install dependencies dan mengoptimalkan autoload
RUN composer install --no-scripts --no-autoloader && \
    composer dump-autoload --optimize

# Menghasilkan kunci aplikasi Laravel
RUN php artisan key:generate
RUN php artisan serve

# Expose port 80
EXPOSE 80

# Menjalankan server PHP-FPM
CMD ["php-fpm"]
