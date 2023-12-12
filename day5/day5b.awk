#!/bin/awk -f
# run with awk -F' ' -f day5b.awk input.txt

# Line 1: Save ranges to inputrange
NR == 1 {
    $1 = ""
    split($0,seeds," ")
    for(i in seeds) {
        if (i % 2 == 0) {
            rangemin = int(seeds[i-1])
            rangemax = rangemin + int(seeds[i]) - 1
            inputrange[rangemin] = rangemax
        }
    }
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

{
    mapmin = int($2)
    mapmax = int($2 + $3 - 1)
    destinationstart = int($1)
    for (i in inputrange) {
        inputmin = int(i)
        inputmax = int(inputrange[inputmin])
        #If out of range, skip
        if (inputmax < mapmin || inputmin > mapmax) {
            continue
        }

        # In range, so delete input
        rangestodelete[inputmin] = inputmax

        # Add non-overlapping range below as a new range
        if (inputmin < mapmin) {
            rangestoadd[inputmin] = mapmin - 1
            inputmin = mapmin
        }

        # Add non-overlapping range above as a new range
        if (inputmax > mapmax) {
            rangestoadd[mapmax + 1] = inputmax
            inputmax = mapmax
        }

        # now, the full input range will be within the mapping
        destinationmin = destinationstart + inputmin - mapmin
        destinationmax = destinationstart + inputmax - mapmin
        outputrange[destinationmin] = destinationmax
    }
    # Add the new inputranges out of the inputrange iteration for safety
    for (d in rangestodelete) {
        delete inputrange[d]
    }
    delete rangestodelete
    for (r in rangestoadd) {
        inputrange[r] = rangestoadd[r]
    }
    delete rangestoadd
}

END {
    resetInputs()
    # iterate final map keys and return min
    for (rangemin in inputrange) {
        min = int(rangemin)
        break
    }
    for (rangemin in inputrange) {
        if(int(rangemin) < int(min)) {
            min = rangemin
        }
    }
    print min
}

function resetInputs() {
    # put output mappings into the next round of inputs
    for (outputmin in outputrange) {
        inputrange[outputmin] = outputrange[outputmin]
    }
    delete outputrange
}
