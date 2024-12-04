# AoC 2024

A repo for my efforts for AoC 2024. Here we go again.
Here's what its all about: [[aoc2024](https://adventofcode.com)]

The _"comments"_ like this for each day are header comments from my code. For the first time ever I've joined a private leaderboard, so I'm curious to see how that plays out. I'm once again feeling that being in GMT is a poor choice of longitude: the folks west over the ocean can do it before bedtime, the folks a couple of hours east can have breakfast first. For the record - I fie upon your breakfast.

## Day 1 - Historian Hysteria

[PERL, RAKU, VERILOG]

_"Massive props to Eric for another year of near-insanity in the pursuit of superior code skillz. For the avoidance of doubt - the comments were written afterwards, and the print debug
 removed... i'm not that professional. fo real."_

This was a suitable day 1 challenge, just grokking input and searching a list. Couple of interesting things for me: firstly that i messed up using a grep for part2 initially because of a stupid typo caused by my eyes being closed at 5am. 
The other is that I used an untyped sort, which assumes the inputs are strings. The correct way to do this would be the spaceship operator ```<=>``` to force numerical sort, but for my input file, it worked anyway. I can imagine cases where it might not.

For practice, I made the raku equivalent after submission.

### Behavioural Verilog 

Each year, I try to consider which day problem would work as a pure hardware solution, and if i get close, might do it. This was a stupid idea I had during Advent of Code a few years back where some Elves had an unconventional ALU (Monad?) and I wanted to see if would work. 

Anyway, TDLR; - I have written behavioural verilog that solves both parts of day 1. You will need a verilog simulator to run it.
I chose day 1 already because the input looks like a memory map. The only slight-of-hand is that it needs to be converted to hex first (i've added a utility for making a proper memory file, but you can directly use converted values.)
It assumes your inputs fit in single-length integers.
The barrier here is implementing bubble sort in hardware, which
is totally doable but is easiest with microcode, at which point this
behavioural model isn't even close. 

If I have time I'll get it done with a counter and a pair of registers. _Do not hold your breath._

## Day 2 - Red-Nosed Reports

[PERL]

_"Day 2 always comes far too soon after day 1."_

This took me much longer than the code would have you believe. I tried to be too clever in part 1, and had a counter for the ways in which each report was invalid. Superficially, just changing my threshold tolerance from 0 to 1 for 'errors' would solve part 2, but that quickly unravelled.

Had to leave for school run and meetings, and did it quickly having thought about it on the walk. What's left is an ugly brute-force iteration over the possible arrays, and I'm not inspired to find a sneakier way. Comments added to the part 2 function so I remember later how it works ;)

Probably the only interesting thing from a language standpoint is assembling an array using another array holding a set of indices:
```
my @newarr = @arr[ @idxlist ];
```

## Day 3 - Mull It Over

[PERL]

 _"YES! Finally a regex day, this is my wheelhouse."_

 Fully straightforward parsing test, about which there is little to say tbh.
 I did fall into the obvious gotcha of having operations broken over 
 multiple lines, but that was a quick fix by using _slurp mode_, which is a way of grabbing an entire file into a single string ignoring line breaks.
 This is achieved (in perl, and elsewhere) by removing the record separator, thus:
 ```
 $/ = undef;
 ```
 The rest is self-explanatory.

 ## Day 4 - Ceres Search

 [PERL]

 _"An inelegant shambles."_

I started late, I took an age, I had several false starts, and it was a
 shambles. Doing the following is inelegant, but it worked well because 
 the search strings are short.

 in part 2 i was allowing every possible kind of crossing, which after
 reading the instructions again made it much easier - just deleted a 
 bunch of checks. the only interesting thing here was inverting the usual
 trick to uniqify an array, to instead report only elements that were duplicated.
 