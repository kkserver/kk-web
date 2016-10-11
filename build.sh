#/bin/sh

TAG=`date +%Y%m%d%H%M%S`

#kk-job
git clone https://github.com/kkserver/kk-job-web.git
cd kk-job-web
git tag $TAG
git push origin $TAG
cd ..


#docker

cp Dockerfile .Dockerfile

vi -c :%s/{TAG}/$TAG/g -c :wq Dockerfile

docker build -t registry.cn-hangzhou.aliyuncs.com/kk/kk-web:$TAG .

if [ $? -ne 0 ]; then
	exit
fi

rm -f Dockerfile

cp .Dockerfile Dockerfile

docker push registry.cn-hangzhou.aliyuncs.com/kk/kk-web:$TAG

if [ $? -ne 0 ]; then
	exit
fi


#cleanup
rm -rf kk-job-web

echo "[OK] TAG: $TAG"
