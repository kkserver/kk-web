#/bin/sh

./compressor.sh

PWD=`pwd`

CMD="docker run -p 88:80 -v $PWD/@app:/@app:rw -v $PWD/static:/static:rw registry.cn-hangzhou.aliyuncs.com/kk/kk-nginx"

echo $CMD

$CMD

