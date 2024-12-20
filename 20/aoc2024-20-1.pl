#!/usr/bin/perl
# aoc2024-20

# advent of code 2024 | ed chester
# day 20 - Race Condition
#
# This is the brute force naive version. It works, but s l  o   w    l     y
#
# The main thing to say for it is that I am consolidating my wherewithal using Dijkstra.

use v5.10;
use List::PriorityQueue;

my %wall;
my %nodes;
my $Z = 1e6;
my $s = my $e = '';
my $size = 0;

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
say "max = $max";

my @cheats = getcheats();
say "Found ", scalar @cheats, " cheats. Sit back dude...";

my $save100 = 0;

foreach (@cheats) {
	print "Cheat at $_ > ";
	removewall($_);
	clean();
	genEdges();
	my $saved = $max - dijk($s, $e);
	say "saved = $saved";
	addwall($_);
	$save100++ if ($saved >= 100);
}

say $save100;

sub getcheats {
	my @cheats;
	foreach my $wall (keys %wall) {
		my ($wr, $wc) = split '_', $wall;
		if ((defined $nodes{j($wr, $wc-1)} && defined $nodes{j($wr, $wc+1)}) ||
			(defined $nodes{j($wr-1, $wc)} && defined $nodes{j($wr+1, $wc)})
		) {
		push @cheats, $wall;
		}
	}
	return @cheats;
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

sub removewall {
	my $adr = shift;
	delete $wall{$adr};
}
