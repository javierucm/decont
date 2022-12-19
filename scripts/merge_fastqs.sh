# This script should merge all files from a given sample (the sample id is
# provided in the third argument ($3)) into a single file, which should be
# stored in the output directory specified by the second argument ($2).
#
# The directory containing the samples is indicated by the first argument ($1).

if [ "$#" -ne 3 ]
then
    echo "Error: Three arguments are required"
    exit 1
fi

mkdir -p $2
ext=".fastq.gz"
cat "$1"/"$3"*"$ext"* > "$2"/"$3$ext"



