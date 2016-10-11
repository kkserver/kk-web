FROM registry.cn-hangzhou.aliyuncs.com/kk/kk-nginx:latest

WORKDIR /

RUN mkdir /lib/lua/conf

VOLUME /lib/lua/conf

RUN echo "TAG:{TAG}" > /VERSION.md

#kk-job
COPY ./kk-job-web/lib/lua/job /lib/lua/job
COPY ./kk-job-web/@app/job /@app/job

