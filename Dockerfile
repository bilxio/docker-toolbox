FROM tutum/ubuntu:precise

MAINTAINER haibxz@gmail.com

ENV NODE_VERSION=0.10.46 MAVEN_VERSION=$MAVEN_VERSION

# ADD repos
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    add-apt-repository -y ppa:webupd8team/java && \
    add-apt-repository -y ppa:nginx/stable && \
    add-apt-repository -y ppa:ansible/ansible

# Install packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y && \
    apt-get install -y zsh tmux vim git curl build-essential software-properties-common \
    vim vim-runtime htop iotop iptraf iftop ansible openssh-server python-pip python-dev \
    ruby ruby-bundler telnet sysstat nginx php5-common php5-mysql php5-xmlrpc php5-cgi php5-curl \
    php5-gd php5-cli php5-fpm php-apc php-pear php5-dev php5-imap php5-mcrypt tree golang \
    mysql-client oracle-java7-installer mongodb-org-shell mongodb-org-tools redis-tools ansible libssl-dev

RUN wget -qO- http://mirror.bit.edu.cn/apache/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xvz -C /opt

# VIM & ZSH
RUN locale-gen en_US.UTF-8
RUN git clone https://github.com/wayfind/polite.git /root/.polite
WORKDIR /root/.polite
RUN ./install
RUN git clone https://github.com/kchmck/vim-coffee-script.git /root/.vim/bundle/vim-coffee-script/
RUN git clone git://github.com/tpope/vim-commentary.git /root/.vim/bundle/vim-commentary/
RUN git clone https://github.com/fatih/vim-go.git /root/.vim/bundle/vim-go/
RUN git clone https://github.com/carlosvillu/coffeScript-VIM-Snippets.git /tmp/snippets
RUN git clone git://github.com/mustache/vim-mustache-handlebars.git /root/.vim/bundle/mustache/
RUN git clone git://github.com/wavded/vim-stylus.git /root/.vim/bundle/vim-stylus/
RUN git clone https://github.com/groenewege/vim-less /root/.vim/bundle/vim-less/
RUN git clone https://github.com/AndrewRadev/vim-eco.git /root/.vim/bundle/vim-eco/
RUN mv /tmp/snippets/snippets/coffee.snippets /root/.vim/bundle/snipmate/snippets/
RUN git submodule add https://github.com/groenewege/vim-less.git vimfiles/bundle/vim-less
RUN git submodule add https://github.com/cakebaker/scss-syntax.vim.git vimfiles/bundle/scss-syntax
RUN git submodule init
ADD vimrc /root/.vimrc

RUN git clone git://github.com/robbyrussell/oh-my-zsh.git /root/.oh-my-zsh
RUN chsh -s /usr/bin/zsh
ADD zshrc /root/.zshrc

# Install Node.js
RUN \
  cd /tmp && \
  wget http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.gz && \
  tar xvzf node-v$NODE_VERSION.tar.gz && \
  rm -f node-v$NODE_VERSION.tar.gz && \
  cd node-v* && \
  ./configure && \
  CXX="g++ -Wno-unused-local-typedefs" make && \
  CXX="g++ -Wno-unused-local-typedefs" make install && \
  cd /tmp && \
  rm -rf /tmp/node-v* && \
  echo '\n# Node.js\nexport PATH="node_modules/.bin:$PATH"' >> /root/.bashrc && \
  echo '\n# Node.js\nexport PATH="node_modules/.bin:$PATH"' >> /root/.zshrc

RUN npm install -g coffee-script grunt-cli bower coffeelint brunch gulp browserify jshint jsonlint nodemon bunyan semver jasmine-node mocha
RUN npm install -g pm2 node-inspector

# Python
RUN pip install pymongo elasticsearch redis

# PHP
RUN sed -ri 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php5/fpm/php.ini
RUN sed -ri 's/display_errors = Off/display_errors = On/g' /etc/php5/fpm/php.ini

# Nginx
ADD default_vhost /etc/nginx/sites-available/default
RUN sed -ri 's/worker_processes 4;/worker_processes 1;/g' /etc/nginx/nginx.conf

# WRK
RUN git clone https://github.com/wg/wrk.git /tmp/wrk
WORKDIR /tmp/wrk
RUN make
RUN mv /tmp/wrk/wrk /usr/bin/wrk

# cleanup
RUN rm -rf /tmp/* /var/lib/apt/lists/*

VOLUME ["/srv", "/data", "/tmp", "/var/www"]
WORKDIR /data

ENV PATH /opt/apache-maven-$MAVEN_VERSION/bin:node_modules/.bin:$PATH

CMD ["zsh"]

EXPOSE 22 80 8000 7000 7001 7002 7004
