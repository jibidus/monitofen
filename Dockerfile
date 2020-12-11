FROM php:7.4-apache

EXPOSE 80

RUN apt-get update
RUN apt-get -y install wget unzip libonig-dev libxml2-dev libcurl3-dev default-mysql-client
RUN docker-php-ext-install mysqli pdo_mysql mbstring xml curl

RUN mkdir -p /var/www/

COPY okovision/install/099-okovision.conf /etc/apache2/sites-available/.
RUN a2ensite 099-okovision.conf
RUN a2dissite 000-default
