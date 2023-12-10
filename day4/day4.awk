#! /bin/awk -f
# Run with awk -F' ' -f day4.awk input.txt

{
  # 1 pass solution. This code executes on every row (-F ' ')
  matchcount = 0
  cardcount[NR]+=1
  # Save the winning numbers
  for(winindex = 3; winindex < 13; winindex++) {
    winners[NR][$winindex] = 1
  }

  # Tally the winning numbers
  for(numindex = 14; numindex <= NF; numindex++) {
    if($numindex in winners[NR]) {
      matchcount+=1
    }
  }

  # 4a. Tally points
  if(matchcount>0) {
    sum_4a += 2 ^ (matchcount-1)
  }

  # 4b. For each of the cardcount[NR] NR cards, increment the NR+1..NR+matchcount card counts
  for(numcards = 1; numcards <= cardcount[NR]; numcards++) {
      for(n = 1; n <= matchcount; n++) {
          cardcount[NR+n]+=1
      }
  }

} END {
  print  sum_4a
  # 4b. Iterate card counts
  for(card in cardcount) {
      sum_4b += cardcount[card]
  }
  print sum_4b
}