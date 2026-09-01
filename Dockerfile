FROM php:8.3-apache

RUN docker-php-ext-install mysqli

RUN a2dismod mpm_event
RUN a2enmod mpm_prefork rewrite

COPY . /var/www/html/

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

CMD ["bash", "-c", "echo '===== MPM FILES ====='; ls -la /etc/apache2/mods-enabled/ | grep mpm || true; echo '===== APACHE MPM ====='; apache2ctl -M 2>&1 | grep mpm || true; echo '===== APACHE CONFIG TEST ====='; apache2ctl -t 2>&1; echo '===== ENV ====='; env | sort; echo '===== KEEPING CONTAINER ALIVE ====='; sleep infinity"]
