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

		java -jar $HOME/yuicompressor.jar --charset utf-8 --type js -o "$min" "$min.tmp"

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

		java -jar $HOME/yuicompressor.jar --charset utf-8 --type css -o "$min" "$min.tmp"

		rm -f "$min.tmp"
		
		echo "compressor $map to $min"
		
	done

fi

#compressor html

if [ -d "./@app" ]; then

	for map in `find ./@app -name "*.html.view"`; do

		echo "compressor $map ..."

		go run $HOME/compressor.go -home "$HOME/@app" -o "${map%.view}" -i "$map"
		
		echo "compressor $map to ${map%.view}"
		
	done

fi

