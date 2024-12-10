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
$ nytprofhtml --open 						 # then open the index.html report
$ dot -Tsvg nytprof/subs-callgraph.dot  	 # optional graph generator
```

This was pleasingly straightforward, and there's a real risk I might do it again. Here's the 2nd profiler run, for fun:
![screengrab of part of profiler output](https://github.com/echester/aoc2024/blob/main/10/profiler.png?raw=true)
In the list of this I learned today - here's me putting an image in a github readme. Colour me chuffed.

## Day 11 -

[PERL]




