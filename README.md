# README

build
```
docker build -t bilxio/toolbox:0.10 .
docker build -t bilxio/toolbox:0.10-trusty .
```

push
```
docker push bilxio/toolbox:0.10
docker push bilxio/toolbox:0.10-trusty
```

run
```
docker run -d --name toolbox -p 10022:22 -p 10080:80 bilxio/toolbox:0.10
docker run -d --name toolbox -p 10022:22 -p 10080:80 bilxio/toolbox:0.10-trusty
```

test
```
docker run --rm bilxio/toolbox:0.10 which ansible
docker run --rm bilxio/toolbox:0.10 which nginx
```

Linux development env with more tools.

- JDK 1.7
- NodeJS 0.10.46
- Nginx
- php5
- MongoDB
- Redis
- ZSH
- WRK
- Python
- ansible
- tmux
- vim
- git

### add-apt-repo

- ubuntu-precise  `apt-get install python-software-properties`
- ubuntu-trusty  `apt-get install software-properties-common`
