FROM phusion/baseimage:0.9.18

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key E5267A6C && \
    apt-get update && \
    apt-get install --assume-yes python-software-properties

# Install packages
RUN apt-get install --assume-yes --fix-missing \
        build-essential zlib1g-dev libpcre3 libpcre3-dev libssl-dev unzip \
        nginx \
        curl \
        wget \
        vim

RUN cd && \
    wget https://github.com/pagespeed/ngx_pagespeed/archive/release-1.10.33.4-beta.zip && \
    unzip release-1.10.33.4-beta.zip
RUN cd && cd ngx_pagespeed-release-1.10.33.4-beta/ && \
    wget https://dl.google.com/dl/page-speed/psol/1.10.33.4.tar.gz && \
    tar -xzvf 1.10.33.4.tar.gz
RUN cd && \
    wget http://nginx.org/download/nginx-1.8.0.tar.gz && \
    tar -xvzf nginx-1.8.0.tar.gz
RUN cd && cd nginx-1.8.0/ && ./configure \
      --add-module=$HOME/ngx_pagespeed-release-1.10.33.4-beta \
      --without-http_autoindex_module \
      --with-http_ssl_module \
      --with-http_gzip_static_module \
      --with-http_gunzip_module \
      --without-http_browser_module \
      --without-http_limit_req_module \
      --without-http_limit_conn_module \
      --without-http_memcached_module \
      --without-http_referer_module \
      --without-http_scgi_module \
      --without-http_split_clients_module \
      --without-http_ssi_module \
      --without-http_userid_module \
      --without-http_uwsgi_module && \
    make && make install && make clean

RUN apt-get autoremove --assume-yes && \
    apt-get remove --assume-yes build-essential zlib1g-dev libpcre3-dev libssl-dev unzip
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN cd && \
    rm -rf nginx-1.8.0* ngx_pagespeed-release-1.10.33.4-beta release-1.10.33.4-beta.zip
RUN mkdir -p /var/cache/ngx_pagespeed/
RUN chown -R root:www-data /var/cache/ngx_pagespeed
RUN chmod -R ug+rw /var/cache/ngx_pagespeed

RUN echo "Package: nginx \
Pin: version 1.8.0-pagespeed \
Pin-Priority: 1001" > /etc/apt/preferences.d/nginx

# Add nginx
RUN mkdir -p /etc/nginx
RUN mkdir -p /etc/service/nginx
RUN mkdir -p /var/lib/nginx/cache
RUN chown www-data /var/lib/nginx/cache
RUN chmod 700 /var/lib/nginx/cache
RUN rm -rf /usr/sbin/nginx && ln -s /usr/local/nginx/sbin/nginx /usr/sbin/

ADD docker/run.sh /root/run.sh
ADD docker/.vimrc /root/.vimrc
ADD docker/sites /etc/nginx/sites-enabled
ADD docker/nginx.conf /etc/nginx/nginx.conf
ADD docker/gzip_params /etc/nginx/gzip_params
ADD docker/proxy_params /etc/nginx/proxy_params
ADD docker/pagespeed_params /etc/nginx/pagespeed_params
ADD docker/services/nginx.sh /etc/service/nginx/run

RUN chmod +x /root/run.sh
RUN chmod +x /etc/service/nginx/run

WORKDIR /etc/nginx

EXPOSE 80

CMD ["/root/run.sh"]