function showHelp() {
        echo "Available options :"
        echo "-d | --db-name            Database name in postgresql"
        echo "-h | --help               Show help"
}

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
        -d | --db-name )
                shift; db=$1
                ;;
        -h | --help )
		showHelp
                exit 1
                ;;
        * )
                echo "Invalid option $1"
		showHelp
                exit 1
                ;;
esac; shift; done
if [[ "$1" == '--' ]]; then shift; fi

if [[ -z $db ]]; then
        echo "Database can't be empty!"
	showHelp
        exit
fi

echo "Creating database $db"
sudo -i -u postgres psql -U postgres -c "create database $db;"
echo "Database $db has been created"
