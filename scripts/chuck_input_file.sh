#!/bin/bash

fname="/home/gandin/cardio/input/vfp_cardio_ecg_mortara_cl.txt"

for((i=0; i<=4; i++))
do
outname=$(echo $fname | cut -f 1 -d '.')"_chunk_"${i}".txt"
j1=$(( (5000*${i})+1 ))
j2=$(( 5000*(${i}+1) ))
echo ${j1}" "${j2}" "${outname}
head -1 ${fname} > ${outname}
sed -n ${j1},${j2}p ${fname} >> ${outname}
done



