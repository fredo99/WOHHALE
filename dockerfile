# # Gunakan image PHP yang mendukung Laravel (contoh: php:7.4-apache)
# FROM php:8.0

# # Set direktori kerja di dalam container
# WORKDIR /var/www/html/wohhale

# # Install dependensi yang diperlukan oleh Laravel
# RUN apt-get update \
#     && apt-get install -y \
#         libzip-dev \
#         unzip \
#         git \
#     && docker-php-ext-install zip pdo_mysql

# # Instal Composer
# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# # Salin file proyek Laravel ke dalam container
# COPY . /var/www/html/wohhale/

# # Install dependencies dan mengoptimalkan autoload
# RUN composer install --no-scripts --no-autoloader \
#     && composer dump-autoload --optimize

# # Menghasilkan kunci aplikasi Laravel
# RUN php artisan key:generate
# # tambahan
# # RUN php artisan serve

# # Expose port 80 (Anda juga bisa mengganti port jika diperlukan)
# EXPOSE 80

# # Menjalankan server Apache
# CMD ["php", "-S", "0.0.0.0:80"]
# Use an official PHP runtime as a parent image
FROM php:8.0-apache

# Set the working directory in the container
WORKDIR /var/www/html/wohhale

# Install dependencies and enable required modules
RUN apt-get update && \
    apt-get install -y git zip unzip && \
    docker-php-ext-install pdo_mysql && \
    a2enmod rewrite

# Copy the composer.json and composer.lock files
COPY composer.json composer.lock ./

# Install Laravel dependencies
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-scripts --no-autoloader

# Copy the rest of the application code
COPY . /var/www/html/wohhale/

# Set permissions
RUN chmod -R 755 /var/www/html/wohhale \
    && chmod -R 775 /var/www/html/wohhale/storage
RUN chown -R www-data:www-data *

RUN a2enmod proxy
RUN a2enmod proxy_http

# Restart Apache
RUN service apache2 restart

# Generate the optimized autoloader and clear the cache
RUN composer dump-autoload --optimize && \
    php artisan config:cache && \
    php artisan route:cache

RUN php artisan key:generate


# Expose port 80
EXPOSE 8080

# Start Apache
CMD ["apache2-foreground"]
