FROM drupal:9.0-apache

RUN apt-get update && apt-get install -y \
    git \
    imagemagick \
    libmagickwand-dev \
    mariadb-client \
    rsync \
    sudo \
    unzip \
    vim \
    wget \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pdo \
    && docker-php-ext-install pdo_mysql
# Remove the memory limit for the CLI only.
RUN echo 'memory_limit = -1' > /usr/local/etc/php/php-cli.ini

# Remove the vanilla Drupal project that comes with this image.
RUN rm -rf ..?* .[!.]* *

# Put a turbo on composer.
RUN composer global require hirak/prestissimo

# Install XDebug.
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

# Install Robo CI.
RUN wget https://robo.li/robo.phar
RUN chmod +x robo.phar && mv robo.phar /usr/local/bin/robo

# Install ImageMagic to take screenshots.
RUN pecl install imagick \
    && docker-php-ext-enable imagick

# Install Chrome browser.
RUN apt-get install --yes gnupg2 apt-transport-https
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
RUN sh -c 'echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
RUN apt-get update
RUN apt-get install --yes google-chrome-unstable