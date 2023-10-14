FROM php:7.4
RUN docker-php-ext-install mysqli
COPY wohhale/ /var/www/html
WORKDIR /var/www/html
EXPOSE 80
CMD ["php", "-S", "0.0.0.0:80"]