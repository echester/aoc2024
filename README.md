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
```perl
my @newarr = @arr[ @idxlist ];
```

## Day 3 - Mull It Over

[PERL]

 _"YES! Finally a regex day, this is my wheelhouse."_

 Fully straightforward parsing test, about which there is little to say tbh.
 I did fall into the obvious gotcha of having operations broken over 
 multiple lines, but that was a quick fix by using _slurp mode_, which is a way of grabbing an entire file into a single string ignoring line breaks.
 This is achieved (in perl, and elsewhere) by removing the record separator, thus:
 ```perl
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
 
## Day 5 - Print Queue

[PERL]

_"Print debug rUleZ "_

... and that's all i have to say about that. Not.
Today was the day I needed a CPAN module and i discovered my whole
environment was borked. Installed a fresh VM for part 2.
Binned it. Swapped machines.
Secure erased disk in primary workstation. Reinstalled environments.
THAT'S what i think about AoC today. If H wasn't off school with 
a vomitting bug I'd be as frustrated as a woodpecker with a rubber beak,
but as it happens, dealing with all this was kinda fun. In the
limit where 'kinda' takes very, very small values.

After solving part2, it became clear that my approach for part1 was grossly 
inefficient - i was focussed on the update pages and not the rules. I've kept
it as a monument called _Too Many Loops_, and added a 'v2' update which runs over 10x faster.

## Day 6 - Guard Gallivant

[PERL]

_"Could really have done without another grid straight away, but hey-ho(-ho-ho)."_

This was also the first time that a hash looked immediately like the right thing
to do, because even though part 1 looked like it was solvable by popping some values
into a list of locations, I was suspicious that part2 might need to know a bit more
about each location. As such, over-engineered part1 and this (part 1, v2) is a cleaned 
up version pared back somewhat. As it worked out, part2 flumoxed me for a while: I
tried just looking for a large number of moves being exceeded as some threshold for
looping, but that's shoddy. Instead of looking at where the guard has been, it now tracks
where she's been and which was she was heading when arriving there. Simples. (As if).

This whole block of code dealing with the guard turning right is pretty lame, I should have done something with counting blockages-modulo-4.
```perl
if ($nh->{block} == 1) {
		# blocked, turn to the right
		if ($dir eq '^') { $dir = '>'; }
		elsif ($dir eq '>') { $dir = 'v'; }
		elsif ($dir eq 'v') { $dir = '<'; }
		elsif ($dir eq '<') { $dir = '^'; }
```
Some time later... so that sucked, and was replaced by this, which is far
swishier:
```perl
if ($nh->{block} == 1) { push @move, shift @move; }
```
because i dropped the keys from the %move hash and just now have an ordered list to rotate through as the guard meets a blockage. Tidy.

## Day 7 - Bridge Repair

[PERL]

_"Whoop ops up the combomatch parsetree to cross a crapbridge..."_

I love this kind of puzzle: easy, no gotchas, no weird background knowledge
required other than how to permute a set of objects. Part 2 was a pleasingly
trivial extension to part 1. Very much my wheelhouse.

Now obviously I could have implemented my own operator-combination-generator-tron
and i almost did using a binary scheme, but was wary of falling in a trap for part 2.
Now that I know its not a problem, I _might_ go back and do that just to remove the
dependency on the `Algorithm::` module.

Here's the core of the thing, which is nice and compact:
```perl
foreach (variations_with_repetition(\@ops, -1 + scalar @v)) {
	if (calc (\@v, $_) == $r) { $total += $r; last; }
}
```

There's an obvious optimisation I didn't implement (yet): you don't need to calculate the value for each entry row using all the operators and operands - you can skip any of that after you already know its not going to match the target value on the left. Its not a big deal, but would make it even faster.

Part 2 was a 1-line change, which is a nice relief; just handling a fresh operator:
```perl
elsif ($o eq 'c') { $r .= $v; }
```
It all reminded me of day 9 part 2 in 2023 where there's a subtle change that could ruin everything, or if you were lucky with your approach to part 1, a trivial solution to part 2. More of these please, before it gets harder...

## Day 8 - "Resonant Collinearity"

[PERL]

This is not how antennas work, for the record.

This took far longer than it ought to have, and I made excessive use of print debug.
The challenge is fair, but was deliberately described in a complex way, possibly to
thwart AI solvers.

For part 2, I failed to consider the zeroth order harmonic, so was off by the number
of antennas for a long time. The code does both parts with a switch in the code, and there's nothing to
proud of anywhere in sight. My main laziness was to not bother properly loading and dereferencing arrays in perl, so because they are only coordinates, I did my usual thing of just using strings of coords joined by `_`:
```perl
sub j { return join '_', @_; }
```
Sure, it means adding some `split` functions hither and thither, but otherwise I'd be adding hash subscripts and dereferences and when i'm asleep that's just unnecessary work. 

There is a simplication here that I could easily make: we don't need a hash because we don't care what the frequencies (antenna types) are: we could just stuff their locations into an array of arrays. Can I be bothered? Nope.

_Afterthought_ - the initial working version of this used `Algorithm::Combinatorics` because really, why not?. 
The final version ditched it and included my own pair-wise index generator, thus:
```perl
sub duos {
	my $n = shift;
	my @d;
	for (my $i=0; $i<$n; $i++) {
		for (my $j=0; $j<$n; $j++) {
			push @d, j($i,$j) unless $i==$j;
		}
	}
	return @d;
}
```
Yes, it uses `j` and supports my Library Of Laziness.

## Day 9 -

[PERL]

One third of the way through this `misery||fun`.


## Day 10 - Hoof It

[PERL]

Urgh. DFS. or BFS, depending whether i can remember which would be better here.
But then I wrote it, and actually recursion wasn't necessary, just a queue of places to check,
and it was weirdly easy. The first cut which worked used a 2D array to hold values, but the locations
didn't matter, and to make the helper functions easier I rewrote it using row_col as hash keys.
This was a weird one though - solved part2 before part1, and had to undo a change for part2.
Not sure there's anything interesting in the code today. If I'd been using something contemporary,
there'd be a cleaner way to get the intersection of two arrays. For completeness, here's my
intersection routine, which is _kinda_ idiomatic:
```perl
sub intersect {
	my ($ar, $br) = @_;
	my @set;
	my %count = ();
	foreach (@$ar, @$br) { $count{$_}++; }
	foreach my $e (keys %count) { push @set, $e if ($count{$e} > 1); }
	return @set;
}
```
I liked today. The first of the path finding problems, more to come. One day soon it'll be _A*_.

### Optimising Day 10

So in the discord I am in this year there are galaxybrainfolx who compare their execution times, measured in 10s of milliseconds.
My code, which I thought pretty clean, took 4.5 _seconds_, around 1000 times slower. Now in fairness, i'm using an interpreted language,
and inside a virtual machine with a single slow processor, but this was clearly naff.

For the first time since working on the Beagle-2 mission, I profiled my code - and it was far easier and useful than it ever used to be.
`Devel::NYTProf ` is a spectacularly good profiler for perl, which showed me immediately where the biggest problem was. Check this out:
```perl
while (@path) {
		my $h = pop @path;
		push @peaks, $h if ($map{$h} == 9);
		my @next = adj($h, $#map, $#map);
		my @valid = findlevel($map{$h} + 1); # <-- !!!!
		push @path, $_ foreach intersect(\@next, \@valid);
	}
```
... at the line with the !!!! comment, I'm searching the whole map to get the set of nodes at a certain level, and in that loop, I do it
every time I arrive at a node. But the levels don't change, and there are only 10 levels - so v2 of the code removes this and evaluates
all 10 sets before starting to explore the map, and then it just looks up the answer. Its kinda what the young-uns call `memoization` (I _think_).
This saved 85% of the execution time. Re-profiling it shows that the `intersect()` routine above dominates now _by far_. So, I'm expecting
`Array::Utils` or `List::Utils` to improve upon that further.

The profiler steps (because I will forget them otherwise) were:
```bash
$ perl -d:NYTProf aoc2024-10-v2.pl input.txt # profile the code
$ nytprofhtml --open 					# then open the index.html report
$ dot -Tsvg nytprof/subs-callgraph.dot   # optional graph generator
```

This was pleasingly straightforward, and there's a real risk I might do it again. Here's the 2nd profiler run, for fun:

![screengrab of part of profiler output](https://github.com/echester/aoc2024/blob/main/10/profiler.png?raw=true)

In the (list of things I learned today)++ - here's me putting an image in a github readme. Colour me chuffed.

## Day 11 - Plutonian Pebbles

[PERL]

_"I will try anything at all, no matter how likely to be fruitless or time consuming, before actually resigning myself to writing a recursive function :/_

_Is this an effective strategy? Hell no._

This was hard. A classic AoC bigint, nonlinear, exponential growth kinda hard. Part 1 trivial, or nearly trivial anyway provided you are awake and ignore a lot of the information in the instructions.

Part 2 history unfolded thus:
- just try brute force. Whoa.
- total rewrite using a list of engravings (stone values) instead of a list of stones. This was *way* better but the problem with exponentials is that if even you start further down the curve, you quickly catch up to the miserable high values you had before. My run borked out at a quarter of a billion different stone engravings after only 41 blinks. Not remotely close.
- total rewrite using recursion which i loathe, but here it was necessary. The key realisation here is that any stone has no effect upon any other stone, all it does is generate more stones itself. We don't care how many there are of each type, so the hashmap i built in the previous attempt doesn't exist, so can't grow exponentially. Phew! I had to read up on how to make recursion work in perl, and this took a couple of goes. I wanted to set it in a loop, but you have to kind of let go of this and trust the force. The tracking variable inside the `blink()` call stops each stone when it reaches the max number of blinks, and then counts just itself.

Now then, this runs, but by testing on small numbers of blinks beyond 25 (27, 29) - it was clearly still going to run for _freakin ages_. `blink()` spends a lot of its time evaluating stone evolution for starting stones it has already seen... so then had to learn about memoization in perl, which i have never actually used.

Massive props to someone called Mark Jason Dominus who wrote a CPAN module called `Memoize`, and hot damn it does exactly what you want, without any fuss or configuration or anything. I'll definitely profile this afterwards, because the whole thing takes no time at all when its used, and many many minutes when it isn't. This is likely to be a game-changer in future puzzles! It's this easy to use:
```perl
use Memoize;
memoize('blinklikeafreak');
```

## Day 12 -

_ongoing shambles_

## Day 13 - Claw Contraption

[PERL]

_Oh my days I was really expecting this to be an application of Chinese Remainder Theorem,
which I would have implemented incorrectly and then given up on._

As it was, this is a straightforward simultaneous equation solution solved with row-echelon
reduction. I did have to look up what you do instead of determinants, but the 2 sub-determinants
work well and are used directly anyway. Tidy.

(Just as well because i'm still debugging part 2 of yesterday and its major t!MeSuXoR)

## Day 14 - Restroom Redoubt

[PERL]

Very much a straightforward part 1 just moving robots around a wrapped grid. Part 2 felt impossible
or unfair until I looked back at the crazy LED display stuff from previous years and wondered
what Eric's tree might look like. Here's the line that does the job in my part 2 code:
```perl
do { move(); $i++;} until (lookslikeathingericthinkslookslikeatree());
```
where `lookslikeathingericthinkslookslikeatree()` is waiting for a line to contain a load of consecutive robots.
I started with a line of 6, but this didn't look like a tree, so arbitrarily raised it to 8 and expected to go
higher, but 8 worked fine :) Here's my tree:

![robots aligning as a tree picture](https://github.com/echester/aoc2024/blob/main/14/tree.png?raw=true)

## Day 17 - Chronospatial Computer

[PERL]

_"This took literally all day. I hate it. All the more because I loved part 1."_

Instead of actual discussion here, I'm going to just paste the code, remove the code, and leave the comments. That'll indicate how I felt about it.

```perl
# Without a doubt the hardest day 17 i've ever done, and I've done some fairly epic hikes.
# enable bitwise fiascos
# just to grab the lowest value at the end
# registers
# program
# stack pointer
# part 1
# part 2
# loop over output values from the end
# store found possibles
# loop over the set of previous possibles
# loop over all of the following 8 values above the possible
# get the subset of the program to check against
# stringify them because I CANNOT BE BOTHERED TO IMPLEMENT ARRAY COMPARISON, OK??!?!?!
# get the actual output running with this possible target value
# check if the machine output matches the expected program subset
# sodding smartmatch is deprecated. wonder why.
# empty the possibility list
# empty your soul into your bin of hopes
# and drop the new folx into it - YES I SHOULD BE USING SPLICE BUT I'M FREAKING WORN OUT BY THIS PUZZLE
# get start value
# initialise stack pointer
# output digit list
# run like a lizard on hot soup
# bork if the stack pointer's left the arena
# grab instruction and operand from the list
# ugly switch thing to call relevant operation sub
# shuffle along to the next instruction
```

In fairness, there are some neat little bits of code that do all the fun things from part 1:
```perl
sub adv { $a = $a >> combo(shift); }
sub bdv { $b = $a >> combo(shift); }
sub cdv { $c = $a >> combo(shift); }
sub bxl { $b = $b ^ shift; }
sub bst { $b = combo(shift) % 8;}
sub jnz { $j = shift() - 2 unless !$a; }
sub bxc { $b = $b ^ $c; }
sub out { my ($ar, $x) = @_; push @$ar, combo($x) % 8; }
```

Are they worth it? Absolutely not.

## Day 18 - RAM Run

[PERL]

Edsger Dijkstra is the DUDE. Today's solution was made mostly by deleting stuff from day 16.
The input parsing needed to be changed up, and then tweaked for part 2.
I made a _super classic n00b-asshat error_: my `clean()` function below started out being called
`reset()` to restart the dijkstra. But... `reset` is a reserved word as its a perl function (that
I've never used): it clears variables and pattern matches so they can be used again.
Part 1 code got cleaned up just a little, and part 2 is just about putting part 1 in a loop
with an ever-growing list of obstacles. Given it takes about a second to solve a single map,
I used a coarse binary search using part 1 code to move the starting point to within 10 nodes
(bytes) of the answer.

***NOTE TO FUTURE SELF*** This works in row,column order, which is backwards compared to the input.
You *absolutely will* screw up in the future because of this, but you can't say you weren't warned.

I'm going to drop my dijk routine in here because i will almost certainly want it and i'll want it
to be easier to find. It needs `genEdges()` and `clean()` to initialise stuff before it works. And,
obviously, the data structures for valid nodes and obstructions. And start and end. And a SHEDTON of
following wind karma, and the blessing of a flock of path-routing faeries. There you go; that was warning \#2.
```perl
sub dijk {
	my ($from, $to) = @_;
	while (my $here = $stack->pop()) {
		if ($here eq $to) { return $nodes{$to}->{dist}; };
		$nodes{$here}->{v} = 1;
		foreach my $next (@{$nodes{$here}->{edges}}) {
			next if ($nodes{$next}->{v} == 1);
			my $newdist = $nodes{$here}->{dist} + 1;
			my $d = $nodes{$next}->{dist};
			if ($newdist < $d) {
				$nodes{$next}->{dist} = $newdist;
				$stack->insert($next, $newdist);
			}
		}
	}
	return -1;
}
```

## Day 19 - Linen Layout

[PERL]

_"I only need 3 more stars to have beaten my performance last year, and
then I can safely put this whole basket of nonsense down."_

I started this with a _very elegant_ validity matrix approach, but it was very
quickly thwarted by the real input data, because there are cases where a given
sequence (even a long one) is only valid with things either side of it, even
if the sequence itself is valid... which... smells... like.... recursion.

My old nemesis.
Even the old nemensis of Old Harry Dwmpus. Feck.

Immediately, its a pain. And its slow, so break out memoization in the forlorn
hope of base case exit redemption. Part 1 acceptably fast. Part 2, not so much.
And then, while making a cup of tea, the five-head-slap moment when i realised
I hadn't memoized my part2 function. Its actually pretty decent now.
Star star, tick tick, bosh bosh.

I cleaned up the code to use a single function for both part 1 and part 2 because it was so similar, even if it means the very inefficient solving of part 1 by iterating WAY more than needed. Still, its acceptably swift, and I'd rather have less code.

Took the opportunity to rename my function as well:
```perl
memoize('countMyFunkyTowelsNowSirOhYes');
```

I liked this, because it was a clean algorithmic challenge which pushed me
enough into the incorrect way at first that I had to pencil it out.

### Cleanup

There were some obvious unperly things to get rid of after part 2. Here's the shorter function, which i'm happy with.
```perl
sub countMyFunkyTowelsNowSirOhYes {
	my ($d, $pref) = @_;
	my $count = 0;
	return 1 unless length $d;
	foreach (@{$pref}) {
		$count += (countMyFunkyTowelsNowSirOhYes(substr($d, length), $pref)) unless (index($d, $_));
		}
	return $count;
}
```

## Day 20 - Race Condition

[PERL]

SO I _really_ liked this day. I started late - ofc, cos timezones and life - but read the instructions and coded as
I went. Every test passed. It grew and became a part 1 solution that worked, but was slow. For sure part 2 was going
to take even longer, so needed a new approach. So, re-read the instructions and the **VITAL** bit of information I
initially glossed over was that there was only 1 valid path. So, shortcuts can't be anywhere, they have to touch the
path. Game changer.

Reworked part 1 using a more intelligent approach to finding cheats, meaning I have 3 methods:

- Part 1 v1 - check for single-thickness walls that could be cheat points; remove the wall block; re-run the Dijkstra; process result; restore the wall; repeat over all candidate cheat points. (Yes, unnecessary and slow.)

- Part 1 v2 - Find points on the path that are separated from the path by a single wall, get its distance, and get the difference in path lengths to measure the value (saving) of the cheat. Nice.

- Part 2 - Use a maximium range of path points using manhattan distance and test all those points similarly to part 1 v2. Fast enough. This is also cool because it solves part 1 if the max cheat length is set to 2.

The main thing to say for it is that I am consolidating my wherewithal using Dijkstra. Manhattan inside a Dijkstra. Or rather, post-processing a Dijkstra path.
This was hard, but satisfying. I didn't expect to like it, and part 2 was really offputting until you realise that the shortcut routes are irrelevant.
A cool problem.

## Day 21 - Keypad Conundrum

[PERL]

Absolutely the most surprising victory over part 1 have ever managed (or will ever).
At nearly 6 hours in while i clean up my code, nobody else in the private leaderboard has it done.

The key here was a couple of small epiphanies. Perhaps 1.5 epiphanies.

- Firstly - that there are only 2 shortest paths on the first remote keypad that can lead to a shortest path on the outer keypad; all other combos are worse (because you have to move more than necessary on the next pad out).

- Next, that the order of either of the 2 shortest sequences needs to adapt to the context in which the sequence is used.

## Day 22 - Monkey Market

[PERL]

Absurdly easy and fast - first in private leaderboard again (2 days in a row!).
This is only a minimally cleaned up part 1 - which ought to be (and was) a
MAHOOSIVE RED FLAG for part 2.

_(many hours later...)_

So yeah part 2 was hard, or at least, was hard to understand and build a sensible data structure for.
I'm a bit disappointed at how short the solution is when you work out how to do it.
My main issue here was really screwing up by tracking things that were buyer (monkey) specific on price (bananas) at global scope when
they needed to be initialised again every time around.

## Day 25 - Code Chronical

[PERL]

(bit behind with part 2s :( )

I always look forward to the final day because its easy. This was just building lists and checking the totals weren't exceeded.
Nothing interesting here, and many ways to solve it. I chose to flip the grids sideways and use `index` of `#` or `.` to get
the lengths of keys and locks. I've used more loops than needed, which is tedious -- it would be nice to build the data structure
on-the-fly while reading input instead of having a second step of post-processing the grids. Oh well. Its Christmas Day, and I've not had more than 4 hours sleep
for over a week.

Merry winterval.


