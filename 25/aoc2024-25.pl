#!/usr/bin/perl
# aoc2024-25

# advent of code 2024 | ed chester
# day 25 - Code Chronicle

# Always look forward to the final day because its easy. This was just building
# lists and checking the totals weren't exceeded.

use v5.10;

my @locks;
my @keys;
my @pat;
my $flag = 1;
my @things;
my ($nr, $nc) = (0,0);

while(<>) {
	chomp;
	if (length) {
		push @pat, $_;
		if ($nc < -1 + length) { $nc = -1 + length };
		}
	else {
		push @things, [@pat];
		$nr = -1 + scalar @pat;
		@pat = ();
	}
}
foreach (@things) {
	$flag = (@{$_}[0] eq '#'x($nc+1));
	my @g = mapthethingsidewaysandcount($_, $nr, $nc, $flag);
	if ($flag) { push @locks, [@g]; }
	else       { push @keys,  [@g]; }
}

my $c = 0;

foreach my $l (@locks) { ALLW:
	foreach my $k (@keys) {
		foreach my $i (0..$nc) { next ALLW unless ((@{$l}[$i] + @{$k}[$i]) <= $nr - 1); }
		$c++;
	}
}

say "Part 1 = $c";

sub mapthethingsidewaysandcount {
	(my $ar, $nr, $nc, $flag) = @_;
	my @out;
	for (my $r=0; $r<=$nr; $r++) {
		my @l = split //, @{$ar}[$r];
		for (my $c=0; $c<=$nc; $c++) { $out[$c][$r] = $l[$c]; }
	}
	if ($flag) { foreach my $v (@out) { $v = -1 + index join('', $v->@*), '.'; } }
	else       { foreach my $v (@out) { $v = $nr - index join('', $v->@*), '#'; } }
	return (@out);
}
