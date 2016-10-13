#/bin/sh

TAG=`date +%Y%m%d%H%M%S`
PWD=`pwd`


exitCommand() {
	cp -f .Dockerfile Dockerfile
	rm -f .Dockerfile
	rm -rf kk-job-web
	exit
}

runCommand() {
	echo $CMD
	$CMD
	if [ $? -ne 0 ]; then
		echo -e "[FAIL] $CMD"
		exitCommand
	fi 
}

buildProject() {

	#static compressor

	./compressor.sh

	cp -f Dockerfile .Dockerfile

	#kk-job
	git clone https://github.com/kkserver/kk-job-web.git
	cd kk-job-web
	git tag $TAG
	git push origin $TAG
	../compressor.sh
	cat AppDockerfile >> ../Dockerfile
	cd ..

	#docker
	CMD="docker build -t $PROJECT:$TAG ."
	runCommand

	CMD="docker push $PROJECT:$TAG"
	runCommand

	CMD="docker tag $PROJECT:$TAG $PROJECT:latest"
	runCommand

	CMD="docker push $PROJECT:latest"
	runCommand

}

echo $PWD

#go

PROJECT="registry.cn-hangzhou.aliyuncs.com/kk/kk-web"
buildProject

#exit

echo "[OK] TAG: $TAG"

exitCommand

