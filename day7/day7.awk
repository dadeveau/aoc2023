#!/bin/awk -f
# run with awk -F' ' -f day7.awk input.txt

# Handclass CountUnique ProductOfCounts (Counts)
# "5OAK" 1 5 (5)
# "4OAK" 2 4 (4 1)
# "FH" 2 6 (3 2)
# "3OAK" 3 3 (3 1 1)
# "2P" 3 4 (2 2 1)
# "P" 4 2 (2 1 1 1)
# "HC" 5 1 (1 1 1 1 1)

# 7b Joker improvements:
# HC 1J -> P
# P 1J+ -> 3OAK
# 2P 1J -> FH
# 2P 2J -> 4OAK
# 3OAK 1J+ -> 4OAK
# FH 1J+ -> 5OAK
# 4OAK 1J+ -> 5OAK

BEGIN {
    HAND_CLASSES = "HC P 2P 3OAK FH 4OAK 5OAK"
    DECK_LOW_TO_HIGH_7a = "2 3 4 5 6 7 8 9 T J Q K A"
    DECK_LOW_TO_HIGH_7b = "J 2 3 4 5 6 7 8 9 T Q K A"
}
{
    # Iterate each line, Adding each letter to an array of counts by card, handcounter
    hand = $1
    split(hand, handcards, "")
    Jcount = 0
    for (card in handcards) {
        currentcard = handcards[card]
        handcounter[currentcard] += 1
        if(currentcard == "J") {
            Jcount +=1
        }
    }

    # The number of unique cards and the product of the counts is sufficient to classify the hand
    count_unique_cards = 0
    product_of_cardcounts = 1
    for (uniquecard in handcounter) {
        count_unique_cards += 1
        product_of_cardcounts *= handcounter[uniquecard]
    }
    delete handcounter

    #Classify the hand by the unique cards & product of cardcounts (7b & Jack counts)
    if (count_unique_cards == 1) {
        class = "5OAK"
        classb=class
    } else if (count_unique_cards == 2 && product_of_cardcounts == 4) {
        class = "4OAK"
        Jcount > 0 ? classb = "5OAK" : classb = class
    } else if (count_unique_cards == 2 && product_of_cardcounts == 6) {
        class = "FH"
        Jcount > 0 ? classb = "5OAK" : classb = class
    } else if (count_unique_cards == 3 && product_of_cardcounts == 3 ) {
        class = "3OAK"
        Jcount > 0 ? classb = "4OAK" : classb = class
    } else if (count_unique_cards == 3 && product_of_cardcounts == 4 ) {
        class = "2P"
        if(Jcount == 1) {
            classb = "FH"
        } else if(Jcount == 2) {
            classb = "4OAK"
        } else {
            classb = class
        }
    } else if (count_unique_cards == 4) {
        class="P"
        Jcount > 0 ? classb = "3OAK" : classb = class
    } else if (count_unique_cards == 5) {
        class="HC"
        Jcount > 0 ? classb = "P" : classb = class
    } else {
        print "ERROR: Invalid hand detected"
    }
    handmappings[class][handcards[1]][handcards[2]][handcards[3]][handcards[4]][handcards[5]] = $2
    handmappingsb[classb][handcards[1]][handcards[2]][handcards[3]][handcards[4]][handcards[5]] = $2

} END {
    split(HAND_CLASSES,handclassesarr," ")
    print calculateEarnings(DECK_LOW_TO_HIGH_7a, handmappings)
    print calculateEarnings(DECK_LOW_TO_HIGH_7b, handmappingsb)
}

function calculateEarnings(deck_low_to_high, handmap){
    split(deck_low_to_high,allcards," ")
    earnings = 0
    multiplier = 1
    # Iterate from worst to best handclass, from low to high cards
    for (h in handclassesarr) {
        handclass = handclassesarr[h]
        if (! handclass in handmappings) { continue }
        for (j in allcards) {
            if (! j in handmappings[handclass]) { continue }
            card1 = allcards[j]
            for (k in allcards) {
                card2 = allcards[k]
                for (l in allcards) {
                    card3 = allcards[l]
                    for (m in allcards) {
                        card4 = allcards[m]
                        for (n in allcards) {
                            card5 = allcards[n]
                            earning = (multiplier * handmap[handclass][card1][card2][card3][card4][card5])
                            if (earning > 0){
                                earnings += earning
                                multiplier +=1
                            }
                        }
                    }
                }
            }
        }
    }
    return earnings
}