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

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y zsh tmux vim git curl \
    vim vim-runtime htop iotop iptraf iftop python-pip python-dev \
    telnet sysstat php5-common php5-mysql php5-xmlrpc php5-cgi php5-curl \
    php5-gd php5-cli php5-fpm php-apc php-pear php5-dev php5-imap php5-mcrypt tree golang \
    mysql-client libssl-dev

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

# echo '\n# Node.js\nexport PATH="node_modules/.bin:$PATH"' >> /root/.bashrc && \
# echo '\n# Node.js\nexport PATH="node_modules/.bin:$PATH"' >> /root/.zshrc

# Python
RUN pip install pymongo elasticsearch redis

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

ENV PATH node_modules/.bin:$PATH

EXPOSE 22 80 8000 7000 7001 7002 7004
