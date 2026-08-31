FROM php:8.3-apache

RUN docker-php-ext-install mysqli

RUN a2enmod rewrite

COPY . /var/www/html/

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

CMD ["bash", "-c", "echo '===== RUNTIME MPM FILES ====='; ls -la /etc/apache2/mods-enabled/ | grep mpm || true; echo '===== RUNTIME MPM MODULES ====='; apache2ctl -M 2>&1 | grep mpm || true; echo '===== APACHE CONFIG TEST ====='; apache2ctl -t 2>&1; echo '===== ALL ENABLED MODULES ====='; ls -la /etc/apache2/mods-enabled/; echo '===== STARTING APACHE ====='; exec apache2-foreground"]
