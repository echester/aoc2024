#!/usr/bin/perl
# aoc2024-18-2

# advent of code 2024 | ed chester
# day 18 part2 - RAM Run

# Edgar Dijkstra is the DUDE. Today's solution was made mostly by deleting stuff from day 16.
# The input parsing needed to be changed up, and then tweaked for part 2.
# I made a super classic n00b-asshat error: my clean() function below started out being called
# reset() to restart the dijkstra. But... reset is a reserved word as its a perl function (that
# I've never used): it clears variables and pattern matches so they can be used again.
#
# Part 1 code got cleaned up just a little, and part 2 is just about putting part 1 in a loop
# with an ever-growing list of obstacles. Given it takes about a second to solve a single map,
# I used a coarse binary search using part 1 code to move the starting point to within 10 nodes
# (bytes) of the answer.
#
# ***NOTE TO FUTURE SELF*** This works in row,column order, which is backwards compared to the input.
# You *absolutely will* screw up in the future because of this, but you can't say you weren't warned.


use v5.10;
use List::PriorityQueue;

my %nogo;
my %nodes;
my $limit = 3040; # initialised using search with part 1
my $size = 71;
my $Z = 1e6;

my @offset = ([-1,0], [0,1], [1,0], [0,-1]);
my $stack = new List::PriorityQueue;

my @later;

while(<>) {
	chomp;
	my @line = split /,/;
	my $h = j($line[1], $line[0]);
	if ($. <= $limit) { addnogo($h); }
	else { push @later, $h; }
}

my $s = '0_0';
my $e = j($size-1, $size-1);

my $nextbyte;
while (1) {
	clean();
	genEdges();
	my $exit = dijk($s, $e);
	say "dist = $exit";
	if ($exit == $Z) {
		say "byte $nextbyte (reverse for answer!)";
		last;
	};

	$nextbyte = shift @later;
	last if (!defined $nextbyte);
	my ($nr, $nc) = split '_', $nextbyte;
	addnogo(j($nr, $nc));
}

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

sub genEdges {
	foreach my $node (keys %nodes) {
		my @edges = ();
		my ($r, $c) = split '_', $node;
		foreach (@offset) {
			my $nr = $r + $_->[0];
			my $nc = $c + $_->[1];
			next if ($nr < 0 || $nr >= $size || $nc < 0 || $nc >= $size);
			my $n = j($nr, $nc);
			push @edges, $n unless (defined $nogo{$n});
		}
		$nodes{$node}{edges} = [@edges];
	}
}

sub j {	return join '_', @_; }

sub clean {
	for (my $r=0; $r<$size; $r++) {
		for (my $c=0; $c<$size; $c++) {
			my $adr = join '_', ($r, $c);
			addnode($adr) unless defined $nogo{$adr};
		}
	}
	$nodes{$s}->{dist} = 0;
	$nodes{$s}->{v} = 1;
	$stack->update($s, 0);
}

sub addnode {
	my $adr = shift;
	$nodes{$adr} = {v => 0, dist => 1e6, edges => []};
	$stack->insert($adr, $Z);
}

sub addnogo {
	my $adr = shift;
	$nogo{$adr} = 1;
}
