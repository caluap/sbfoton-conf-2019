#!/usr/bin/env bash

if ! which harp > /dev/null; then
	echo "harp command not found!"
	exit 1
fi

cd $(dirname "$0")
cd ..

rm -r dist/*

LOG=$(harp compile . dist 2>&1)
EXIT="$?"

if [ ! -z "$LOG" ]; then
	echo "The compile command issued $(echo "$LOG" | wc -l) message(s)."
	read -p "Print them? (Y/[n]) " choice
	if [ "$choice" = "Y" -o "$choice" = "y" ]; then
		echo "$LOG"
	fi
fi

exit ${EXIT}
