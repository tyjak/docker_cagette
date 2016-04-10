FROM phusion/baseimage
MAINTAINER David Foucher

# Dependencies
RUN add-apt-repository ppa:haxe/releases -y
RUN apt-get update
RUN apt-get install -y haxe wget curl mysql-client imagemagick apache2 libapache2-mod-neko

RUN a2enmod neko
RUN a2enmod rewrite

RUN su -l www-data -s /bin/bash && \
    mkdir /var/www/cagette && \
    cd /var/www/cagette && \
    wget http://www.cagette.net/cagette.tar && \
    tar -xvf cagette.tar

ADD config.xml.dist /var/www/cagette/config.xml
ADD cagette.conf /etc/apache2/conf-available/cagette.conf
ADD cagette-site.conf /etc/apache2/sites-available/cagette.conf
RUN a2dissite 000-default.conf && \
    a2enconf cagette && \
    a2ensite cagette && \
    service apache2 start

