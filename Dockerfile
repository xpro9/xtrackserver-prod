FROM ubuntu:18.04
RUN  export DEBIAN_FRONTEND=noninteractive
RUN apt update && apt upgrade -y \
&& export DEBIAN_FRONTEND=noninteractive \
&& apt-get install -y tzdata nano \
&& ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime \
&& dpkg-reconfigure --frontend noninteractive tzdata \
&& apt install php-pear php-dev php-cli php-mbstring git php-zip unzip \
 php-curl php-mysql iputils-ping php-imap mysql-client php-gd xlsx2csv mysql-client -y \
&& pecl install mongodb-1.6.1 \
&& echo "extension=mongodb.so" > /etc/php/7.2/mods-available/mongodb.ini \
&& phpenmod mongodb \
&& php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin --filename=composer \
&& chmod +x /usr/local/bin/composer \
&& composer global require hirak/prestissimo

#mailparse time
RUN pecl download mailparse-3.0.3 \
&& tar xvzf mailparse-3.0.3.tgz \
&& cd mailparse-3.0.3 \
&& phpize \
&& ./configure \
&& sed -i 's/^\(#error .* the mbstring extension!\)/\/\/\1/' mailparse.c \
&& make && make install \
&& echo "extension=mailparse.so" > /etc/php/7.2/mods-available/mailparse.ini \
&& phpenmod mailparse

RUN echo "alias pf='clear && ./vendor/bin/phpunit --filter'" >>/root/.bashrc

RUN apt update && apt install -y mysql-client php-gd