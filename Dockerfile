#
# Dockerfile for opencart
#

FROM php:8.1-apache

RUN a2enmod rewrite headers

RUN apt-get update && \
    apt-get install -y --no-install-recommends git zip libzip-dev

RUN set -xe \
    && apt update \
    && apt install -y libpng-dev libjpeg-dev libwebp-dev unzip \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-jpeg=/usr --with-webp=/usr \
    && docker-php-ext-install gd mysqli pdo_mysql zip

WORKDIR /var/www/html

ENV OPENCART_VER 4.0.0.0
ENV OPENCART_MD5 3e2c2bf12d7d4b6360d4213beac20379
ENV OPENCART_URL https://github.com/opencart/opencart/releases/download/${OPENCART_VER}/opencart-${OPENCART_VER}.zip
ENV OPENCART_FILE opencart.zip

RUN set -xe \
    && curl -sSL ${OPENCART_URL} -o ${OPENCART_FILE} \
    && echo "${OPENCART_MD5}  ${OPENCART_FILE}" | md5sum -c \
    && unzip ${OPENCART_FILE} 'upload/*' -d /var/www/html/ \
    && mv /var/www/html/upload/* /var/www/html/ \
    && rm -r /var/www/html/upload/ \
    && mv config-dist.php config.php \
    && mv admin/config-dist.php admin/config.php \
    && rm ${OPENCART_FILE} \
    && chown -R www-data:www-data /var/www
