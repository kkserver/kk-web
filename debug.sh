#/bin/sh

#static compressor

export DEBUG=1

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
CMD="docker build -t registry.cn-hangzhou.aliyuncs.com/kk/kk-web:debug ."
runCommand

CMD="docker run -p 8080:80 registry.cn-hangzhou.aliyuncs.com/kk/kk-web:debug"
runCommand
