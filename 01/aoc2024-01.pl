#!/usr/bin/perl
# aoc2024-01
#
# advent of code 2024 | ed chester
# day 1
#
# "  "
#
# Massive props to Eric for another year of near-insanity in the 
# pursuit of superior code skillz.
#
 
use v5.10;
use strict;
use warnings;
use Data::Dumper;

my @lines;

my $c=0;

while(<>) {
	chomp;
	push @lines, $_;

	# print "$_\n";
	#/^(\w)\s+(\d+)\s+\((.+)\)/;


}

say Dumper(@lines);


# use strict;
# use warnings;

# my $infile = (defined $ARGV[0]) ? $ARGV[0] : 'input.dat';
# open (INF, '<', $infile) || die "$!\n";

# my $c=0;
# while(<INF>) {
# 	chomp;

	
# 	s/[a-z]//gi;
# 	my $f = substr $_, 0, 1;
# 	my $l = substr $_, -1, 1;
# 	$c += "$f$l";

# }
# close INF;
# print $c;
