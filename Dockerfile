FROM php:8.1-apache

# Install composer, bash and git
RUN apt-get update && apt-get install -y \
    bash \
    git \
    zip \
    unzip \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install PHP extensions (gd, pdo_mysql, zip, sodium, opcache)
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    libsodium-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
    gd \
    pdo_mysql \
    zip \
    sodium \
    opcache

# Install PHP extensions (intl)
RUN apt-get update && apt-get install -y \
    libicu-dev \
    && docker-php-ext-install \
    intl

# Default Apache config to /var/www/html/drupal
ENV APACHE_DOCUMENT_ROOT /var/www/html/drupal/web
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Run Apache
CMD ["apache2-foreground"]
