FROM php:8.3-apache

RUN docker-php-ext-install mysqli

RUN rm -f /etc/apache2/mods-enabled/mpm_event.load \
          /etc/apache2/mods-enabled/mpm_event.conf \
          /etc/apache2/mods-enabled/mpm_worker.load \
          /etc/apache2/mods-enabled/mpm_worker.conf \
          /etc/apache2/mods-enabled/mpm_prefork.load \
          /etc/apache2/mods-enabled/mpm_prefork.conf

RUN ln -s ../mods-available/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.load
RUN ln -s ../mods-available/mpm_prefork.conf /etc/apache2/mods-enabled/mpm_prefork.conf

RUN a2enmod rewrite

RUN echo "===== BUILD MPM =====" && \
    ls -la /etc/apache2/mods-enabled/ | grep mpm && \
    apache2ctl -t

COPY . /var/www/html/

RUN chown -R www-data:www-data /var/www/html

RUN sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf
RUN sed -i 's/<VirtualHost \*:80>/<VirtualHost *:8080>/' /etc/apache2/sites-enabled/000-default.conf

EXPOSE 8080

CMD ["sh", "-c", "echo '===== RUNTIME FILES ====='; ls -la /etc/apache2/mods-enabled/ | grep mpm || true; echo '===== RUNTIME CONFIG ====='; apache2ctl -t; echo '===== STARTING ====='; sleep infinity"]
