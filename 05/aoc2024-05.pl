#!/usr/bin/perl
# aoc2024-05
#
# advent of code 2024 | ed chester
# day 5
#
# " "
use v5.10;
my @rules;
my @updates;
my $midsum = 0;

while(<>) {
	chomp;
	next unless length;
	if (/^(\d+)\|(\d+)$/) { push @rules, [$1,$2]; }
	else { push @updates, $_; }
	}

foreach (@updates) {
	$midsum += process($_);
}

say "sum = $midsum";

sub process {
	my @update = split /,/, shift;
	my $valid = 0;
	for (my $i=0; $i<=$#update; $i++) {
		my $p = $update[$i];
		for (my $j=$i+1; $j<=$#update; $j++) {
			my $n = $update[$j];
			foreach my $r (@rules) {
				my ($b,$a) = @$r;
				if (($p==$b) && ($n==$a)) { $valid++; }
			}
		}
	}
	my $e = expt(scalar @update);
	return ($e == $valid) ? $update[ $#update/2 ] : 0;
}

sub expt {
	# sum of all pos ints up to (but not) this one
	my ($v, $s) = (shift, 0);
	while ($v>0) { $s += $v - 1; $v--; }
	return $s;
}