FROM php:8.3-apache

RUN docker-php-ext-install mysqli

RUN echo "===== APACHE MPM MODULES =====" && \
    ls -la /etc/apache2/mods-enabled/mpm* 2>/dev/null || true && \
    echo "===== APACHE MODULE LIST =====" && \
    apache2ctl -M 2>&1 | grep mpm || true

RUN a2dismod mpm_event mpm_worker mpm_prefork || true
RUN rm -f /etc/apache2/mods-enabled/mpm_*.load
RUN rm -f /etc/apache2/mods-enabled/mpm_*.conf
RUN a2enmod mpm_prefork rewrite

RUN echo "===== MPM AFTER FIX =====" && \
    ls -la /etc/apache2/mods-enabled/mpm* 2>/dev/null || true && \
    apache2ctl -M 2>&1 | grep mpm || true

COPY . /var/www/html/
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# force rebuild

# force rebuild
