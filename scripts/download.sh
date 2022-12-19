# This script should download the file specified in the first argument ($1),
# place it in the directory specified in the second argument ($2),
#uncompress the downloaded file with gunzip if the third   argument ($3) contains the word "yes"
#filter($4) the sequences based on a word contained in their header lines  (removing those records)

if [ "$#" -lt 2 ]
then
    echo "Error: At least two arguments are required"
    exit 1
fi


orig=$1
dest=$2
wget -P $dest $orig 
baseOrig=$(basename $orig)

if [[ "$3"==*"yes"* ]]
then
gunzip -k $dest/$baseOrig
fi

if [ ! -z "$4" ]
then
	zcat $dest/$baseOrig | seqkit grep  -r -i -n -v -p "$4"
fi
