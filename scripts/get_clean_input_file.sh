#!/bin/bash

#../scripts/get_clean_input_file.sh file_name

fname=$1
new_fname=$(echo $fname | cut -f 1 -d '.')"_cl.txt"

echo -e "\n--- START ---"
echo -e "\nReads" $fname " and creates a new clean file " ${new_fname} " that can be read as a table"

gawk -v RS='"' 'NR % 2 == 0 { gsub(/[\r\n]+/, " ") } { printf("%s%s", $0, RT) }' ${fname} > ${new_fname}
gawk -v RS='"' 'NR % 2 == 0 { gsub(/[\r\t]+/, " ") } { printf("%s%s", $0, RT) }' ${new_fname} > temp.txt
mv temp.txt ${new_fname}

#Need to add name to first column
echo "NUM" > temp1.txt
head -1 ${new_fname} > temp2.txt
paste temp1.txt temp2.txt > header.txt
rm temp1.txt
rm temp2.txt
tr -s "\t\t" "\t" < header.txt > temp.txt
mv temp.txt header.txt
sed '1d' ${new_fname} > temp.txt
cat temp.txt >> header.txt
rm temp.txt
mv header.txt  ${new_fname} 

#Substitute single quote
sed "s/'/ /g" ${new_fname}  > temp.txt
mv temp.txt ${new_fname}

echo -e "\n--- END ---"




















