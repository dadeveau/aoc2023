import re

LETTERS_TO_DIGITS = {
    "one": 1,
    "two": 2,
    "three": 3,
    "four": 4,
    "five": 5,
    "six": 6,
    "seven": 7,
    "eight": 8,
    "nine": 9,
}

def clean_match(match):
    if match in LETTERS_TO_DIGITS:
        match = LETTERS_TO_DIGITS[match]
    return int(match)

def day1solver(pattern):
    sum = 0
    day1 = open("input.txt", 'r')
    lines = day1.readlines()
    for line in lines:
        match = 1
        index = 0
        firstmatch = 1
        while match:
            match = pattern.search(line, index)
            if match:
                lastmatch = match.group(0)
                index = match.start() + 1
                if firstmatch:
                    sum += 10 * clean_match(match.group(0))
                    firstmatch = 0
        sum += clean_match(lastmatch)
    return sum

def day1a():
    return day1solver(re.compile('[1-9]'))

def day1b():
    return day1solver(re.compile('([1-9]|one|two|three|four|five|six|seven|eight|nine)'))

print(day1a())
print(day1b())