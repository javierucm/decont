## Unit testing of some scripts

#Merge Fastqs
bash scripts/merge_fastqs.sh data merge C57BL

#Download:

bash scripts/download.sh https://bioinformatics.cnio.es/data/courses/decont/SPRET_EiJ-12.5dpp.1.1s_sRNA.fastq.gz data


#Download and unzip:

bash scripts/download.sh https://bioinformatics.cnio.es/data/courses/decont/SPRET_EiJ-12.5dpp.1.1s_sRNA.fastq.gz data oyestuuuuu

# Filter:
zcat res/contaminants.fasta.gz | seqkit grep  -r -i -n  -p "subunit"
