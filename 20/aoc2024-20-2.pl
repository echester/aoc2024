#!/usr/bin/perl
# aoc2024-20-2

# advent of code 2024 | ed chester
# day 20 - Race Condition

# Manhattan inside a Dijkstra. Or rather, post-processing a Dijkstra path.
# This was hard, but satisfying. I didn't expect to like it, and part 2 was
# really offputting until you realise that the shortcut routes are irrelevant.

use v5.10;
use List::PriorityQueue;

my %wall;
my %nodes;
my $Z = 1e6;
my $s = my $e = '';
my $size = 0;
my %path;
my $thresh = 100;
my $range = 20;

my @offset = ([-1,0], [0,1], [1,0], [0,-1]);
my $stack = new List::PriorityQueue;

while(<>) {
	chomp;
	my @line = split //;
	my $c = 0;
	foreach my $t (@line) {
		# address
		my $h = ($.-1) . '_' . $c;
		# walls
		if ($t eq '#') { $wall{$h}++; }
		# spaces
		else           { $nodes{$h} = {visited => 0, dist => 1e6 }; }
		# start
		if ($t eq 'S') {
			$s = $h;
			$nodes{$h}->{dist} = 0;
			$nodes{$h}->{visited} = 1;
			}
		# end
		if ($t eq 'E') { $e = $h; }
		$c++;
	}
}

# get grid size (square)
$size = $.;

clean();
genEdges();
my $max = dijk($s, $e);
my $cheats = getcheats();

say "Found $cheats cheats over threshold";

sub getcheats {
	my @cheats;
	my $count = 0;
	# at each point in the valid path:
	foreach my $step (keys %path) {
		my ($sr, $sc) = split '_', $step;
		my $plen = $path{$step};

		# for each point (any type) within range of this path point which is also not adjacent to it:
		for (my $dr=-$range; $dr<=$range; $dr++) {
			for (my $dc=-$range; $dc<=$range; $dc++) { # ok so this is ugly and it contains a bunch
			                                           # of values that cannot possibly work, but i
			                                           # can't think up something better right now.
			                                           # bite me.
				# get its address and cheatrange
				my $cheatpoint = j($sr+$dr, $sc+$dc);
				my $cheatrange = manhat ($sr, $sc, $sr+$dr, $sc+$dc);

				# could this cheatpoint be valid? skip it if not
				next unless ($cheatrange <= $range && $cheatrange >= 2 && defined $path{$cheatpoint});
				# calc the possible saving in path length
				my $d = $path{$cheatpoint} - $plen - $cheatrange;
				# count this cheat if it saves time
				$count++ if ($d >= $thresh);
			}
		}
	}
	return $count;
}

sub dijk {
	my ($from, $to) = @_;
	$path{$from} = 0;
	while (my $here = $stack->pop()) {
		if ($here eq $to) { return $nodes{$to}->{dist}; };
		$nodes{$here}->{v} = 1;
		foreach my $next (@{$nodes{$here}->{edges}}) {
			next if ($nodes{$next}->{v} == 1);
			my $newdist = $nodes{$here}->{dist} + 1;
			my $d = $nodes{$next}->{dist};
			if ($newdist < $d) {
				$nodes{$next}->{dist} = $newdist;
				$path{$next} = $newdist;
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
			push @edges, $n unless (defined $wall{$n});
		}
		$nodes{$node}{edges} = [@edges];
	}
}

sub j {	return join '_', @_; }

sub clean {
	for (my $r=0; $r<$size; $r++) {
		for (my $c=0; $c<$size; $c++) {
			my $adr = join '_', ($r, $c);
			addnode($adr) unless defined $wall{$adr};
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

sub addwall {
	my $adr = shift;
	$wall{$adr} = 1;
}

sub manhat {
	my ($x1, $y1, $x2, $y2) = @_;
	return abs($x1 - $x2) + abs($y1 - $y2);
}
