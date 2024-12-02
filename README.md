# AoC 2024

A repo for my efforts for AoC 2024. Here we go again.
Here's what its all about: [[aoc2024](https://adventofcode.com)]

The _"comments"_ like this for each day are header comments from my code. For the first time ever I've joined a private leaderboard, so I'm curious to see how that plays out. I'm once again feeling that being in GMT is a poor choice of longitude: the folks west over the ocean can do it before bedtime, the folks a couple of hours east can have breakfast first. For the record - I fie upon your breakfast.

## Day 1 - Historian Hysteria

[PERL]

_"Massive props to Eric for another year of near-insanity in the pursuit of superior code skillz. For the avoidance of doubt - the comments were written afterwards, and the print debug
 removed... i'm not that professional. fo real."_

This was a suitable day 1 challenge, just grokking input and searching a list. Couple of interesting things for me: firstly that i messed up using a grep for part2 initially because of a stupid typo caused by my eyes being closed at 5am. 
The other is that I used an untyped sort, which assumes the inputs are strings. The correct way to do this would be the spaceship operator ```<=>``` to force numerical sort, but for my input file, it worked anyway. I can imagine cases where it might not.

## Day 2 - 

[PERL]

_"  "_

Day 2 always comes far too soon after day 1. 
This took me much longer than the code below would have you believe. I tried to be too clever in part 1, and had a counter for the ways in which each report was invalid. Superficially, just changing my threshold tolerance from 0 to 1 for 'errors' would solve part 2, but that quickly unravelled.

Had to leave for school run and meetings, and did it quickly having thought about it on the walk. What's left is an ugly brute-force iteration over the possible arrays, and I'm not inspired to find a sneakier way. Comments added to the part 2 function so I remember later how it works ;)

## Day 3 - 

