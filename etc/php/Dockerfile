# avil/php-8.2:4

FROM php:8.2-fpm

# Start as root
USER root

LABEL maintainer="AVIL <a.1.3@mail.ru>"

COPY ./php.ini /usr/local/etc/php/conf.d/php.ini
COPY ./other/bashrc /root/.bashrc
COPY ./other/inputrc /root/.inputrc
COPY ./other/composer-setup.sh /root/composer-setup.sh

RUN apt-get update && apt-get upgrade -y \
  && apt-get install -y \
  vim \
  wget \
  g++ \
  libbz2-dev \
  libc-client-dev \
  libcurl4-gnutls-dev \
  libedit-dev \
  libfreetype6-dev \
  libicu-dev \
  libjpeg62-turbo-dev \
  libkrb5-dev \
  libldap2-dev \
  libldb-dev \
  libmagickwand-dev \
  libmcrypt-dev \
  libmemcached-dev \
  libpng-dev \
  libpq-dev \
  libsqlite3-dev \
  libssl-dev \
  libreadline-dev \
  libxslt1-dev \
  libzip-dev \
  memcached \
  wget \
  unzip \
  zlib1g-dev \
  && docker-php-ext-install -j$(nproc) \
  bcmath \
  bz2 \
  calendar \
  exif \
  gettext \
  mysqli \
  opcache \
  pdo_mysql \
  pdo_pgsql \
  pgsql \
  soap \
  sockets \
  xsl\
  && docker-php-ext-configure gd --with-freetype --with-jpeg \
  && docker-php-ext-install -j$(nproc) gd \
  && PHP_OPENSSL=yes docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
  && docker-php-ext-install -j$(nproc) imap \
  && docker-php-ext-configure intl \
  && docker-php-ext-install -j$(nproc) intl \
  && docker-php-ext-configure ldap \
  && docker-php-ext-install ldap \
  && docker-php-ext-configure zip \
  && docker-php-ext-install zip \
  && pecl install xdebug && docker-php-ext-enable xdebug \
  && pecl install memcached && docker-php-ext-enable memcached \
  && pecl install redis && docker-php-ext-enable redis \
  && yes '' | pecl install imagick && docker-php-ext-enable imagick \
  && docker-php-source delete \
  && apt-get remove -y g++ \
  && apt-get autoremove --purge -y && apt-get autoclean -y && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/* /var/tmp/*
# install composer
RUN cd /root/ && \
  sh ./composer-setup.sh && \
  chmod +x composer.phar && \
  mv /root/composer.phar /bin/composer && \
  rm /root/composer-setup.sh


# Set default work directory
WORKDIR /var/www
