# NginX Docker image

This is a basic nginx image which can be useful if you want to run different applications in different docker containers on the same server.

This image is based on [Phusion's Docker Baseimage](phusion.github.io/baseimage-docker).

## Usage

### 1. Clone the project
```console
git clone git@github.com:dhargitai/docker-nginx.git
```

### 2. Configure sites
Place the config files of the certain sites in the `docker/sites` directory.

### 3. Replace the content of `Dockerfile` with:
```console
FROM diatigrah/nginx

ADD docker/nginx.conf /etc/nginx/nginx.conf
ADD docker/sites      /etc/nginx/sites-enabled
ADD docker/run.sh     /root/run.sh
RUN chmod +x          /root/run.sh
```

### 4. Build 'n' run

```console
docker build -t nginx-server .
docker run -d --name nginx nginx-server
```

## Notes

### Running with PHP-FPM
If you want to use another service like php-fpm with this container, you have to:

1. Set it up in the site's config file, in `docker/nginx.conf` and in `docker/run.sh`. This image is preconfigured for PHP-FPM, you can find the proper sections in the files above if you search for `%fpm-ip%` and `php_backend` in them.
2. Rebuild this image.
3. Run the container with the `--link` parameter:
```
docker run -d --name nginx --link php-fpm:FPM nginx-server
```
