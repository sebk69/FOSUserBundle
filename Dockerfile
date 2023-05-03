FROM php:8.1-cli

ARG timezone=Europe/Paris

# Php ini
RUN echo 'memory_limit = 1G' >> /usr/local/etc/php/conf.d/docker-php-ram-limit.ini

# install pcov
RUN pecl install pcov; docker-php-ext-enable pcov;

# Install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=/usr/bin --filename=composer

# Set timezone
RUN cp /usr/share/zoneinfo/$timezone /etc/localtime \
    && echo "$timezone" > /etc/timezone \
    && echo "[Date]\ndate.timezone=$timezone" > /usr/local/etc/php/conf.d/timezone.ini

# Install packages
RUN apt-get update && apt-get install -y sudo wget git vim zip unzip procps && rm -rf /var/lib/apt/lists/*

COPY . /usr/src/fos-user-bundle
WORKDIR /usr/src/fos-user-bundle

ENTRYPOINT sleep infinity