#!/usr/bin/env bash

cd "$(dirname "$0")"

FS=$(command -v foldseek)
MM=$(command -v mmseqs)
cd work
rm -rf qdb* tdb* q.fasta t.fasta mm_hits*.tsv tmp_mm

# Foldseek databases -> amino-acid fasta
"$FS" createdb q/1MBN.pdb qdb > /dev/null
"$FS" createdb ../data/structures tdb > /dev/null
"$FS" convert2fasta qdb q.fasta > /dev/null
"$FS" convert2fasta tdb t.fasta > /dev/null

# sequence search with the same e-value / coverage as Foldseek, then c = 0
for c in 0.8 0; do
  "$MM" easy-search q.fasta t.fasta "mm_hits_c${c}.tsv" tmp_mm -e 10 -c "$c" \
        --format-output "query,target,fident,evalue,bits" > "mmseqs_c${c}.log"
done
