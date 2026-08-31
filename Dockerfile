FROM php:8.3-apache

RUN docker-php-ext-install mysqli

RUN echo "===== MPM CONFIG =====" && \
    ls -la /etc/apache2/mods-enabled/ | grep mpm || true

RUN echo "===== LOADED MPM =====" && \
    apache2ctl -M 2>&1 | grep mpm || true

RUN a2enmod rewrite

COPY . /var/www/html/

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

CMD ["apache2-foreground"]

# RAILWAY TEST 6031e12f
