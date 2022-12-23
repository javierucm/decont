# This script should index the genome file specified in the first argument ($1),
# creating the index in a directory specified by the second argument ($2).

[ "$#" -ne 2 ] && echo "Error:Unespecified parameters" &&  exit 1
[ -e $2/Genome ] && echo "$1 was already indexed" ||
 STAR --runThreadN 4 --runMode genomeGenerate --genomeDir $2 \
 --genomeFastaFiles $1 --genomeSAindexNbases 9


