#!/usr/bin/perl
# aoc2024-06-1

# advent of code 2024 | ed chester
# day 6 part1 v3
#
# "Guard Gallivant"
#
# Could really have done without another grid straight away, but hey-ho(-ho-ho).
# This was also the first time that a hash looked immediately like the right thing
# to do, because even though part 1 looked like it was solvable by popping some values
# into a list of locations, I was suspicious that part2 might need to know a bit more
# about each location. As such, over-engineered part1 and this (part 1, v2) is a cleaned 
# up version pared back somewhat. As it worked out, part2 flumoxed me for a while: I
# tried just looking for a large number of moves being exceeded as some threshold for
# looping, but that's shoddy. Instead of looking at where the guard has been, it now tracks
# where she's been and which was she was heading when arriving there. Simples. (As if).
#
# Some time later... made rotations more elegant by just rotating the move list and
# downgrading it to an ordered list instead of a hash. Added some comments, removed some
# pointlessness. Tidy.

use v5.10;

sub uq { my %s; grep !$s{$_}++, @_; }

my @map, @track;
my $here;
my $exit =  0;

my @move = ([-1,0], [0,1], [1,0], [0,-1]);

my $r = 0;
while(<>) {
	my $c = 0;
	foreach (split //) {
		my $place = { block => 0, visited => 0 };
		if ($_ eq '^')    { $place->{visited} = 1; $here=[$r,$c]; }
		elsif ($_ eq '#') { $place->{block} = 1; }
		$map[$r][$c] = $place;
		$c++;
	}
	$r++;
}

do  {
	# mark where guard is now
	my ($hr, $hc) = ($here->[0], $here->[1]);
	$map[$hr][$hc]->{visited} = 1;
	push @track, join '_', $hr, $hc;
	# get next position to move to
	my ($nr, $nc) = ($hr + $move[0][0], $hc + $move[0][1]);
	# if at the edge, game over
	if ($nr==-1 || $nr==$#map+1 || $nc==-1 || $nc==$#map+1) { $exit++; }
	# move to next location if we haven't fallen off the world
	my $nh = $map[$nr][$nc];
	# if blocked, turn right
	if ($nh->{block} == 1) { push @move, shift @move; }
	# otherwise move forwards
	else { $here=[$nr,$nc]; }
} while ($exit==0); 

say "visited = ", scalar uq(@track);
