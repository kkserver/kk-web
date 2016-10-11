#/bin/sh

cleanup() {
	echo "cleanup"
	cp -f .Dockerfile Dockerfile
	rm -f .Dockerfile
	rm -rf kk-job-web
}

TAG=`date +%Y%m%d%H%M%S`

#static compressor

./compressor.sh

cp Dockerfile .Dockerfile

#kk-job
git clone https://github.com/kkserver/kk-job-web.git
cd kk-job-web
git tag $TAG
git push origin $TAG
../compressor.sh
cat AppDockerfile >> ../Dockerfile
cd ..

#docker
docker build -t registry.cn-hangzhou.aliyuncs.com/kk/kk-web:$TAG .

if [ $? -ne 0 ]; then
	cleanup
	exit
fi

docker push registry.cn-hangzhou.aliyuncs.com/kk/kk-web:$TAG

if [ $? -ne 0 ]; then
	cleanup
	exit
fi

#cleanup

cleanup

echo "[OK] TAG: $TAG"


