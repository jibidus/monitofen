FROM php:7.4-apache

EXPOSE 80

RUN apt-get update
RUN apt-get -y install wget unzip libonig-dev libxml2-dev libcurl3-dev
RUN docker-php-ext-install pdo_mysql mbstring xml curl

RUN wget https://github.com/stawen/okovision/archive/master.zip
RUN unzip master.zip -d /var/www/
RUN rm master.zip
RUN mv /var/www/okovision-master/ /var/www/okovision/
RUN chown www-data:www-data -R /var/www/okovision/

RUN cp /var/www/okovision/install/099-okovision.conf /etc/apache2/sites-available/.
RUN a2ensite 099-okovision.conf
RUN a2dissite 000-default

COPY vhost.conf /etc/apache2/sites-available/000-default.conf