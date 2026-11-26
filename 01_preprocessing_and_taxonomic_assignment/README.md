# Sequence Preprocessing and Taxonomic Assignment

## Overview

This directory contains the Bash scripts used for the preprocessing of Oxford Nanopore 16S rRNA gene sequencing reads and subsequent taxonomic assignment of skin microbiome samples.

The workflow was applied independently to two anatomical sampling sites:

- Facial skin (face).
- Forearm skin (forearm).

The computational workflow comprises sequence quality control, adapter removal, sequence length filtering, chimera detection and removal, and taxonomic classification using the SILVA reference database (release 138.1).

Separate scripts are provided for each anatomical site to maintain independent processing and taxonomic assignment workflows.

## Workflow

### 1. Input preparation

Sequencing reads generated from the same biological sample, including reads obtained from additional sequencing runs when applicable, were combined into a single FASTQ file per sample.

The original sequencing files were retained unchanged. The concatenated FASTQ files were used as input for downstream processing.

### 2. Sequence quality control

Sequence quality assessment was performed using NanoPlot (v1.44.1).

The following quality metrics were evaluated:

- Number of reads.
- Total number of bases.
- Mean and median read length.
- Maximum read length.
- Read length N50.
- Mean read quality score.

NanoPlot reports were generated separately for each sample.

### 3. Adapter removal

Sequencing adapters were removed using Porechop (v0.2.4).

The number of reads before and after adapter removal was assessed to monitor the effect of this processing step.

### 4. Sequence length filtering

Reads were filtered according to sequence length using Chopper (v0.8.0).

Only sequences between 600 and 1,700 bp were retained for downstream analysis.

### 5. Chimera detection and removal

Potential chimeric sequences were identified and filtered using minimap2 (v2.24-r1122) and yacrd (v1.0.0).

First, pairwise read overlaps were identified using minimap2 with the following parameters:

- Preset: `ava-ont`
- Minimum overlap-related parameter: `-g 500`
- Number of threads: 10

Subsequently, yacrd was used to identify and filter chimeric sequences using the following parameters:

- `-c 4`
- `-n 0.4`

The resulting FASTQ files were used for downstream taxonomic assignment.

### 6. Taxonomic assignment

Taxonomic classification was performed independently for facial and forearm samples using the MetONTIIME pipeline and VSEARCH, with the SILVA 138.1 reference database.

The following reference artifacts were required:

- `silva-138-99-seqs.qza`
- `silva-138-99-tax.qza`

The MetONTIIME workflow was executed using the following parameters:

- Number of threads: 12
- Classification method: VSEARCH
- Parameter: 3
- Identity threshold: 0.8
- Additional classification parameter: 0.7

The workflow generated QIIME 2 artifacts, including the feature table (`table.qza`) and taxonomic assignment table (`taxonomy.qza`).

### 7. Phyloseq object generation

The resulting QIIME 2 artifacts were imported into R using the `phyloseq` and `qiime2R` packages.

Taxonomic abundance tables and taxonomic annotations were combined to generate a `phyloseq` object. The corresponding sample metadata were subsequently incorporated into each object.

Separate objects were generated for facial and forearm samples and saved as RDS files for subsequent taxonomic and functional analyses.

## Repository structure

```text
01_preprocessing_and_taxonomic_assignment/
│
├── face/
│   ├── 01_face_preprocessing.sh
│   └── 02_face_taxonomic_assignment.sh
│
├── forearm/
│   ├── 01_forearm_preprocessing.sh
│   └── 02_forearm_taxonomic_assignment.sh
│
└── README.md
```

## Software requirements

| Software | Version |
|---|---|
| NanoPlot | 1.44.1 |
| Porechop | 0.2.4 |
| Chopper | 0.8.0 |
| minimap2 | 2.24-r1122 |
| yacrd | 1.0.0 |
| MetONTIIME | Pipeline version to be specified |
| VSEARCH | Version to be specified |
| QIIME 2 | Version to be specified |

The preprocessing tools were executed in a dedicated Conda environment (`nanopore`). Taxonomic assignment was performed in a separate environment (`MetONTIIME_env`).

## Input files and configuration

Before running the scripts, the following elements must be available and configured:

1. Raw or previously concatenated FASTQ files, organized into individual sample directories.
2. The appropriate sample metadata file for each anatomical site.
3. The MetONTIIME pipeline (`MetONTIIME.sh`) and its required dependencies.
4. SILVA 138.1 reference artifacts (`silva-138-99-seqs.qza` and `silva-138-99-tax.qza`).
5. Valid input and output directory paths.

All directory paths and software locations must be adapted to the local computational environment.

Sample identifiers in the FASTQ filenames must match those in the corresponding metadata files.

## Normalization

No read-depth normalization was performed before taxonomic assignment. The original sequencing depth was retained for subsequent assessment and statistical processing of the generated phyloseq objects.

## Execution

Scripts should be executed sequentially, first performing preprocessing and then taxonomic assignment for each anatomical site.

The facial and forearm workflows must be run independently using their corresponding metadata files and reference directories.

## Output files

The main outputs include:

- Quality control reports generated by NanoPlot.
- Adapter-trimmed FASTQ files.
- Length-filtered FASTQ files.
- Chimera-filtered FASTQ files.
- QIIME 2 feature tables (`table.qza`).
- QIIME 2 taxonomic assignment tables (`taxonomy.qza`).
- RDS files containing the final facial and forearm phyloseq objects.

These outputs are used as input for downstream taxonomic diversity, differential abundance and predicted functional analyses.
