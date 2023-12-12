#\!/bin/awk -f
# Run with awk -F' ' -f day11.awk input.txt

{
    galaxiesinrow = 0
    # Save the location of all galaxies
    split($0, input, "")
    for (i in input) {
        if (NR==1) {numcols += 1} # Save the number of columns just once
        cell = input[i]
        if (cell == "#") {
            galaxies[NR][i] += 1
            galaxiesincol[i] += 1
        }
    }
    # Save the size of the grid
    numrows = NR
}

END {
    #double loop (r1,c1) (r2,c2), counting only when r2>=r1
    for (r1 = 1; r1 <= numrows; r1++) {
        for (c1 = 1; c1 <= numcols; c1++) {
            if(r1 in galaxies && c1 in galaxies[r1]) {
                for (r2 = r1; r2 <= numrows; r2++) {
                    for (c2 = 1; c2 <= numcols; c2++) {
                        if (r2 == r1 && c2 <= c1) {continue}
                        if(r2 in galaxies && c2 in galaxies[r2]) {
                            sum_a += calculateDistanceBetweenGalaxies(r1,c1,r2,c2,1)
                            sum_b += calculateDistanceBetweenGalaxies(r1,c1,r2,c2,999999)
                        }
                    }
                }
            }
        }
    }
    print sum_a
    print sum_b
}

function calculateDistanceBetweenGalaxies(r_1, c_1, r_2, c_2, expansion_factor) {
    movecount = 0
    for(x = r_1; x < r_2; x++) {
        movecount += 1
        if ( !(x in galaxies)) {
            movecount += expansion_factor
        }
    }
    #Flip coordinates if needed
    if(c_1 > c_2) {
        c_temp = c_1
        c_1 = c_2
        c_2 = c_temp
    }

    for(y = c_1; y < c_2; y++) {
        movecount += 1
        if ( !(y in galaxiesincol)) {
            movecount += expansion_factor
        }
    }
    return movecount
}