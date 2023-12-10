#!/bin/awk -f
# run with awk -F' ' -f day5a.awk input.txt

# Save seeds from line 1
NR == 1 {
    $1 = ""
    input = $0
    next
}

# Skip empty lines
$0 == "" {
    next
}

# If line starts with text, "restart" by replacing output with input
$1 ~ /^[a-z]/ {
    resetInputs()
    next
}

# for each input #, if x > $2 && x < $2+$3, set mapping[$x]=$1+x-$2
{
    split(input, inputs, " ")
    for (i in inputs) {
        inputseed = inputs[i]
        if(inputseed >= $2 && inputseed < ($2 + $3)) {
            mapping = $1 + inputseed - $2
            output = output" "mapping
            # remove match from input
            gsub(inputseed,"",input)
        }
    }
}

END {
    resetInputs()
    # iterate final values of output and return min
    split(input, finalmapping, " ")
    min = finalmapping[1]
    for (i in finalmapping) {
        if(finalmapping[i] < min) {
            min = finalmapping[i]
        }
    }
    print min
}

function resetInputs(){
    if(output) {
        # map remaining inputs to themself
        split(input, inputs, " ")
        for (i in inputs) {
            inputseed = inputs[i]
            output = output" "inputseed
        }
        input = output
        output = ""
    }
}