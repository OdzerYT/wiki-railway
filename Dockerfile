FROM php:8.3-apache

RUN docker-php-ext-install mysqli

COPY . /var/www/html/

RUN chown -R www-data:www-data /var/www/html

EXPOSE 8080

CMD ["bash", "-c", "sed -i 's/^Listen 80$/Listen 8080/' /etc/apache2/ports.conf; sed -i 's/<VirtualHost \\*:80>/<VirtualHost *:8080>/' /etc/apache2/sites-enabled/000-default.conf; apache2ctl -t; exec apache2-foreground"]
