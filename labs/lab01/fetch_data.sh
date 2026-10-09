#!/usr/bin/env bash

set -eu
cd "$(dirname "$0")"; mkdir -p data/structures
UP=https://rest.uniprot.org/uniprotkb

# 1201 reviewed globins -> clustering
curl -fsSL -o data/globins.fasta \
  "$UP/stream?format=fasta&query=%28family%3A%22globin+family%22%29+AND+%28reviewed%3Atrue%29"

# human hemoglobin beta -> the query
curl -fsSL -o data/query.fasta "$UP/P68871.fasta"

# 1000 reviewed human proteins (globins first, so the query has hits) -> target db
curl -fsSL "$UP/stream?format=fasta&query=%28reviewed%3Atrue%29+AND+%28organism_id%3A9606%29+AND+%28length%3A%5B100+TO+300%5D%29" \
  | awk '/^>/{g=/Hemoglobin|Myoglobin|Neuroglobin|Cytoglobin/} {print > (g?"data/_g.fa":"data/_r.fa")}'
cat data/_g.fa data/_r.fa | awk '/^>/{n++} n<=1000' > data/target_1000.fasta
rm -f data/_g.fa data/_r.fa
