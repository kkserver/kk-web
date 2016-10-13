FROM registry.cn-hangzhou.aliyuncs.com/kk/kk-nginx:latest

WORKDIR /

RUN mkdir /lib/lua/conf

VOLUME /lib/lua/conf

COPY ./static/kk /static/kk
COPY ./static/ui /static/ui
COPY ./static/lib /static/lib
COPY ./@app/ui /@app/ui
