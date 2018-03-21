#!/bin/bash

fname=$1
i0=$2
i2=$3

new_fname=${fname}"all.txt"
cp ../output/freq_chunk_${i0}.txt  ../output/${new_fname}

i1=$((${i0}+1))

echo -e "\nAdding..."
for n in $(seq ${i1} ${i2})
do
sed '1d' ../output/freq_chunk_${n}.txt >> ../output/${new_fname}
echo -e "-" freq_chunk_${n}.txt
done
echo -e "\nDone.\n"


#Calls R script that aggregate frequencies
Rscript ../scripts/aggregate_freq.R  ../output/${new_fname}





