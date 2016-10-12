#/bin/sh

#static compressor

DEBUG=1

./compressor.sh

#docker
echo "docker build -t registry.cn-hangzhou.aliyuncs.com/kk/kk-web:debug ."

docker build -t registry.cn-hangzhou.aliyuncs.com/kk/kk-web:debug .

