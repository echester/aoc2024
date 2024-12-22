#!/usr/bin/perl
# aoc2024-22-1

# advent of code 2024 | ed chester
# day 22 - Monkey Market
#
# Absurdly easy and fast - first in private leaderboard again (2 days in a row!).
# This is only a minimally cleaned up part 1 - which ought to be (and was) a
# MAHOOSIVE RED FLAG for part 2.

use v5.10;
my $part1 = 0;

while(<>) {
	chomp;
	my $s = $_;
	$s = secret($s) foreach (0..1999);
	$part1 += $s;
}

say $part1;


sub secret {
	my $secret = shift;
	$secret = prune(mix($secret, $secret*64));
	$secret = prune(mix($secret, int ($secret/32)));
	return prune(mix($secret, $secret*2048));
}

sub mix {
	my ($secret, $mixval) = @_;
	return $secret ^ $mixval;
}

sub prune { return shift() % 16777216; }
