FROM phusion/baseimage:0.9.16

RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

ENV HOME /root

RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

RUN apt-get update && \
    apt-get install -y vim curl wget build-essential python-software-properties && \
    add-apt-repository -y ppa:nginx/stable && \
    apt-get install -y nginx && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p                 /var/www
ADD docker/nginx.conf        /etc/nginx/nginx.conf
ADD docker/sites             /etc/nginx/sites-enabled
RUN mkdir                    /etc/service/nginx
ADD docker/services/nginx.sh /etc/service/nginx/run
RUN chmod +x                 /etc/service/nginx/run

EXPOSE 80

ADD docker/run.sh /root/run.sh
RUN chmod +x /root/run.sh
CMD ["/root/run.sh"]
