# Gunakan image PHP yang mendukung Laravel (contoh: php:7.4-apache)
FROM php:8.0

# Set direktori kerja di dalam container
WORKDIR /var/www/html/wohhale

# Install dependensi yang diperlukan oleh Laravel
RUN apt-get update \
    && apt-get install -y \
        libzip-dev \
        unzip \
        git \
    && docker-php-ext-install zip pdo_mysql

# Instal Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Salin file proyek Laravel ke dalam container
COPY . /var/www/html/wohhale/

# Install dependencies dan mengoptimalkan autoload
RUN composer install --no-scripts --no-autoloader \
    && composer dump-autoload --optimize

# Menghasilkan kunci aplikasi Laravel
RUN php artisan key:generate

# Expose port 80 (Anda juga bisa mengganti port jika diperlukan)
EXPOSE 80

# Menjalankan server Apache
CMD ["php", "-S", "0.0.0.0:80"]
