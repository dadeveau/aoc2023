#!/bin/awk -f
# run with awk -F' ' -f day6.awk input.txt

/^Time:/ {
    $1=""
    split($0,times," ")
}

/^Distance:/ {
    $1=""
    split($0,distances," ")
}

END {
    TUPLE_DELIM = ","
    sumA = 1
    for(i in times){
        sumA *= countWinners(times[i], distances[i])
        timeB = timeB""times[i]
        distanceB = distanceB""distances[i]
    }
    print sumA
    sumB = countWinners(timeB, distanceB)
    print sumB
}

function solveQuadratic(a, b, c){
    root = (b^2 - 4*a*c) ^ (1/2)
    x1 = (-b + root) / 2*a
    x2 = (-b - root)/ 2*a
    return sprintf("%f%s%f",x1,TUPLE_DELIM,x2)
}

function countWinners(time, record) {
    solution = solveQuadratic(-1, time, -record)
    split(solution,solutions,TUPLE_DELIM)
    # round up the low answer, and round down the high
    if (solutions[1] < solutions[2]) {
        minfloat = solutions[1]
        maxfloat = solutions[2]
    } else {
        minfloat = solutions[2]
        maxfloat = solutions[1]
    }
    minfloat > int(minfloat) ? roundup = 1 : roundup = 0
    min = int(minfloat) + roundup
    max = int(maxfloat)
    return max-min+1
}