function col1 { awk '{ print $1 }' }
function col2 { awk '{ print $2 }' }
function col3 { awk '{ print $3 }' }
function col4 { awk '{ print $4 }' }
function col5 { awk '{ print $5 }' }
function col6 { awk '{ print $6 }' }
function col7 { awk '{ print $7 }' }
function col8 { awk '{ print $8 }' }
function col9 { awk '{ print $9 }' }

function tsv1 { awk -F'\t' '{ print $1 }' }
function tsv2 { awk -F'\t' '{ print $2 }' }
function tsv3 { awk -F'\t' '{ print $3 }' }
function tsv4 { awk -F'\t' '{ print $4 }' }
function tsv5 { awk -F'\t' '{ print $5 }' }
function tsv6 { awk -F'\t' '{ print $6 }' }
function tsv7 { awk -F'\t' '{ print $7 }' }
function tsv8 { awk -F'\t' '{ print $8 }' }
function tsv9 { awk -F'\t' '{ print $9 }' }

function csv1 { awk 'BEGIN { FPAT = "([^,]+)|(\"[^\"]+\")" } { print $1 }' }
function csv2 { awk 'BEGIN { FPAT = "([^,]+)|(\"[^\"]+\")" } { print $2 }' }
function csv3 { awk 'BEGIN { FPAT = "([^,]+)|(\"[^\"]+\")" } { print $3 }' }
function csv4 { awk 'BEGIN { FPAT = "([^,]+)|(\"[^\"]+\")" } { print $4 }' }
function csv5 { awk 'BEGIN { FPAT = "([^,]+)|(\"[^\"]+\")" } { print $5 }' }
function csv6 { awk 'BEGIN { FPAT = "([^,]+)|(\"[^\"]+\")" } { print $6 }' }
function csv7 { awk 'BEGIN { FPAT = "([^,]+)|(\"[^\"]+\")" } { print $7 }' }
function csv8 { awk 'BEGIN { FPAT = "([^,]+)|(\"[^\"]+\")" } { print $8 }' }
function csv9 { awk 'BEGIN { FPAT = "([^,]+)|(\"[^\"]+\")" } { print $9 }' }
