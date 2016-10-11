#/bin/sh

#static compressor

for map in `find ./static -name "*.js.map"`; do

	echo "compressor $map ..."

	dir=${map%/*}

	min=${map%.map}

	echo "" > "$min.tmp"

	for js in `cat $map`; do

		cat "$dir/$js" >> "$min.tmp"

	done

	java -jar ./yuicompressor.jar --charset utf-8 --type js -o "$min" "$min.tmp"

	rm -f "$min.tmp"

	echo "compressor $map to $min"

done

for map in `find ./static -name "*.css.map"`; do

	echo "compressor $map ..."

	dir=${map%/*}

	min=${map%.map}

	echo "" > "$min.tmp"

	for js in `cat $map`; do

		cat "$dir/$js" >> "$min.tmp"

	done

	java -jar ./yuicompressor.jar --charset utf-8 --type css -o "$min" "$min.tmp"

	rm -f "$min.tmp"
	
	echo "compressor $map to $min"
	
done
