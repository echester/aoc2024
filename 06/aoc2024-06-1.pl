#!/usr/bin/perl
# aoc2024-06-1

# advent of code 2024 | ed chester
# day 6 part1
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

use v5.10;

sub uniq { my %s; grep !$s{$_}++, @_; }

my @map;
my @track;
my $here;
my $dir  = '^';
my $exit =  0;

# should just do some %4 arithmetic on block counts to next 
# value, but i just cba and this works fine
my %move = ('^'=>[-1,0], '<'=>[0,-1], '>'=>[0,1], 'v'=>[1,0]);

# build the map
my $r = 0;
while(<>) {
	chomp;
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

# move the guard around on the map until she leaves at an edge
do  {
	# mark where guard is now
	my ($hr, $hc) = ($here->[0], $here->[1]);
	$map[$hr][$hc]->{visited} = 1;
	push @track, join '_', $hr, $hc;
	
	# get next position
	my ($nr, $nc) = ($hr + $move{$dir}->[0], $hc + $move{$dir}->[1]);

	# if at the edge, game over
	if ($nr==-1 || $nr==$#map+1 || $nc==-1 || $nc==$#map+1) { 
		say "Exit at $hr,$hc";
		$exit++; 
	}

	# check if next location is blocked
	my $nh = $map[$nr][$nc];
	if ($nh->{block} == 1) {
		# blocked, turn to the right
		if ($dir eq '^') { $dir = '>'; }
		elsif ($dir eq '>') { $dir = 'v'; }
		elsif ($dir eq 'v') { $dir = '<'; }
		elsif ($dir eq '<') { $dir = '^'; }
	}
	else {
		# not blocked, move to next place
		$here=[$nr,$nc];
	}
} while ($exit==0);

@track = uniq(@track);
say "visited = ", scalar @track;
