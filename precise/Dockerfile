FROM bilxio/node:0.10-dev

MAINTAINER haibxz@gmail.com

# Install Coffee
RUN npm install -g coffee-script

# Install packages
RUN DEBIAN_FRONTEND=noninteractive apt-get install python-software-properties -y && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-add-repository -y ppa:nginx/stable && \
    apt-add-repository -y ppa:rwky/redis

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y nginx ansible redis-server git mysql-client libssl-dev

# Nginx
ADD default_vhost /etc/nginx/sites-available/default
RUN sed -ri 's/worker_processes 4;/worker_processes 1;/g' /etc/nginx/nginx.conf

# cleanup
RUN rm -rf /tmp/* /var/lib/apt/lists/*

VOLUME ["/srv", "/data", "/tmp", "/var/www"]
WORKDIR /data

EXPOSE 80
