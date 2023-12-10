#!/bin/awk -f
# run with awk -F' ' -f day8.awk input.txt

NR == 1 {
    instructions = $0
    next
}

NR == 2 {
    next
}

{
    #Get rid of special characters
    gsub(/[\(,\)=]/,"")
    mapping["L"][$1] = $2
    mapping["R"][$1] = $3
    # 8b save off XXA maps
    if ($1 ~ /[A-Z][A-Z]A/) {
        astarts = astarts" "$1
    }
}

END {
    split(instructions,instructionarr,"")
    #8a iteration
    start_8a = "AAA"
    goal_8a = "ZZZ"
    count_8a = traverse(start_8a, goal_8a)
    print count_8a

    #8b iteration
    goal_8b = "Z"
    split(astarts,astartsarr," ")
    for(astart in astartsarr) {
        count = traverse(astartsarr[astart], goal_8b)
        stepcounts = stepcounts" "count
    }
    split(stepcounts,stepcountsarr," ")
    for(c in stepcountsarr) {
        if(c == 1) {
            lastlcm = stepcountsarr[c]
            continue
        }
        lastlcm = lcm(lastlcm, stepcountsarr[c])
    }
    print lastlcm
}

function traverse(start, goal) {
    stepcount = 0
    while (start !~ goal"$") {
        for (direction_index in instructionarr) {
            direction = instructionarr[direction_index]
            start = mapping[direction][start]
            stepcount += 1
        }
    }
    return stepcount
}

function lcm(a, b) {
    return (a*b)/gcd(a,b)
}

function gcd(a, b) {
    while (b) {
        c = b
        b = a % b
        a = c
    }
    return a
}