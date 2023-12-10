import re

all_counts_pattern = re.compile('Game (?P<game>[\d]+)|(?P<red>[\d]+) red|(?P<green>[\d]+) green|(?P<blue>[\d]+) blue')

def day2solver(solver):
    sum = 0
    day1 = open("input.txt", 'r')
    lines = day1.readlines()
    for line in lines:
        list_of_counts = all_counts_pattern.findall(line)
        game_id = int(list_of_counts[0][0])
        max_red = 0
        max_green = 0
        max_blue = 0
        for counts in list_of_counts:
            if counts[1]:
                max_red = max(max_red, int(counts[1]))
            if counts[2]:
                max_green = max(max_green, int(counts[2]))
            if counts[3]:
                max_blue = max(max_blue, int(counts[3]))
        sum += solver(game_id, max_red, max_green, max_blue)
    return sum

red_limit = 12
green_limit = 13
blue_limit = 14

day2a = lambda c,r,g,b: c if (r <= red_limit and g <= green_limit and b <= blue_limit) else 0
day2b = lambda c,r,g,b: r*g*b

print(day2solver(day2a))
print(day2solver(day2b))