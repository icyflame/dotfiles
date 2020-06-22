#!/usr/bin/env bash

build_gnuplot_output () {
    if [[ $# -eq 0 ]];
    then
        echo "script gnuplot-script data"
        return 0
    fi

    GNU_PLOT=${1}
    DATA=${2}

    if [[ ! -f $DATA || ! -f $GNU_PLOT ]];
    then
        echo "ERROR: Data file and GNU plot script must exist"
        return 42
    fi

    rm -f /tmp/input /tmp/output.svg /tmp/script.gnuplot

    # Prepare script
    cat <<EOF > /tmp/script.gnuplot
reset
clear
set grid
set terminal svg size 1000,1000
set output 'output.svg'
set datafile separator ","
EOF

    cat "$GNU_PLOT" >> /tmp/script.gnuplot

    # Prepare input data
    cp $DATA /tmp/input

    # Run gnuplot
    CURRENT="$PWD"
    cd /tmp
    gnuplot script.gnuplot
    cd "$CURRENT"

    # TODO: Print this only if $? is 0 after gnuplot runs
    echo "Output written to /tmp/output.svg"
}

build_simple_histogram () {
    if [[ $# -eq 0 ]];
    then
        echo "script data column"
        return 0
    fi

    DATA="${1}"
    COLUMN=${2}

    if [[ ! -f "$DATA" ]];
    then
        echo "ERROR: Arg1 must be a file"
        return 43
    fi

    if [[ $COLUMN -lt 2 ]];
    then
        echo "ERROR: Arg2 must be 2 or higher"
        return 42
    fi

    rm -f /tmp/histogram.gnuplot
    cat <<EOF > /tmp/histogram.gnuplot
set key autotitle columnhead
set style data histogram
set style fill solid border 1
set boxwidth 0.9

set xtics center border out nomirror rotate by 45 right scale 0
set xtics rotate out scale 0

plot 'input' using $COLUMN:xticlabels(1)
EOF

    build_gnuplot_output "/tmp/histogram.gnuplot" "$DATA"
}

build_smooth_curve_no_xtics () {
    if [[ $# -eq 0 ]];
    then
        echo "script data column"
        return 0
    fi

    DATA="${1}"
    COLUMN=${2}

    if [[ ! -f "$DATA" ]];
    then
        echo "ERROR: Arg1 must be a file"
        return 43
    fi

    if [[ $COLUMN -lt 2 ]];
    then
        echo "ERROR: Arg2 must be 2 or higher"
        return 42
    fi

    rm -f /tmp/histogram.gnuplot
    cat <<EOF > /tmp/histogram.gnuplot
set key autotitle columnhead
set style data histogram
set style fill solid border 1
set boxwidth 0.9

set xtics center border out nomirror

# rotate by 45 right scale 0

# set ylabel "cache hit rate (%)"
# set xlabel "cache duration (minutes)"

plot 'input' using $COLUMN:xticlabels(1)
# smooth bezier
EOF

    build_gnuplot_output "/tmp/histogram.gnuplot" "$DATA"
}

build_clustered_histogram () {
    if [[ $# -eq 0 ]];
    then
        echo "script data col1 col2"
        return 0
    fi

    DATA="${1}"
    COL_BASE=${2}
    COL1=$(($COL_BASE+1))
    COL2=${3}

    if [[ ! -f "$DATA" ]];
    then
        echo "ERROR: Arg1 must be a file"
        return 43
    fi

    rm -f /tmp/histogram.gnuplot
    cat <<EOF > /tmp/histogram.gnuplot
set key autotitle columnhead
set style histogram cluster gap 1
set style data histogram
set style fill solid border 1
set boxwidth 0.9

set xtics center border out nomirror rotate by 45 right scale 0

plot 'input' using $COL_BASE:xticlabels(1) ti col, \
for [i=$COL1:$COL2] '' using i ti col
EOF

    build_gnuplot_output "/tmp/histogram.gnuplot" "$DATA"
}

build_rowstacked_histogram () {
    if [[ $# -eq 0 ]];
    then
        echo "script data col1 col2"
        return 0
    fi

    DATA="${1}"
    COL_BASE=${2}
    COL1=$(($COL_BASE+1))
    COL2=${3}

    if [[ ! -f "$DATA" ]];
    then
        echo "ERROR: Arg1 must be a file"
        return 43
    fi

    rm -f /tmp/histogram.gnuplot
    cat <<EOF > /tmp/histogram.gnuplot
set key autotitle columnhead
set style histogram rowstacked
set style data histogram
set style fill solid border 1
set boxwidth 0.9

set xtics center border out nomirror rotate by 45 right scale 0

plot 'input' using $COL_BASE:xticlabels(1) ti col, \
for [i=$COL1:$COL2] '' using i ti col
EOF

    build_gnuplot_output "/tmp/histogram.gnuplot" "$DATA"
}
