FROM alpine AS sqlite
RUN apk add --no-cache --virtual build-dependencies g++ make autoconf && \
    wget https://www.sqlite.org/2018/sqlite-autoconf-3240000.tar.gz && \
    tar zxvf sqlite-autoconf-3240000.tar.gz && \
    cd sqlite-autoconf-3240000 && \
    ./configure --prefix=/usr --enable-json1 && \
    make && \
    make install

FROM php:7.2-alpine

COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY --from=sqlite /usr/bin/sqlite3 /usr/bin/sqlite3

RUN apk add --no-cache --virtual build-dependencies g++ make autoconf libpng libjpeg-turbo && \
    apk add -U libpng-dev libjpeg-turbo-dev && \
    pecl install xdebug && \
    docker-php-ext-enable xdebug && \
    docker-php-ext-configure gd --with-png-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install gd exif pcntl && \
    composer global require hirak/prestissimo && \
    wget -O phpunit https://phar.phpunit.de/phpunit-7.phar && \
    chmod +x phpunit && \
    mv phpunit /usr/local/bin && \
    apk del build-dependencies && \
    rm -rf /tmp/* /src /var/cache/apk/*
