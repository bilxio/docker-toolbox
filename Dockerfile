FROM bilxio/node:0.10-dev

MAINTAINER haibxz@gmail.com

# Install Coffee
RUN npm install -g coffee-script

RUN apt-get install python-software-properties -y

# Install packages
RUN DEBIAN_FRONTEND=noninteractive apt-get install python-software-properties -y && \
    apt-add-repository -y ppa:ansible/ansible && \
    add-apt-repository -y ppa:nginx/stable && \
    add-apt-repository -y ppa:rwky/redis

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y nginx ansible redis-server

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tmux git \
    htop iotop iptraf iftop python-pip python-dev \
    telnet sysstat php5-common php5-mysql php5-xmlrpc php5-cgi php5-curl \
    php5-gd php5-cli php5-fpm php-apc php-pear php5-dev php5-imap php5-mcrypt tree golang \
    mysql-client libssl-dev

# PHP
RUN sed -ri 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php5/fpm/php.ini
RUN sed -ri 's/display_errors = Off/display_errors = On/g' /etc/php5/fpm/php.ini

# Nginx
ADD default_vhost /etc/nginx/sites-available/default
RUN sed -ri 's/worker_processes 4;/worker_processes 1;/g' /etc/nginx/nginx.conf

# cleanup
RUN rm -rf /tmp/* /var/lib/apt/lists/*

RUN service start nginx
RUN chkconfig service nginx on

VOLUME ["/srv", "/data", "/tmp", "/var/www"]
WORKDIR /data

EXPOSE 80
