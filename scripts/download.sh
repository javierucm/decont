# This script should download the file specified in the first argument ($1),
# place it in the directory specified in the second argument ($2),
#uncompress the downloaded file with gunzip if the third   argument ($3) contains the word "yes"
#filter($4) the sequences based on a word contained in their header lines  (removing those records)

[ "$#" -lt 2 ] && echo "Error: At least two arguments are required" && exit 1;

orig=$1
dest=$2
args=()
[ -f "$orig" ] &&  args=(-P $dest -i $orig -nc) || args=(-P $dest $orig -nc)
wget "${args[@]}" 

#Check md5:
[ -f $orig ] && urlFor=$(cat $orig) || urlFor=$orig
for url in $urlFor
do
	chkSumServ=$(curl -s "$url".md5  |  cut -d " " -f1 )
	chkSumLocal=$(md5sum $dest/$(basename $url)| cut -d ' ' -f 1)  
	[ "$chkSumServ" != "$chkSumLocal" ] && echo "Warning: CheckSum Error -> "$url && exit 1;
done

#Gunzip (3 Argument)
baseOrig=$(basename $orig)
if [[ "$3"==*"yes"* ]]
then
  if [ -f "$orig" ]
	then
		sed "s/.*\///" "$orig" |  sed "s/^/$dest\//" | xargs gunzip -k
	else baseOrig=$(basename $orig); gunzip -k $dest/$baseOrig
  fi
fi
#Filtering (4 Argument)
[ ! -z "$4" ] && [ ! -f "$orig" ] && (zcat $dest/$baseOrig | seqkit grep  -r -i -n -v -p "$4")

