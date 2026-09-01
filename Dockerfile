FROM php:8.3-apache

RUN docker-php-ext-install mysqli

COPY . /var/www/html/

RUN chown -R www-data:www-data /var/www/html

EXPOSE 8080

CMD ["bash", "-c", "rm -f /etc/apache2/mods-enabled/mpm_event.load /etc/apache2/mods-enabled/mpm_event.conf /etc/apache2/mods-enabled/mpm_worker.load /etc/apache2/mods-enabled/mpm_worker.conf /etc/apache2/mods-enabled/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.conf; ln -s ../mods-available/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.load; ln -s ../mods-available/mpm_prefork.conf /etc/apache2/mods-enabled/mpm_prefork.conf; a2enmod rewrite; sed -i 's/^Listen 80$/Listen 8080/' /etc/apache2/ports.conf; sed -i 's/<VirtualHost \\*:80>/<VirtualHost *:8080>/' /etc/apache2/sites-enabled/000-default.conf; echo '===== FINAL APACHE CONFIG ====='; ls -la /etc/apache2/mods-enabled/ | grep mpm; apache2ctl -t; echo '===== STARTING APACHE ====='; exec apache2-foreground"]
