FROM alpine:3.4

MAINTAINER hailongz "hailongz@qq.com"

RUN echo "Asia/shanghai" >> /etc/timezone

ENV NGINX_VERSION 1.10.1-r1

RUN apk add --update nginx-lua=$NGINX_VERSION bash && \
    rm -rf /var/cache/apk/* 

RUN ln -sf /dev/stdout /var/log/nginx/access.log

RUN ln -sf /dev/stderr /var/log/nginx/error.log

RUN ls /var/log/nginx

RUN mkdir /run/nginx

WORKDIR /etc/nginx

COPY ./conf.d conf.d

COPY ./lib/lua /lib/lua

COPY ./nginx.conf nginx.conf

COPY ./@app /@app

COPY ./static /static

VOLUME /etc/nginx/conf.d

VOLUME /lib/lua/conf

WORKDIR /

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]

