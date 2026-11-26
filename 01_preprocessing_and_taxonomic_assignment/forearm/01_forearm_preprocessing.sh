
#!/bin/bash

############################################################
# Script: 01_face_preprocessing.sh
#
# Project: Thermal Water and Skin Microbiome
#
# Description:
# Quality control, adapter removal, sequence length
# filtering and chimera removal of forearm skin
# 16S rRNA gene sequencing reads.
#
# Software:
# NanoPlot, Porechop, Chopper, minimap2 and yacrd.
#
# Author: [Your name]
############################################################

set -euo pipefail

# ----------------------------------------------------------
# 1. CONFIGURATION
# ----------------------------------------------------------

# Project directory: CHANGE THIS PATH
PROJECT_DIR="/path/to/project"

# Input directory containing one folder per sample
INPUT_DIR="${PROJECT_DIR}/input/forearm"

# Output directory
OUTPUT_DIR="${PROJECT_DIR}/results/forearm"

# Number of threads for minimap2
THREADS=10

# Sequence length thresholds
MIN_LENGTH=600
MAX_LENGTH=1700

mkdir -p "${OUTPUT_DIR}"/{quality_control,adapter_removal,length_filtering,chimera_removal}

# ----------------------------------------------------------
# 2. SOFTWARE CHECK
# ----------------------------------------------------------

for tool in NanoPlot porechop chopper minimap2 yacrd; do
    command -v "$tool" >/dev/null 2>&1 || {
        echo "ERROR: $tool is not available in PATH."
        exit 1
    }
done

# ----------------------------------------------------------
# 3. PROCESS EACH SAMPLE
# ----------------------------------------------------------

for SAMPLE_DIR in "${INPUT_DIR}"/*/; do

    [[ -d "$SAMPLE_DIR" ]] || continue

    SAMPLE=$(basename "$SAMPLE_DIR")

    echo "Processing sample: ${SAMPLE}"

    SAMPLE_QC="${OUTPUT_DIR}/quality_control/${SAMPLE}"
    SAMPLE_ADAPTER="${OUTPUT_DIR}/adapter_removal/${SAMPLE}"
    SAMPLE_LENGTH="${OUTPUT_DIR}/length_filtering/${SAMPLE}"
    SAMPLE_CHIMERA="${OUTPUT_DIR}/chimera_removal/${SAMPLE}"

    mkdir -p "$SAMPLE_QC" "$SAMPLE_ADAPTER" \
             "$SAMPLE_LENGTH" "$SAMPLE_CHIMERA"

    # Locate input FASTQ file
    mapfile -t FASTQ_FILES < <(
        find "$SAMPLE_DIR" -maxdepth 1 \
        -type f \( -name "*.fastq.gz" -o -name "*.fastq" \)
    )

    if [[ ${#FASTQ_FILES[@]} -ne 1 ]]; then
        echo "WARNING: Expected one FASTQ file for ${SAMPLE}. Skipping."
        continue
    fi

    INPUT_FASTQ="${FASTQ_FILES[0]}"

    # ------------------------------------------------------
    # 3.1. QUALITY CONTROL
    # ------------------------------------------------------

    NanoPlot \
        --fastq "$INPUT_FASTQ" \
        --outdir "$SAMPLE_QC"

    # ------------------------------------------------------
    # 3.2. ADAPTER REMOVAL
    # ------------------------------------------------------

    ADAPTER_FASTQ="${SAMPLE_ADAPTER}/${SAMPLE}_porechop.fastq.gz"

    porechop \
        -i "$INPUT_FASTQ" \
        -o "$ADAPTER_FASTQ"

    # ------------------------------------------------------
    # 3.3. SEQUENCE LENGTH FILTERING
    # ------------------------------------------------------

    FILTERED_FASTQ="${SAMPLE_LENGTH}/${SAMPLE}_filtered.fastq"

    gunzip -c "$ADAPTER_FASTQ" | \
        chopper \
        -l "$MIN_LENGTH" \
        --maxlength "$MAX_LENGTH" \
        > "$FILTERED_FASTQ"

    # ------------------------------------------------------
    # 3.4. CHIMERA DETECTION AND REMOVAL
    # ------------------------------------------------------

    OVERLAP_FILE="${SAMPLE_CHIMERA}/${SAMPLE}_overlap.paf"
    YACRD_REPORT="${SAMPLE_CHIMERA}/${SAMPLE}_yacrd_report.txt"
    FINAL_FASTQ="${SAMPLE_CHIMERA}/${SAMPLE}_nonchimeric.fastq"

    minimap2 \
        -x ava-ont \
        -g 500 \
        -t "$THREADS" \
        "$FILTERED_FASTQ" "$FILTERED_FASTQ" \
        > "$OVERLAP_FILE"

    yacrd \
        -i "$OVERLAP_FILE" \
        -o "$YACRD_REPORT" \
        -c 4 \
        -n 0.4 \
        filter \
        -i "$FILTERED_FASTQ" \
        -o "$FINAL_FASTQ"

    echo "Completed sample: ${SAMPLE}"

done

echo "Forearm skin preprocessing completed."

