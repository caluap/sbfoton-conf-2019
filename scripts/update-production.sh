#!/usr/bin/env bash

PLATFORM=$(uname)
DIR="$(dirname $(dirname "$0"))/dist/"

if [ ! -z "$1" ]; then
	DIR="$1"
fi
cd "$DIR"

if which md5 > /dev/null; then
	MD5COMM="md5"
elif which md5sum > /dev/null; then
	MD5COMM="md5sum"
else
	echo "Sem comando para processar md5"
	exit 1
fi

for CSSFILE in $(find . -type f -name \*.css); do
	sum=$(cat "$CSSFILE" | "$MD5COMM" )
	sum=${sum:0:12}

	CSSFILENAME=$(basename "$CSSFILE")

	for HTMLFILE in $(find . -type f -name \*.html); do
		SEDSCRIPT="s#$CSSFILENAME(\?[^\"]+)?#$CSSFILENAME?$sum#"
		if [ "$PLATFORM" = "Darwin" ]; then
			sed -i '' -E "$SEDSCRIPT" "$HTMLFILE"
		else
			sed -i -E "$SEDSCRIPT" "$HTMLFILE"
		fi
	done
done

find . -type f -exec chmod 644 {} \;
find . -type d -exec chmod 755 {} \;
rsync -ric -e 'ssh' \
      --exclude=.git \
      --exclude=.idea \
      --exclude=.DS_Store \
      --exclude=Icon \
      --exclude=Icon? \
      --exclude=__MACOSX \
      ./ sbfoton@scala-sans.preface.com.br:sbfoton.org.br/
