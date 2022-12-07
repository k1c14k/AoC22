score = 0
ME_SCORES = {'X': 1, 'Y': 2, 'Z': 3}
ROUND_SCORES = {
    ('A', 'X'): 3,
    ('B', 'X'): 0,
    ('C', 'X'): 6,
    ('A', 'Y'): 6,
    ('B', 'Y'): 3,
    ('C', 'Y'): 0,
    ('A', 'Z'): 0,
    ('B', 'Z'): 6,
    ('C', 'Z'): 3,
}
ROUND_MAP = {
    ('A', 'X'): ('A', 'Z'),
    ('A', 'Y'): ('A', 'X'),
    ('A', 'Z'): ('A', 'Y'),
    ('B', 'X'): ('B', 'X'),
    ('B', 'Y'): ('B', 'Y'),
    ('B', 'Z'): ('B', 'Z'),
    ('C', 'X'): ('C', 'Y'),
    ('C', 'Y'): ('C', 'Z'),
    ('C', 'Z'): ('C', 'X'),
}

with open('day2/input.txt', 'r') as f:
    for ln in f.readlines():
        ln = ln[:-1]
        opponent, me = ln.split(' ')
        opponent, me = ROUND_MAP[(opponent, me)]
        score += ME_SCORES[me]
        score += ROUND_SCORES[(opponent, me)]
print(score)