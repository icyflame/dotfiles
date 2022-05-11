fixed_decimals () {
	if [[ "$1" == "-h" || "$1" == "--help" ]];
	then
		cat <<EOF
fixed_decimals expression [number_of_decimals=2]

fixed_decimals prints the result of the given expression with the given number of decimal places. The default value for number of decimals is 2.

fixed_decimals does not print a newline after the result of the expression.

Example:

$ fixed_decimals 200/3
66.67

$ fixed_decimals 200/3 4
66.6667
EOF
		return 42
	fi
	local expression=$1
	if [[ -z "$expression" ]];
	then
		echo "ERROR: Must provide an arithmetic expression as the second argument" > /dev/stderr
		return 42
	fi
	shift
	local num_decimals=${1:-2}
	perl -e 'my $val = '"$expression"'; printf "%0.'"$num_decimals"'f", $val'
}

format () {
	perl -MNumber::Format -e 'my $N = new Number::Format; print $N->format_number('"$1"')'
}
