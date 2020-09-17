#!/bin/bash

function showHelp() {
	echo "Available options :"
	echo "-f | --file		Go file to run"
	echo "-p | --port		Port to kill"
	echo "-o | --output		Output file for logging"
	echo "-h | --help		Show help"
}

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do
	case $1 in
	-f | --file)
		shift
		file=$1
		;;
	-p | --port)
		shift
		port=$1
		;;
	-o | --output)
		shift
		output=$1
		;;
	-h | --help)
		showHelp
		exit
		;;
	*)
		echo "Invalid option $1"
		showHelp
		exit 1
		;;
	esac
	shift
done
if [[ "$1" == '--' ]]; then shift; fi

if [[ -z $file ]]; then
	echo "File can't be empty!"
	showHelp
	exit
fi

if [[ ! -f $file ]]; then
	echo "$file doesn't exist"
	exit
fi

if [[ -z $port ]]; then
	echo "Port can't be empty!"
	showHelp
	exit
fi

if [[ -z $output ]]; then
	output=output.log
fi

TIMEZONE=$(TZ='Asia/Jakarta' date +"[%d-%m-%Y %H:%M:%S]")
PID=$(sudo lsof -i :$port | awk '{print $2}' | tail -n 1)
kill $PID
go run $file | awk -v time="$TIMEZONE" '{ print time, $0; fflush(); }' >> "$(dirname $0)/$output" &
