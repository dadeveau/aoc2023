#! /bin/awk -f
# run with awk -F' ' -f day2.awk input.txt

# I prefer sed + awk one-liners, but will use raw awk here
#2a: sed 's/[:;,]/\n/g' input.txt | awk -F' ' '/Game/ {if(valid){sum+=game};game=$2;valid=1;next} /red/ {if($1 > 12) valid=0;next} /green/ {if($1 > 13) valid=0; next} /blue/ {if($1 > 14) valid=0; next} END {if(valid){sum+=game;} print sum}'
#2b. sed 's/[:;,]/\n/g' input.txt | awk -F' ' '/Game/ {sum+=minred*minblue*mingreen;minred=0;mingreen=0;minblue=0} /red/ {if($1 > minred) minred=$1} /green/ {if($1 > mingreen) mingreen=$1} /blue/ {if($1 > minblue) minblue=$1} END {sum+=minred*minblue*mingreen;print sum}'
BEGIN {
    sum_2a = 0
    sum_2b = 0
}
{
    gsub(/[;,:]/,"")
    game = int($2)
    for (i=4 ; i <= NF; i++) {
        if (i % 2 == 0) {
            count = int($(i-1))
            color = $i
            if (count > max[color]) {
                max[color] = count
            }
        }
    }
    if( max["red"] < 13 && max["green"] < 14 && max["blue"] < 15) {
        sum_2a += game
    }
    sum_row_2b = 1
    for (color in max) {
        sum_row_2b *= int(max[color])
    }
    sum_2b += sum_row_2b
    delete max
}

END {
    print sum_2a
    print sum_2b
}
