#!/bin/awk
# run with awk -F' ' -f day1.awk input.txt

# I prefer one-liners with sed & awk together:
#1a: sed -e 's/[a-zA-Z]*//g;s/^\([0-9]\)[0-9]*\([0-9]\)$/\1\2/' input.txt | awk '{if($1<10){sum+=$1$1} else{sum+=$1}}END{print sum}'
#1b: -sed -e 's/one/o1e/g;s/two/t2o/g;s/three/t3e/g;s/four/f4r/g;s/five/f5e/g;s/six/s6x/g;s/seven/s7n/g;s/eight/e8t/g;s/nine/n9e/g;s/[a-zA-Z]*//g;s/^\([0-9]\)[0-9]*\([0-9]\)$/\1\2/' inputd.txt | awk '{if($1<10){sum+=$1$1} else{sum+=$1}}END{print sum}'

{
    #1a. Remove all letters
    numbers_1a = $0
    gsub(/[a-zA-Z]/,"", numbers_1a)
    numdigits_1a = split(numbers_1a, numbers_1a_arr,"")
    sum_1a += (10 * numbers_1a_arr[1]) + numbers_1a_arr[numdigits_1a]

    #1b. Also factor in text numbers
    numbers_1b = mapTextToDigits($0)
    gsub(/[a-zA-Z]/,"", numbers_1b)
    numdigits_1b = split(numbers_1b, numbers_1b_arr,"")
    sum_1b += (10 * numbers_1b_arr[1]) + numbers_1b_arr[numdigits_1b]
}

END {
    print sum_1a
    print sum_1b
}

function mapTextToDigits(line) {
    DIGIT_MAP["one"] = "o1e"; DIGIT_MAP["two"] = "t2o"; DIGIT_MAP["three"] = "t3e";
    DIGIT_MAP["four"] = "f4r"; DIGIT_MAP["five"] = "f5e"; DIGIT_MAP["six"] = "s6x";
    DIGIT_MAP["seven"] = "s7n"; DIGIT_MAP["eight"] = "e8t"; DIGIT_MAP["nine"] = "n9e";
    for (digit in DIGIT_MAP) {
        gsub(digit,DIGIT_MAP[digit], line)
    }
    return line
}