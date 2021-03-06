FROM php:7.2-alpine

COPY --from=composer /usr/bin/composer /usr/bin/composer
RUN apk add --no-cache --virtual build-dependencies g++ make autoconf libpng libjpeg-turbo gmp && \
    apk add -U libpng-dev libjpeg-turbo-dev gmp-dev && \
    docker-php-ext-configure gd --with-png-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install bcmath exif gd gmp pcntl && \
    composer global require hirak/prestissimo && \
    wget -O phpunit https://phar.phpunit.de/phpunit-7.phar && \
    chmod +x phpunit && \
    mv phpunit /usr/local/bin && \
    apk del build-dependencies && \
    rm -rf /tmp/* /src /var/cache/apk/*
