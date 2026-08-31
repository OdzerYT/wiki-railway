FROM php:8.3-apache

RUN docker-php-ext-install mysqli

RUN a2dismod mpm_event mpm_worker mpm_shared 2>/dev/null || true
RUN a2enmod mpm_prefork rewrite

COPY . /var/www/html/

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
