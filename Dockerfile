FROM php:8.3-apache

RUN docker-php-ext-install mysqli

COPY . /var/www/html/

RUN chown -R www-data:www-data /var/www/html

EXPOSE 8080

CMD ["bash", "-c", "rm -f /etc/apache2/mods-enabled/mpm_event.load /etc/apache2/mods-enabled/mpm_event.conf /etc/apache2/mods-enabled/mpm_worker.load /etc/apache2/mods-enabled/mpm_worker.conf; a2enmod mpm_prefork rewrite; apache2ctl -t; sed -i 's/^Listen 80$/Listen 8080/' /etc/apache2/ports.conf; sed -i 's/:80>/:8080>/' /etc/apache2/sites-enabled/000-default.conf; exec apache2-foreground"]
