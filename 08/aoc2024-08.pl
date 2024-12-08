#!/usr/bin/perl
# aoc2024-08

# advent of code 2024 | ed chester
# day 8
#
# "Resonant Collinearity"
#
# This is not how antennas work, for the record.
#
# This took far longer than it ought to have, and I made excessive use of print debug.
# The challenge is fair, but was deliberately described in a complex way, possibly to
# thwart AI solvers.
#
# For part 2, I failed to consider the zeroth order harmonic, so was off by the number
# of antennas for a long time. The code below does both parts, and there's nothing to
# proud of anywhere in sight.

use v5.10;

my $pt2 = 1;
my %map;
my @nodes;
my $s;

while(<>) {
 	chomp;
 	my $c=0;
	foreach (split //) {
		if (/([0-9a-zA-Z])/) { push @{$map{$1}}, j($.-1,$c); }
		$c++;
	}
	$s = length($_);
}

foreach (keys %map) {
	my @fnodes = @{$map{$_}};
	my @pairs = duos(scalar @fnodes);
	foreach (@pairs) {
		my ($a, $b) = split /_/;
		my ($r1, $c1) = split /_/, $fnodes[$a];
		my ($r2, $c2) = split /_/, $fnodes[$b];

		# part 2
		if ($pt2) {
			my $hrm = 0;
			while(1) {
				my $nr = $r1 - $hrm * ($r2 - $r1);
				my $nc = $c1 - $hrm * ($c2 - $c1);
				last unless valid($s, $nr, $nc);
				push @nodes, j($nr,$nc);
				$hrm++;
			};
		}
		# part 1
		else {
			my $nr = $r1 - $r2 + $r1;
			my $nc = $c1 - $c2 + $c1;
			push @nodes, j($nr,$nc) if valid($s, $nr, $nc);
		}
	}
}

say scalar uq(@nodes);

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

sub valid {
	my ($s, $r, $c) = @_;
	return (($r>=0) && ($c>=0) && ($r<$s) && ($c<$s));
	}

sub j { return join '_', @_; }

sub uq { my %s; grep !$s{$_}++, @_; }
