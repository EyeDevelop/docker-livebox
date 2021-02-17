FROM alpine:latest
ARG NGINX_VERSION=1.19.7

RUN apk add -U build-base git curl pcre-dev openssl-dev zlib-dev bash shadow ffmpeg
RUN git clone https://github.com/sergey-dryabzhinsky/nginx-rtmp-module /tmp/nginx-rtmp
RUN curl -Lo /tmp/nginx-source.tar.gz "https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz" &&\
    mkdir /tmp/nginx &&\
    tar -xf /tmp/nginx-source.tar.gz -C /tmp/nginx

RUN cd "/tmp/nginx/nginx-$NGINX_VERSION" &&\
    ./configure --with-http_ssl_module --add-module=/tmp/nginx-rtmp &&\
    make -j $(nproc) &&\
    make install

COPY entrypoint.sh /
COPY player/* /var/www/html/
COPY nginx.conf /usr/local/nginx/conf/nginx.conf
CMD ["/entrypoint.sh"]
