FROM php:7.2-alpine

RUN apk add -U --no-cache --virtual build-dependencies g++ make autoconf && \
    pecl install xdebug && \
    docker-php-ext-enable xdebug && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    composer global require hirak/prestissimo && \
    wget -O phpunit https://phar.phpunit.de/phpunit-7.phar && \
    chmod +x phpunit && \
    mv phpunit /usr/local/bin && \
    cd  / && rm -fr /src && \
    apk del build-dependencies && \
    rm -rf /tmp/*
