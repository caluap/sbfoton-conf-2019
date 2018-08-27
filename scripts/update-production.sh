#!/usr/bin/env bash

PLATFORM=$(uname)
DIR="$(dirname $(dirname "$0"))/dist/"

if [ ! -z "$1" ]; then
	DIR="$1"
fi
cd "$DIR"

if [ ! -f "./css/main.css" ]; then
	echo "Não foi possível encontrar os trecos"
	exit 1;
fi

if which md5 > /dev/null; then
	MD5COMM="md5"
elif which md5sum > /dev/null; then
	MD5COMM="md5sum"
else
	echo "Sem comando para processar md5"
	exit 1
fi

sum=$(cat "css/main.css" | "$MD5COMM" )
sum=${sum:0:12}

#for file in $(find . -name \*.html); do
#	if [ "$PLATFORM" = "Darwin" ]; then
#		sed -i '' -E "s#main.css(\?[^\"]+)?#main.css?$sum#" "$file"
#	else
#		sed -i -E "s#main.css(\?[^\"]+)?#main.css?$sum#" "$file"
#	fi
#done

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
