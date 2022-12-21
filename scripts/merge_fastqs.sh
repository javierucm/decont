# This script should merge all files from a given sample (the sample id is
# provided in the third argument ($3)) into a single file, which should be
# stored in the output directory specified by the second argument ($2).
#
# The directory containing the samples is indicated by the first argument ($1).

[ "$#" -ne 3 ] && echo "Error: Three arguments are required" &&  exit 1

ext=".fastq.gz"

[ -e "$2"/"$3$ext" ] &&  echo "$3 was already merged" && exit 0;

mkdir -p $2
cat "$1"/"$3"*"$ext"* > "$2"/"$3$ext"



