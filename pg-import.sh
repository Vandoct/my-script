function showHelp() {
	echo "Available options :"
	echo "-d | --db-name            Database name in postgresql"
	echo "-f | --file               Database file to be imported"
	echo "-h | --help               Show help"
}

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do
	case $1 in
	-d | --db-name)
		shift
		db=$1
		;;
	-f | --file)
		shift
		file=$1
		;;
	-h | --help)
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

if [[ -z $file ]]; then
	echo "File can't be empty!"
	showHelp
	exit
fi

if [[ ! -f $file ]]; then
	echo "$file doesn't exist"
	exit
fi

echo "Importing $file into $db ..."
sudo -i -u postgres psql -U postgres $db <$file
echo "Import has finished"
