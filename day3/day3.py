import re;

VALID_SYMBOLS = {'!','@','#','$','%','^','&','*','-','=','+','/'}
day3_pattern=re.compile('([\d]+)|([!@#$%&*\-+=\/]+)')
symbols_found = {}
numbers_found = {}
asterisk_matches = {}

def day3asolver():
    sum = 0
    day3file = open('input.txt', 'r')
    inputlines = day3file.readlines()
    for row,line in enumerate(inputlines):
        #iterate matches
        for match in re.finditer(day3_pattern, line):
            if match.group() in VALID_SYMBOLS:
                if match.group() == "*":
                    asterisk_matches[match] = []
                sum += check_symbol_for_adjacent(match, row)
            else:
                sum += check_number_for_adjacent(match, row)
    return sum

def check_symbol_for_adjacent(symbol_match, row):
    sum = 0
    ind = symbol_match.start()
    # add to map
    if not row in symbols_found:
        symbols_found[row] = {}
    symbols_found[row][ind] = symbol_match
    if row-1 in numbers_found:
        for i in range(ind-1, ind+2):
            if i in numbers_found[row-1]:
                match = numbers_found[row-1][i]
                sum += int(match.group())
                if symbol_match.group() == "*":
                    asterisk_matches[symbol_match].append(int(match.group()))
                remove_numbermatch_from_found(match,row-1)
    if row in numbers_found:
        if ind-1 in numbers_found[row]:
            match = numbers_found[row][ind-1]
            sum += int(match.group())
            if symbol_match.group() == "*":
                asterisk_matches[symbol_match].append(int(match.group()))
            remove_numbermatch_from_found(match,row)
    return sum

def check_number_for_adjacent(number_match,row):
    # check for symbols above
    if row-1 in symbols_found:
        for i in range(number_match.start()-1, number_match.end()+1):
            if i in symbols_found[row-1]:
                if symbols_found[row-1][i].group() == "*":
                    asterisk_matches[symbols_found[row-1][i]].append(int(number_match.group()))
                return int(number_match.group())
    #check for symbols left
    if row in symbols_found:
        if number_match.start()-1 in symbols_found[row]:
            if symbols_found[row][number_match.start()-1].group()=="*":
                asterisk_matches[symbols_found[row][number_match.start()-1]].append(int(number_match.group()))
            return int(number_match.group())
    # else, add it to list but return 0
    if not row in numbers_found:
        numbers_found[row] = {}
    for i in range(number_match.start(), number_match.end()):
        numbers_found[row][i] = number_match
    return 0   

def remove_numbermatch_from_found(number_match,row):
    for i in range(number_match.start(), number_match.end()):
        del numbers_found[row][i]

def day3bsolver():
    sum = 0
    for asteriskmatch in asterisk_matches:
        matchlist = asterisk_matches[asteriskmatch]
        if len(matchlist) == 2:
            sum += (matchlist[0] * matchlist[1])
    return sum

print(day3asolver())
print(day3bsolver())
