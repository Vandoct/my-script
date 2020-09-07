function showHelp() {
	echo "Available options :"
	echo "-d | --db-name            Database name in postgresql"
	echo "-o | --output             Output name (with .sql)"
	echo "-h | --help               Show help"
}

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do
	case $1 in
	-d | --db-name)
		shift
		db=$1
		;;
	-o | --output)
		shift
		output=$1
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

if [[ -z $output ]]; then
	echo "Output can't be empty!"
	showHelp
	exit
fi

echo "Exporting database $db to $output"
pg_dump -U postgres -h localhost $db >> $output
echo "Export has finished"
echo "Exported database located at: $(pwd)/$output"
