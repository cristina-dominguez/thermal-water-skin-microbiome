
#!/bin/bash

############################################################
# Script: 02_face_taxonomic_assignment.sh
#
# Project: Thermal Water and Skin Microbiome
#
# Description:
# Taxonomic assignment of forearm skin microbiome
# sequencing reads using MetONTIIME, VSEARCH and SILVA 138.1.
#
# Author: Cristina Domínguez Verde, cdominguez@unizar.es
############################################################

set -euo pipefail

# ----------------------------------------------------------
# 1. CONFIGURATION
# ----------------------------------------------------------

# CHANGE THESE PATHS ACCORDING TO YOUR SYSTEM

PROJECT_DIR="/path/to/project"

INPUT_DIR="${PROJECT_DIR}/results/forearm/chimera_removal"

FASTQ_DIR="${PROJECT_DIR}/taxonomic_assignment/forearm/fastq"

OUTPUT_DIR="${PROJECT_DIR}/taxonomic_assignment/forearm"

METONTIIME_SCRIPT="/path/to/MetONTIIME.sh"

METADATA="${PROJECT_DIR}/metadata/metadata_forearm.tsv"

SILVA_SEQS="/path/to/silva-138-99-seqs.qza"
SILVA_TAX="/path/to/silva-138-99-tax.qza"

mkdir -p "$FASTQ_DIR" "$OUTPUT_DIR"

# ----------------------------------------------------------
# 2. CHECK INPUT FILES
# ----------------------------------------------------------

for file in "$METONTIIME_SCRIPT" "$METADATA" \
            "$SILVA_SEQS" "$SILVA_TAX"; do

    if [[ ! -f "$file" ]]; then
        echo "ERROR: Required file not found: $file"
        exit 1
    fi

done

# ----------------------------------------------------------
# 3. PREPARE FINAL FASTQ FILES
# ----------------------------------------------------------

for SAMPLE_DIR in "$INPUT_DIR"/*/; do

    [[ -d "$SAMPLE_DIR" ]] || continue

    SAMPLE=$(basename "$SAMPLE_DIR")

    INPUT_FASTQ="${SAMPLE_DIR}/${SAMPLE}_nonchimeric.fastq"

    if [[ ! -f "$INPUT_FASTQ" ]]; then
        echo "WARNING: FASTQ not found for ${SAMPLE}. Skipping."
        continue
    fi

    gzip -c "$INPUT_FASTQ" > "${FASTQ_DIR}/${SAMPLE}.fastq.gz"

done

# ----------------------------------------------------------
# 4. TAXONOMIC ASSIGNMENT
# ----------------------------------------------------------

# Parameters:
# 12 threads
# VSEARCH classification
# Additional parameters: 3, 0.8 and 0.7

nohup bash "$METONTIIME_SCRIPT" \
    "$FASTQ_DIR" \
    "$METADATA" \
    "$SILVA_SEQS" \
    "$SILVA_TAX" \
    12 Vsearch 3 0.8 0.7 \
    > "${OUTPUT_DIR}/MetONTIIME.log" 2>&1 &

echo "MetONTIIME taxonomic assignment started."
echo "Log file: ${OUTPUT_DIR}/MetONTIIME.log"

