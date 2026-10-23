#!/usr/bin/env bash

cd "$(dirname "$0")"

rm -rf work
mkdir -p work/q
cp data/structures/1MBN.pdb work/q/

FS=$(command -v foldseek)
cd work

# structural search: myoglobin vs the other 17 structures
echo "Search..."
"$FS" easy-search q/1MBN.pdb ../data/structures fs_hits.tsv tmp -e 10 -c 0.8 \
      --format-output "query,target,fident,alntmscore,evalue,bits" > foldseek_search.log

# clustering structures
echo "Clustering..."
"$FS" easy-cluster ../data/structures fsclu tmp --min-seq-id 0.5 -c 0.8 > foldseek_cluster.log
