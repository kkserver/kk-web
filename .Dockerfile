FROM registry.cn-hangzhou.aliyuncs.com/kk/kk-nginx:latest

WORKDIR /

RUN mkdir /lib/lua/conf

VOLUME /lib/lua/conf

COPY ./static/kk /static/kk

RUN echo "TAG:20161011173656" > /VERSION.md

#kk-job
COPY ./kk-job-web/lib/lua/job /lib/lua/job
COPY ./kk-job-web/@app/job /@app/job

#kk-job
COPY ./kk-job-web/lib/lua/job /lib/lua/job
COPY ./kk-job-web/@app/job /@app/job

#kk-job
COPY ./kk-job-web/lib/lua/job /lib/lua/job
COPY ./kk-job-web/@app/job /@app/job

#kk-job
COPY ./kk-job-web/lib/lua/job /lib/lua/job
COPY ./kk-job-web/@app/job /@app/job

#kk-job
COPY ./kk-job-web/lib/lua/job /lib/lua/job
COPY ./kk-job-web/@app/job /@app/job

#kk-job
COPY ./kk-job-web/lib/lua/job /lib/lua/job
COPY ./kk-job-web/@app/job /@app/job
