
# | is a vertical pipe connecting north and south.
# - is a horizontal pipe connecting east and west.
# L is a 90-degree bend connecting north and east.
# J is a 90-degree bend connecting north and west.
# 7 is a 90-degree bend connecting south and west.
# F is a 90-degree bend connecting south and east.
# . is ground; there is no pipe in this tile.
# S is the starting position of the animal;

#compatible pipes:
# S <-> all
# | -> | L J 7 F (all but -)
# - -> - L J 7 F (all but |)
# L / J / 7 / F -> All but itself
BEGIN {
    MOVES["|"] = "UD"
    MOVES["-"] = "LR"
    MOVES["L"] = "UR"
    MOVES["J"] = "UL"
    MOVES["7"] = "DL"
    MOVES["F"] = "DR"
    MOVES["S"] = "UDLR"
    OPPOSITES["U"] = "D"
    OPPOSITES["D"] = "U"
    OPPOSITES["L"] = "R"
    OPPOSITES["R"] = "L"
}

{
    if ($0 ~ /S/) {
        S_row = NR
        S_col = match($0,/S/)
    }
    split($0, rowarr,"")
    for (i in rowarr) {
        data[NR][i] = rowarr[i]
    }
}

END {
    len = 0
    x = S_row
    y = S_col
    lastmove = ""
    # Get rid of opposite
    while ( current != "S" ) {
        current = data[x][y]
        # Keep options one-way by removing the opposite of the last move
        moveoptions = MOVES[current]
        gsub(OPPOSITES[lastmove],"",moveoptions)
        split(moveoptions,movesarr,"")
        for (move_ind in movesarr) {
            move = movesarr[move_ind]
            if (move == "U")      { nextx = x-1; nexty = y }
            else if (move == "D") { nextx = x+1; nexty = y }
            else if (move == "L") { nextx = x; nexty = y-1 }
            else if (move == "R") { nextx = x; nexty = y+1 }
            nexttile = data[nextx][nexty]
            # If the move is valid, make it
            if (match(MOVES[nexttile], OPPOSITES[move])) {
                len += 1
                current = nexttile
                lastmove = move
                x = nextx
                y = nexty
                break
            }
        }
    }
    print len/2
}