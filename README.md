# h2o.docker
docker files for h2o http2 webserver, see https://h2o.examp1e.net/

[![](https://badge.imagelayers.io/lkwg82/h2o-http2-server:latest.svg)](https://imagelayers.io/?images=lkwg82%2Fh2o-http2-server:latest)
[![](https://img.shields.io/docker/stars/lkwg82/h2o-http2-server.svg)](https://hub.docker.com/r/lkwg82/h2o-http2-server/)
[![](https://img.shields.io/docker/pulls/lkwg82/h2o-http2-server.svg)](https://hub.docker.com/r/lkwg82/h2o-http2-server/)

- ```latest``` (*[master/Dockerfile](https://github.com/lkwg82/h2o.docker/blob/master/Dockerfile)*)

version specific tags below

---

simplest run
```bash
docker run -p "8080:80" -ti lkwg82/h2o-http2-server
```
test with 
```bash
$ curl http://localhost:8080/
not found
```

A short tutorial can be found on https://blog.lgohlke.de/docker/h2o/2016/03/01/dockerized-h2o-webserver.html

---

automatically ...

 - checks for new releases 
 - create new tags with changed Dockerfile
 - pushes the tags
 
```bash
./check_releases.sh
```

in crontab
```bash
12 23 * * * bash -c 'cd ~/h2o.docker; git pull; ./check_releases.sh'
```

---

*Tags*

- ```v1.4.0``` (*[v1.4.0/Dockerfile](https://github.com/lkwg82/h2o.docker/blob/v1.4.0/Dockerfile)*)
- ```v1.4.1``` (*[v1.4.1/Dockerfile](https://github.com/lkwg82/h2o.docker/blob/v1.4.1/Dockerfile)*)
- ```v1.4.2``` (*[v1.4.2/Dockerfile](https://github.com/lkwg82/h2o.docker/blob/v1.4.2/Dockerfile)*)
- ```v1.4.3``` (*[v1.4.3/Dockerfile](https://github.com/lkwg82/h2o.docker/blob/v1.4.3/Dockerfile)*)
- ```v1.4.4``` (*[v1.4.4/Dockerfile](https://github.com/lkwg82/h2o.docker/blob/v1.4.4/Dockerfile)*)
- ```v1.4.5``` (*[v1.4.5/Dockerfile](https://github.com/lkwg82/h2o.docker/blob/v1.4.5/Dockerfile)*)
- ```v1.5.0``` (*[v1.5.0/Dockerfile](https://github.com/lkwg82/h2o.docker/blob/v1.5.0/Dockerfile)*)
- ```v1.5.1``` (*[v1.5.1/Dockerfile](https://github.com/lkwg82/h2o.docker/blob/v1.5.1/Dockerfile)*)
- ```v1.5.2``` (*[v1.5.2/Dockerfile](https://github.com/lkwg82/h2o.docker/blob/v1.5.2/Dockerfile)*)
- ```v1.5.3``` (*[v1.5.3/Dockerfile](https://github.com/lkwg82/h2o.docker/blob/v1.5.3/Dockerfile)*)
- ```v1.5.4``` (*[v1.5.4/Dockerfile](https://github.com/lkwg82/h2o.docker/blob/v1.5.4/Dockerfile)*)
- ```v1.6.0``` (*[v1.6.0/Dockerfile](https://github.com/lkwg82/h2o.docker/blob/v1.6.0/Dockerfile)*)
- ```v1.6.1``` (*[v1.6.1/Dockerfile](https://github.com/lkwg82/h2o.docker/blob/v1.6.1/Dockerfile)*)
- ```v1.6.2``` (*[v1.6.2/Dockerfile](https://github.com/lkwg82/h2o.docker/blob/v1.6.2/Dockerfile)*)
- ```v1.6.3``` (*[v1.6.3/Dockerfile](https://github.com/lkwg82/h2o.docker/blob/v1.6.3/Dockerfile)*)
- ```v1.7.0``` (*[v1.7.0/Dockerfile](https://github.com/lkwg82/h2o.docker/blob/v1.7.0/Dockerfile)*)
- ```v1.7.1``` (*[v1.7.1/Dockerfile](https://github.com/lkwg82/h2o.docker/blob/v1.7.1/Dockerfile)*)
- ```v2.0.0-beta1``` (*[v2.0.0-beta1/Dockerfile](https://github.com/lkwg82/h2o.docker/blob/v2.0.0-beta1/Dockerfile)*)
