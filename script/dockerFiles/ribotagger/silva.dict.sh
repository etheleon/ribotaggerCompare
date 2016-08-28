SILVA='data/output.fna'

./script/ribo.pl --print-tag --print-long --print-head --se 0 -i $SILVA -o temp -r v4 > dict/raw/silva.v4
#tag
./script/dict.builder/silva.pl tag data/silva.119/raw/taxonomy/tax_slv_ssu_nr_119.txt dict/raw/silva.v4    > dict/silva.tag.v4
./script/dict.builder/lite.pl dict/silva.tag.v4         > script/dict/silva.tag.v4
#long
./script/dict.builder/silva.pl long data/silva.119/raw/taxonomy/tax_slv_ssu_nr_119.txt dict/raw/silva.v4    > dict/silva.long.v4
./script/dict.builder/lite.pl dict/silva.long.v4        > script/dict/silva.long.v4

# ./script/ribo.pl --print-tag --print-long --print-head --se 0 -i $SILVA -o temp -r v5 > dict/raw/silva.v5
# ./script/dict.builder/silva.pl tag dict/raw/silva.v5 > dict/silva.tag.v5
# ./script/dict.builder/lite.pl dict/silva.tag.v5 > script/dict/silva.tag.v5
# ./script/dict.builder/silva.pl long dict/raw/silva.v5 > dict/silva.long.v5
# ./script/dict.builder/lite.pl dict/silva.long.v5 > script/dict/silva.long.v5
# 
# ./script/ribo.pl --print-tag --print-long --print-head --se 0 -i $SILVA -o temp -r v6 > dict/raw/silva.v6
# ./script/dict.builder/silva.pl tag dict/raw/silva.v6 > dict/silva.tag.v6
# ./script/dict.builder/lite.pl dict/silva.tag.v6 > script/dict/silva.tag.v6
# ./script/dict.builder/silva.pl long dict/raw/silva.v6 > dict/silva.long.v6
# ./script/dict.builder/lite.pl dict/silva.long.v6 > script/dict/silva.long.v6
# 
# ./script/ribo.pl --print-tag --print-long --print-head --se 0 -i $SILVA -o temp -r v7 > dict/raw/silva.v7
# ./script/dict.builder/silva.pl tag dict/raw/silva.v7 > dict/silva.tag.v7
# ./script/dict.builder/lite.pl dict/silva.tag.v7 > script/dict/silva.tag.v7
# ./script/dict.builder/silva.pl long dict/raw/silva.v7 > dict/silva.long.v7
# ./script/dict.builder/lite.pl dict/silva.long.v7 > script/dict/silva.long.v7
# 
