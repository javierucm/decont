##Contaminant fasta file:
urlContam='https://bioinformatics.cnio.es/data/courses/decont/contaminants.fasta.gz'

#Download all the files specified in data/filenames
#for url in $(cat data/urls) 
#do
#    bash scripts/download.sh $url data
#done

# Same script with no iteration.
bash scripts/download.sh data/urls data

# Download the contaminants fasta file, uncompress it, and filter to remove all small nuclear RNAs
bash scripts/download.sh $urlContam res yes "small nuclear"  

# Index the contaminants file
bash scripts/index.sh res/contaminants.fasta res/contaminants_idx  

# Merge the samples into a single file
for sid in $(cat data/urls |  sed 's/.*\///' | sed 's/-.*//' |sort -u) 
do
  bash scripts/merge_fastqs.sh data out/merged $sid
done

# Run cutadapt for all merged files
mkdir -p out/trimmed  
mkdir -p log/cutadapt
for file in out/merged/*
do
	sid=$(basename $file | sed 's/.fastq.gz//') 
 	[ -e out/trimmed/"$sid".trimmed.fastq.gz ] && echo "$sid was already trimmed" || \
		 cutadapt -m 18 -a TGGAATTCTCGGGTGCCAAGG --discard-untrimmed \
		-o out/trimmed/"$sid".trimmed.fastq.gz $file > log/cutadapt/"$sid".log 
done

#  run STAR for all trimmed files
for fname in out/trimmed/*.fastq.gz
do
    sid=$(basename $fname|sed 's/.trimmed.fastq.gz//') 
    mkdir -p out/star/$sid
   [ -e out/star/"$sid" ] && echo "$sid was already aligned" || echo "no tiene sentido" && echo "otro" && echo "no entiendo" && \
	 STAR --runThreadN 4 --genomeDir res/contaminants_idx \
      --outReadsUnmapped Fastx --readFilesIn $fname \
      --readFilesCommand gunzip -c --outFileNamePrefix out/star/$sid/
done 

#Logs:
for file in log/cutadapt/*.log
do

	sid=$(basename $file | sed 's/.log//')
	echo -e "---------\nSample : $sid \n$(date)">>Log.out
	cat $file  | grep -E  "Total basepairs processed|Reads with adapters"  >>Log.out
	cat  out/star/$sid/Log.final.out|sed -e 's/^[ \t]*//' | sed -e 's/|/:/' \
		| grep -E  "Uniquely mapped reads %|% of reads mapped to multiple loci|% of reads mapped to too many loci" >>Log.out
done

cat Log.out


