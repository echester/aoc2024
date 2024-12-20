#!/usr/bin/perl
# aoc2024-20-1-v2

# advent of code 2024 | ed chester
# day 20 - Race Condition

# So the slow way works, but is stupid. This is smarter. Slightly.


use v5.10;
use List::PriorityQueue;

my %wall;
my %nodes;
my $Z = 1e6;
my $s = my $e = '';
my $size = 0;
my %path;
my $thresh = 100;

my @offset = ([-1,0], [0,1], [1,0], [0,-1]);
my $stack = new List::PriorityQueue;

while(<>) {
	chomp;
	my @line = split //;
	my $c = 0;
	foreach my $t (@line) {
		my $h = ($.-1) . '_' . $c;
		if ($t eq '#') { $wall{$h}++; }
		else {
			$nodes{$h} = { visited => 0, dist => 1e6 };
		}
		if ($t eq 'S') {
			$s = $h;
			$nodes{$h}->{dist} = 0;
			$nodes{$h}->{visited} = 1;
			}
		if ($t eq 'E') { $e = $h; }
		$c++;
	}
}

$size = $.;

clean();
genEdges();
my $max = dijk($s, $e);
my $cheats = getcheats();

say "Found $cheats cheats over threshold";

sub getcheats {
	my @cheats;
	my $count = 0;
	foreach my $step (keys %path) {
		my ($sr, $sc) = split '_', $step;
		my $plen = $path{$step};

		# YES - THIS WHOLE THING BELOW IS UGLY AS HELL BUT I AM NOT
		# GOING TO FIX IT BECAUSE FO-SHO THIS WILL BITE ME IN PART 2

		# cheat up
		if (defined $path{j($sr-2, $sc)} &! defined $path{j($sr-1, $sc)}) {
			my $d = $path{j($sr-2, $sc)} - $plen - 2;
			if ($d > 0) {
				printf "cheat ^ at %d, %d saves %d\n", $sr-1,  $sc, $d;
				$count++ if ($d >= $thresh);
			}
		}
		# cheat down
		if (defined $path{j($sr+2, $sc)} &! defined $path{j($sr+1, $sc)}) {
			my $d = $path{j($sr+2, $sc)} - $plen - 2;
			if ($d > 0) {
				printf "cheat v at %d, %d saves %d\n", $sr+1,  $sc, $d;
				$count++ if ($d >= $thresh);
			}
		}
		# cheat right
		if (defined $path{j($sr, $sc+2)} &! defined $path{j($sr, $sc+1)}) {
			my $d = $path{j($sr, $sc+2)} - $plen - 2;
			if ($d > 0) {
				printf "cheat > at %d, %d saves %d\n", $sr,  $sc+1, $d;
				$count++ if ($d >= $thresh);
			}
		}
		# cheat left
		if (defined $path{j($sr, $sc-2)} &! defined $path{j($sr, $sc-1)}) {
			my $d = $path{j($sr, $sc-2)} - $plen - 2;
			if ($d > 0) {
				printf "cheat < at %d, %d saves %d\n", $sr,  $sc-1, $d;
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
