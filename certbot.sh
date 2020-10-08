#!/bin/bash

function showHelp() {
        echo "Available options :"
        echo "-f | --file               File contains list of domain separated by new line"
        echo "-h | --help               Show help"
}

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
        -f | --file )
                shift; file=$1
                ;;
        -h | --help )
                showHelp
                exit
                ;;
        * )
                echo "Invalid option $1"
                showHelp
                exit 1
                ;;
esac; shift; done
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


getArray() {
    array=()
    while IFS= read -r line
    do
        array+=("$line")
    done < "$1"
}

getArray $file

command="sudo certbot"

for e in "${array[@]}"
do
    command+=" -d $e -d *.$e"
done

command+=" --manual --preferred-challenges dns certonly"

# Run the command
$command
