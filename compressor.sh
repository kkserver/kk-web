#/bin/sh

#compressor js

PWD=`pwd`
HOME=$PWD

if [ -d "./static" ]; then

  	for map in `find ./static -name "*.js.map"`; do

		echo "compressor $map ..."

		dir=${map%/*}

		min=${map%.map}

		echo "" > "$min.tmp"

		for js in `cat $map`; do

			cat "$dir/$js" >> "$min.tmp"
			echo -e "\n" >> "$min.tmp"

		done

		if $DEBUG; then
			cp "$min.tmp" "$min"
		else
			java -jar $HOME/yuicompressor.jar --charset utf-8 --type js -o "$min" "$min.tmp"
		fi

		rm -f "$min.tmp"

		echo "compressor $map to $min"

	done

fi



#compressor css

if [ -d "./static" ]; then

	for map in `find ./static -name "*.css.map"`; do

		echo "compressor $map ..."

		dir=${map%/*}

		min=${map%.map}

		echo "" > "$min.tmp"

		for js in `cat $map`; do

			cat "$dir/$js" >> "$min.tmp"
			echo -e "\n" >> "$min.tmp"

		done

		if $DEBUG; then
			cp "$min.tmp" "$min"
		else
			java -jar $HOME/yuicompressor.jar --charset utf-8 --type css -o "$min" "$min.tmp"
		fi

		rm -f "$min.tmp"
		
		echo "compressor $map to $min"
		
	done

fi

#compressor html

if [ -d "./@app" ]; then

	for map in `find ./@app -name "*.view.html"`; do

		echo "compressor $map ..."

		rm -f "${map%.view.html}.html"
		
		go run $HOME/compressor.go -home "$HOME/@app" -o "${map%.view.html}.html" -i "$map"
		
		if [ $? -ne 0 ]; then
			echo -e "go run $HOME/compressor.go -home \"$HOME/@app\" -o \"${map%.view.html}.html\" -i \"$map\""
			exit 3
		fi

		echo "compressor $map to ${map%.view.html}.html"
		
	done

fi

