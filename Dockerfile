FROM php:8.3-apache

RUN docker-php-ext-install mysqli

# Remove ALL enabled MPM configurations
RUN rm -f /etc/apache2/mods-enabled/mpm_event.load \
          /etc/apache2/mods-enabled/mpm_event.conf \
          /etc/apache2/mods-enabled/mpm_worker.load \
          /etc/apache2/mods-enabled/mpm_worker.conf \
          /etc/apache2/mods-enabled/mpm_prefork.load \
          /etc/apache2/mods-enabled/mpm_prefork.conf

# Enable ONLY prefork
RUN ln -s ../mods-available/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.load
RUN ln -s ../mods-available/mpm_prefork.conf /etc/apache2/mods-enabled/mpm_prefork.conf

RUN a2enmod rewrite

# Verify during image build
RUN echo "===== ENABLED MPM FILES =====" && \
    ls -la /etc/apache2/mods-enabled/ | grep mpm && \
    echo "===== APACHE CONFIG TEST =====" && \
    apache2ctl -t

COPY . /var/www/html/

RUN chown -R www-data:www-data /var/www/html

# Railway uses PORT=8080
RUN sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf
RUN sed -i 's/<VirtualHost \*:80>/<VirtualHost *:8080>/' /etc/apache2/sites-enabled/000-default.conf

EXPOSE 8080

CMD ["apache2-foreground"]
