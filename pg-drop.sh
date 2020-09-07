function showHelp() {
	echo "Available options :"
	echo "-d | --db-name            Database name in postgresql"
	echo "-s | --schema             Schama name in postgresql"
	echo "-h | --help               Show help"
}

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do
	case $1 in
	-d | --db-name)
		shift
		db=$1
		;;
	-s | --schema)
		shift
		schema=$1
		;;
	-h | --help)
		echo "Available option:"
		showHelp
		exit 1
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

if [[ -z $db ]]; then
	echo "Database can't be empty!"
	showHelp
	exit
fi

if [[ ! -z $db && ! -z $schema ]]; then
	echo "Dropping schema $schema in database $db"
	sudo -i -u postgres psql -d $db -c "drop schema if exists $schema cascade;"
	echo "Schema $schema has been dropped"
elif [[ ! -z $db ]]; then
	echo "Dropping database $db"
	sudo -i -u postgres psql -c "drop database if exists $db;"
	echo "Database $db has been dropped"
fi
