FROM registry.cn-hangzhou.aliyuncs.com/kk/kk-nginx:latest

WORKDIR /

RUN mkdir /lib/lua/conf

VOLUME /lib/lua/conf

COPY ./static/kk /static/kk
COPY ./static/ui /static/ui
COPY ./@app/index.html /@app/index.html
