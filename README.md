# thermal-water-skin-microbiome
Bioinformatic and statistical scripts supporting a longitudinal study on the effects of Alhama de Aragón thermal spring water on skin microbiota composition, predicted metabolic functions, and skin physiology in older adults. Includes 16S rRNA sequencing processing, taxonomic, diversity, differential abundance, PICRUSt2, and correlation analyses.

# Thermal Water and Skin Microbiome 
This research is conducted within the framework of the CARUSO project, co-funded by the European Union through the Interreg VI-A Spain–France–Andorra (POCTEFA) 2021–2027 programme.
Further information about the project is available at: https://poctefa-caruso.eu/es/inicio/.
## Overview

This repository contains the bioinformatic and statistical analysis scripts used in the study investigating the effects of Alhama de Aragón (Zaragoza, Spain) thermal spring water (TSW) exposure on skin microbiota composition, predicted functional potential, and skin physiological parameters in older adults.

The study evaluates longitudinal changes in the skin microbiome and its predicted metabolic functions following a 7-day thermal water intervention, considering two anatomical sampling sites: the face and the forearm. Associations between microbial taxa and skin physiological parameters were also investigated.

The repository provides the computational workflows used for sequence preprocessing, taxonomic assignment, microbial diversity analysis, differential abundance analysis, functional prediction using PICRUSt2, metabolic pathway analysis, and microbiota–skin physiology correlation analyses.

## Study design

- **Study type:** Longitudinal, single-arm, pre–post intervention study.
- **Intervention:** Seven-day exposure to Alhama de Aragón thermal spring water.
- **Study population:** Older adults (62-86 yrs. old)
- **Sampling time points:** Before (baseline) and after (post-intervention) the intervention.
- **Sampling sites:** Facial skin and forearm skin.
- **Main analytical approaches:** 16S rRNA gene sequencing, taxonomic profiling, microbial diversity analysis, PICRUSt2 functional prediction, and statistical association analyses.

## Repository structure

```text
thermal-water-skin-microbiome/
│
├── README.md
├── LICENSE
│
├── 01_taxonomic_analysis/
│   ├── 01_preprocessing_and_taxonomic_assignment/
│   │   ├── face/
│   │   │   ├── 01_face_preprocessing.sh
│   │   │   └── 02_face_taxonomic_assigment.sh 
│   │   ├── forearm/
│   │   │   ├── 01_forearm_preprocessing.sh
│   │   │   └── 02_face_taxonomic_assigment.sh
│   │   └── README.md
│   │
│   └── 02_taxonomic_diversity_and_differential_abundance/
│       ├── 02_taxonomic_analysis.R
│       └── README.md
│
├── 02_functional_analysis/
│   ├── 01_picrust2_prediction/
│   │   ├── face/
│   │   │   └── 03_face_picrust2_prediction.sh
│   │   ├── forearm/
│   │   │   └── 03_forearm_picrust2_prediction.sh
│   │   └── README.md
│   │
│   └── 02_metabolic_pathway_analysis/
│       ├── 04_metabolic_pathway_analysis.R
│       └── README.md
│
├── 03_skin_microbiota_correlations/
    ├── 05_skin_microbiota_correlations.R
    └── README.md
```

## Analytical workflow

The computational workflow is organized into five main analytical stages:

### 1. Sequence preprocessing and taxonomic assignment

Raw sequencing reads were processed using a command-line bioinformatic workflow implemented in Bash. Separate scripts are provided for facial and forearm samples.

The workflow includes sequence quality control, filtering, and taxonomic classification using Kraken2 and Bracken against the SILVA 138.1 reference database.

**Scripts:**
- `01_face_preprocessing_taxonomic_assignment.sh`
- `01_forearm_preprocessing_taxonomic_assignment.sh`

### 2. Taxonomic diversity and differential abundance analysis

Taxonomic profiles were analyzed in R using the phyloseq and vegan packages, together with additional packages for statistical analysis and visualization.

The analyses include:

- Taxonomic composition and relative abundance.
- Alpha diversity analysis.
- Beta diversity analysis based on centered log-ratio (CLR) transformation and Aitchison distances.
- Non-metric multidimensional scaling (NMDS).
- Distance-based redundancy analysis (dbRDA).
- Differential taxonomic abundance analysis.

**Script:**
- `02_taxonomic_analysis.R`

### 3. Functional prediction using PICRUSt2

The functional potential of the skin microbiota was inferred using PICRUSt2. Separate Bash scripts are provided for facial and forearm samples.

The workflow includes functional prediction and the estimation of MetaCyc metabolic pathway abundances.

**Scripts:**
- `03_face_picrust2_prediction.sh`
- `03_forearm_picrust2_prediction.sh`

### 4. Predicted metabolic pathway analysis

PICRUSt2 outputs were imported and analyzed in R to investigate differences in predicted microbial functional profiles between baseline and post-intervention samples.

The analyses include:

- Functional alpha diversity.
- Functional beta diversity.
- Statistical comparison of predicted metabolic pathways.
- Differential pathway abundance analysis.
- Data visualization.

**Script:**
- `04_metabolic_pathway_analysis.R`

### 5. Skin microbiota–physiology association analysis

Associations between selected microbial taxa and skin physiological parameters were investigated using Spearman's rank correlation analysis.

The analyses integrate taxonomic abundance data with skin biophysical measurements obtained before and after the intervention.

**Script:**
- `05_skin_microbiota_correlations.R`

## Software and dependencies

The analyses were performed using a combination of command-line bioinformatic tools and R packages.

### Command-line tools

- Linux / Bash
- Dorado
- Chopper
- Kraken2
- Bracken
- PICRUSt2

### R environment

- R
- phyloseq
- vegan
- microbiomeMarker
- ggplot2
- Additional packages required for statistical analyses and visualization.

Specific software and package versions are documented in the `environment/` directory.

## Data availability

Due to participant privacy and ethical considerations, raw sequencing data (FASTQ files) and individual-level clinical and physiological metadata are not included in this repository.

Following publication of the study results, this repository will be updated to include the intermediate files generated during the bioinformatic and statistical analyses, including the R `phyloseq` objects used for downstream taxonomic and functional analyses, subject to applicable ethical and data protection requirements.

Additionally, the repository will be updated with:

- The DOI of the associated scientific publication.
- The accession number and repository link (e.g., ENA or NCBI SRA) where the raw sequencing data (FASTQ files) will be publicly available.

These updates will facilitate access to the intermediate analytical files and raw sequencing data, supporting transparency and reproducibility of the study.

## Reproducibility

Scripts are organized according to the analytical workflow and should be executed in the indicated order.

Input files, reference databases, software dependencies, and directory paths must be configured according to the user's computational environment before execution.

## Author
Cristina Domínguez Verde, cdominguez@unizar.es
University of Zaragoza, Spain
