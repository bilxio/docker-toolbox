FROM bilxio/node:0.10-trusty

MAINTAINER haibxz@gmail.com

# Install Coffee
RUN npm install -g coffee-script

# use linode Tokoyo mirror
COPY ./sources.list /etc/apt/sources.list

# Install packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install software-properties-common -y && \
    add-apt-repository -y ppa:ansible/ansible && \
    add-apt-repository -y ppa:nginx/stable && \
    add-apt-repository -y ppa:rwky/redis

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y nginx ansible && \
    build-essential tmux vim redis-server git mysql-client libssl-dev

# Nginx
ADD default_vhost /etc/nginx/sites-available/default
RUN sed -ri 's/worker_processes 4;/worker_processes 1;/g' /etc/nginx/nginx.conf

# cleanup
RUN rm -rf /tmp/* /var/lib/apt/lists/*

VOLUME ["/srv", "/data", "/tmp", "/var/www"]
WORKDIR /data

EXPOSE 80
