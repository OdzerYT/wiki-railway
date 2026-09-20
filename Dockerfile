FROM php:8.3-apache

RUN apt-get update && apt-get install -y \
    libicu-dev \
    ffmpeg \
    git \
    unzip \
    && docker-php-ext-install mysqli intl \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN echo "upload_max_filesize = 20M" > /usr/local/etc/php/conf.d/uploads.ini \
    && echo "post_max_size = 25M" >> /usr/local/etc/php/conf.d/uploads.ini

COPY . /var/www/html/

RUN cd /var/www/html/extensions/TimedMediaHandler \
    && composer install --no-dev --no-interaction

RUN chown -R www-data:www-data /var/www/html

EXPOSE 8080

CMD ["bash", "-c", "rm -f /etc/apache2/mods-enabled/mpm_event.load /etc/apache2/mods-enabled/mpm_event.conf /etc/apache2/mods-enabled/mpm_worker.load /etc/apache2/mods-enabled/mpm_worker.conf; a2dismod mpm_event mpm_worker 2>/dev/null || true; a2enmod mpm_prefork rewrite; sed -i 's/^Listen 80$/Listen 8080/' /etc/apache2/ports.conf; sed -i 's/<VirtualHost \\*:80>/<VirtualHost *:8080>/' /etc/apache2/sites-enabled/000-default.conf; chown -R www-data:www-data /var/www/html/images; apache2ctl -t; exec apache2-foreground"]
