#/bin/sh

TAG=`date +%Y%m%d%H%M%S`
WORKDIR=`pwd`


exitCommand() {
	exit $1
}

runCommand() {
	echo $CMD
	$CMD
	if [ $? -ne 0 ]; then
		echo -e "[FAIL] $CMD"
		exitCommand 3
	fi 
}

buildProject() {

	#static compressor

	if [ -d "$HOME/.kk-shell" ]; then
		cd "$HOME/.kk-shell"
		git pull origin master
		cd $WORKDIR
	else
		git clone http://github.com/kkserver/kk-shell $HOME/.kk-shell
		chmod +x $HOME/.kk-shell/web/build.sh
		chmod +x $HOME/.kk-shell/web/view.py
	fi

	CMD="$HOME/.kk-shell/web/build.sh"
	runCommand

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

echo $WORKDIR

#go

PROJECT="registry.cn-hangzhou.aliyuncs.com/kk/kk-web"
buildProject

#exit

echo "[OK] TAG: $TAG"

exitCommand

