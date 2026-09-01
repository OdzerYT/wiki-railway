FROM php:8.3-apache

RUN docker-php-ext-install mysqli

COPY . /var/www/html/

RUN chown -R www-data:www-data /var/www/html

EXPOSE 8080

CMD ["bash", "-c", "rm -f /etc/apache2/mods-enabled/mpm_event.load /etc/apache2/mods-enabled/mpm_event.conf /etc/apache2/mods-enabled/mpm_worker.load /etc/apache2/mods-enabled/mpm_worker.conf; a2dismod mpm_event mpm_worker 2>/dev/null || true; a2enmod mpm_prefork rewrite; sed -i 's/^Listen 80$/Listen 8080/' /etc/apache2/ports.conf; sed -i 's/<VirtualHost \\*:80>/<VirtualHost *:8080>/' /etc/apache2/sites-enabled/000-default.conf; echo '===== PORT ENV ====='; echo PORT=$PORT; echo '===== PORTS CONFIG ====='; cat /etc/apache2/ports.conf; echo '===== VHOST CONFIG ====='; grep -R 'VirtualHost' /etc/apache2/sites-enabled/; echo '===== MPM ====='; ls -la /etc/apache2/mods-enabled/ | grep mpm; echo '===== CONFIG TEST ====='; apache2ctl -t; echo '===== LISTENING BEFORE START ====='; ss -lntp || true; echo '===== STARTING APACHE ====='; exec apache2-foreground"]
