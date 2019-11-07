TRIMMOMATIC = "${HOME}/tools/Trimmomatic-0.39/trimmomatic-0.39.jar"
ADAPTERS = "${HOME}/tools/Trimmomatic-0.39/adapters/NexteraPE-PE.fa"

SAMPLES=['example1', 'example2']

rule all:
    input:
        expand('output/Snakemake/{sample}_paired_R1.fastq', sample=SAMPLES),
        expand('output/Snakemake/{sample}_paired_R2.fastq', sample=SAMPLES),
        expand('output/Snakemake/{sample}_unpaired_R1.fastq', sample=SAMPLES),
        expand('output/Snakemake/{sample}_unpaired_R2.fastq', sample=SAMPLES)

rule QualityControl:
    input:
        forward='data/{sample}_R1_001.fastq.gz',
        reverse='data/{sample}_R2_001.fastq.gz'
    output:
        p1="output/Snakemake/{sample}_paired_R1.fastq",
        p2="output/Snakemake/{sample}_paired_R2.fastq",
        u1="output/Snakemake/{sample}_unpaired_R1.fastq",
        u2="output/Snakemake/{sample}_unpaired_R2.fastq"
    shell:
        """
        java -jar {TRIMMOMATIC} PE {input.forward} {input.reverse} \
          {output.p1} \
          {output.u1} \
          {output.p2} \
          {output.u2} \
          ILLUMINACLIP:{ADAPTERS}:2:30:10:3:TRUE \
          LEADING:3 \
          TRAILING:3 \
          SLIDINGWINDOW:4:15 \
          MINLEN:36
     
        """
