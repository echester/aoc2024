#!/usr/bin/perl
# aoc2024-24-2

# advent of code 2024 | ed chester
# day 24 part 2

use v5.38;
use warnings;
use strict;
use DDP;
use Data::Dumper;

say "graph day24 {";
while(<>) {
	chomp;
	if (/(\S+)\s*(\w+)\s*(\S+)\s*->\s*(\S+)/) {
		say $1 . ' -- ' . $4;
		say $3 . ' -- ' . $4;
	}
}

say "}";
