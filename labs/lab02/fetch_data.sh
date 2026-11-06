#!/usr/bin/env bash

cd "$(dirname "$0")"

rm -rf data
mkdir -p data/structures

# 12 globin structures + 6 unrelated controls
for id in 1MBN 1MBO 2MM1 1A3N 3HHB 2LHB 1ECD 1LH1 1ITH 1HLB 1CG5 2GDM \
          1UBQ 4LZM 1CRN 2TRX 1SHG 5PTI; do
  [ -s data/structures/$id.pdb ] ||
    curl -fsSL -o data/structures/$id.pdb "https://files.rcsb.org/download/$id.pdb"
done

ls data/structures | wc -l
