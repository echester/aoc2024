#!/usr/bin/perl
# aoc2024-07

# advent of code 2024 | ed chester
# day 7 Bridge Repair
#
# "Whoop ops up the combomatch parsetree to cross a crapbridge"
#
# I love this kind of puzzle: easy, no gotchas, no weird background knowledge
# required other than how to permute a set of objects. Part 2 was a pleasingly
# trivial extension to part 1. Very much my wheelhouse.

use v5.10;
use Algorithm::Combinatorics qw| variations_with_repetition |;

my @ops = ('*', '+');
push @ops, 'c' if(1); # part 2 switch

my $total = 0;

while(<>) {
 	chomp;
	s/://;
	my @v = split / /;
	my $r = shift @v;

	foreach (variations_with_repetition(\@ops, -1 + scalar @v)) {
		if (calc (\@v, $_) == $r) { $total += $r; last; }
	}
}

say $total;

sub calc {
	my ($vr, $cr) = @_;
	my @vals = @$vr;
	my @ops = @$cr;
	my $r = shift @vals;

	while(@vals) {
		my $o = shift @ops;
		my $v = shift @vals;
		if ($o eq '*') { $r *= $v; }
		elsif ($o eq '+') { $r += $v; }
		elsif ($o eq 'c') { $r .= $v; }
	}
	return $r;
}
