# This script should download the file specified in the first argument ($1),
# place it in the directory specified in the second argument ($2),
#uncompress the downloaded file with gunzip if the third   argument ($3) contains the word "yes"
#filter($4) the sequences based on a word contained in their header lines  (removing those records)

[ "$#" -lt 2 ] && echo "Error: At least two arguments are required" && exit 1;

orig=$1
dest=$2

#Download
args=()
[ -f "$orig" ] &&  args=(-P $dest -i $orig -nc) || args=(-P $dest $orig -nc)
wget "${args[@]}" 


[ -f $orig ] && urlFor=$(cat $orig) || urlFor=$orig
for url in $urlFor
do
	#Check md5:
	chkSumServ=$(curl -s "$url".md5  |  cut -d " " -f1 )
	chkSumLocal=$(md5sum $dest/$(basename $url)| cut -d " " -f1)
	[ "$chkSumServ" != "$chkSumLocal" ] && echo "Warning: CheckSum Error -> "$url && exit 1;

	#Unzip:
	if [[ "$3"==*"yes"* ]] 
	then
	 	[ -e $dest/$(basename $url .gz) ] && echo "$url was already unzipped" ||  gunzip -k $dest/$(basename $url)
	fi
done

# Unzip with no iteration: sed "s/.*\///" "$orig" |  sed "s/^/$dest\//" | xargs gunzip -k

#Filtering (4 Argument)
if [ ! -z "$4" ] && [ ! -f "$orig" ] 
then
   filtFile=$( echo $(basename $orig) | awk  'BEGIN{OFS=FS="."}{$(NF-2)=$(NF-2)"-filtered";$(NF)="";print substr($0,1,length($0)-1)}' )
[ -e $filtFile ] && echo "$orig was already filtered" || \
 ( ( zcat $dest/$(basename $orig) | seqkit grep  -r -i -n -v -p "$4" ) > $dest/$filtFile  ) 
fi
