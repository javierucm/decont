# This script should download the file specified in the first argument ($1),
# place it in the directory specified in the second argument ($2),
# and *optionally*:
# - uncompress the downloaded file with gunzip if the third
#   argument ($3) contains the word "yes"
# - filter the sequences based on a word contained in their header lines:
#   sequences containing the specified word in their header should be **excluded**
#
# Example of the desired filtering:
#
#   > this is my sequence
#   CACTATGGGAGGACATTATAC
#   > this is my second sequence
#   CACTATGGGAGGGAGAGGAGA
#   > this is another sequence
#   CCAGGATTTACAGACTTTAAA
#
#   If $4 == "another" only the **first two sequence** should be output

orig=$1
dest=$2
wget -P $dest $orig 

#Opt1 if grep -q "yes" <<< "$3" 
#Opt 1 [[ "$3" == *"yes"* ]]  						
#Opt 2: if [ $(echo "$3" | grep "yes" | wc -l) -ne 0 ]
#Opt 3: if echo "$3" | grep -q  "yes"
#Opt1 if grep -q "yes" <<< "$3" 
if [[ "$3"==*"yes"* ]]
then
	 echo "Descomprimimos" 
desc=$(basename $orig)
gunzip -k $dest/$desc

fi

if [-z "$3"]
then
zcat res/contaminants.fasta.gz | seqkit grep  -r -i -n -v -p "$3"
fi
