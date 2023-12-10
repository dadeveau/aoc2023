#\/bin/awk -f
# run with awk -F' ' -f day9.awk input.txt

{
    row = $0
    firstnumbers = $1
    lastnumbers = $NF
    # Continue until the row is all zeros
    while (row !~ /^(0 )*$/) {
        split(row,rowarr," ")
        for (i in rowarr) {
            if ( i == 1 ) { continue }
            diff = (rowarr[i] - rowarr[i-1])""
            diffs = diffs diff" "
            if ( i == 2 ) {
                firstnumbers = firstnumbers" "diff
            }
        }
        row = diffs
        diffs = ""
        # Keep track of the last diff of each round
        lastnumbers = lastnumbers" "diff
    }
    # Now that the row is all 0s, sum all lastnumbers
    split(lastnumbers,resulttosum," ")
    for(r in resulttosum) {
        sum_3a += resulttosum[r]
    }
    split(firstnumbers,resulttosum," ")
    for(r in resulttosum) {
        if (r == 1) {
            newfirstval = resulttosum[r]
            continue
        }
        if ( r % 2 == 0) {
            newfirstval -= resulttosum[r]
        } else {
            newfirstval += resulttosum[r]
        }
    }
    sum_3b += newfirstval
}

END {
    print sum_3a
    print sum_3b
}