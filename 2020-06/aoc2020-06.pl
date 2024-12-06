#!/usr/bin/perl
# aoc2022-06
#
# advent of code 2026 | ed chester
# day 6
#
# "Custom Customs"

use strict;
use warnings;
use Data::Dumper;

my @gs;
my $s;
while(<>) {
	chomp;
	unless (length) { push @gs, $s; $s = ''; }
	else { $s .= $_; }
}
# store the final group in case
push @gs, $s if ($s);

my $c=0;
foreach (@gs) {
	# retain only last instance of each char
	s/(.)(?=.*?\1)//g;
	$c += length;
}

printf "Answers = %d\n", $c;