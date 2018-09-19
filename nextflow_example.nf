TRIMMOMATIC = "/usr/local/Trimmomatic-0.36/trimmomatic-0.36.jar"
ADAPTERS = "/usr/local/Trimmomatic-0.36/adapters/NexteraPE-PE.fa"


Channel
    .fromFilePairs( params.reads, flat: true )
    .into { read_pairs }


process Trimmomatic {
    tag {dataset_id}
    
    publishDir "${params.output}/Nextflow"
    
    input:
        set dataset_id, file(forward), file(reverse) from read_pairs
    output:
        file "${dataset_id}_paired_R1.fastq"
        file "${dataset_id}_paired_R2.fastq"
    
    """
    java -jar ${TRIMMOMATIC} PE $forward $reverse \
      ${dataset_id}_paired_R1.fastq \
      ${dataset_id}_unpaired_R1.fastq \
      ${dataset_id}_paired_R2.fastq \
      ${dataset_id}_unpaired_R2.fastq \
      ILLUMINACLIP:${ADAPTERS}:2:30:10:3:TRUE \
      LEADING:3 \
      TRAILING:3 \
      SLIDINGWINDOW:4:15 \
      MINLEN:36
 
    """
}


