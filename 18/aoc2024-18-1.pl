#!/usr/bin/perl
# aoc2024-18-1

# advent of code 2024 | ed chester
# day 18 part 1 - RAM Run

use v5.10;
use List::PriorityQueue;

my %nogo;
my %nodes;
my $limit = 1024;
my $size = 71;

my @offset = ([-1,0], [0,1], [1,0], [0,-1]);
my $stack = new List::PriorityQueue;

while(<>) {
	chomp;
	my @line = split /,/;
	addnogo(j($line[1], $line[0]));
	last if ($. == $limit);
}

my $s = '0_0';
my $e = j($size-1, $size-1);

clean();
genEdges();
say dijk($s, $e);

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
	$stack->insert($adr, 1e6);
}

sub addnogo {
	my $adr = shift;
	$nogo{$adr} = 1;
}
