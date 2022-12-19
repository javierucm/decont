##Contaminant fasta file:

urlContam='https://bioinformatics.cnio.es/data/courses/decont/contaminants.fasta.gz'

#Download all the files specified in data/filenames
for url in $(cat data/urls) #TODO
do
    echo $url
#    bash scripts/download.sh $url data   UNCOMMENTTTTTTTTT
done

# Download the contaminants fasta file, uncompress it, and
# filter to remove all small nuclear RNAs
#bash scripts/download.sh $urlContam res yes "small nuclear"  #????TODO

# Index the contaminants file
echo "Indexing...................."
#bash scripts/index.sh res/contaminants.fasta res/contaminants_idx   UNCOMMENT!!!!!!!!!!

echo "Merging........................."
# Merge the samples into a single file
for sid in $(cat data/urls |  sed 's/.*\///' | sed 's/-.*//' |sort -u) #TODO
do

echo $id
 #   bash scripts/merge_fastqs.sh data out/merged $sid
done

# TODO: run cutadapt for all merged files

mkdir -p out/trimmed  
mkdir -p log/cutadapt
for file in out/merged/*
do
	sid=$(basename $file | sed 's/.fastq.gz//') 
#	 cutadapt -m 18 -a TGGAATTCTCGGGTGCCAAGG --discard-untrimmed \
#	-o out/trimmed/"$sid".trimmed.fastq.gz $file > log/cutadapt/"$sid".log
	
done

# TODO: run STAR for all trimmed files
for fname in out/trimmed/*.fastq.gz
do
    sid=$(basename $fname|sed 's/.trimmed.fastq.gz//') 
   mkdir -p out/star/$sid
 #  STAR --runThreadN 4 --genomeDir res/contaminants_idx \
 #     --outReadsUnmapped Fastx --readFilesIn $fname \
 #     --readFilesCommand gunzip -c --outFileNamePrefix out/star/$sid/
done 

# TODO: create a log file containing information from cutadapt and star logs
# (this should be a single log file, and information should be *appended* to it on each run)
# - cutadapt: Reads with adapters and total basepairs
# - star: Percentages of uniquely mapped reads, reads mapped to multiple loci, and to too many loci
# tip: use grep to filter the lines you're interested in
for file in log/cutadapt/*.log
do
	echo $file
	sid=$(basename $file | sed 's/.log//')
	echo "#################">>Log.out
	echo "Sample : $sid">>Log.out
#	cat $file  | grep "Total basepairs processed|Reads with adapters" | cut -d: -f1,2 >>Log.out
	cat $file  | grep "Reads with adapters" | cut -d: -f1,2 >>Log.out
  	cat  out/star/$sid/Log.final.out |sed -e 's/^[ \t]*//'  | grep  "Uniquely mapped reads %" | cut -d\| -f1,2 --output-delimiter=":" >>Log.out
	cat  out/star/$sid/Log.final.out |sed -e 's/^[ \t]*//'  | grep  "% of reads mapped to multiple loci" | cut -d\| -f1,2 --output-delimiter=":" >>Log.out
	cat  out/star/$sid/Log.final.out |sed -e 's/^[ \t]*//'  | grep  "% of reads mapped to too many loci" | cut -d\| -f1,2 --output-delimiter=":" >>Log.out
	


done

cat Log.out


