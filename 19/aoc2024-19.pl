#!/usr/bin/perl
# aoc2024-19

# advent of code 2024 | ed chester
# day 19 - Linen Layout

# "I only need 3 more stars to have beaten my performance last year, and
# then I can safely put this whole basket of nonsense down."

# I started this with a _very elegant_ validity matrix approach, but it was very
# quickly thwarted by the real input data, because there are cases where a given
# sequence (even a long one) is only valid with things either side of it, even
# if the sequence itself is valid... which... smells... like.... recursion.
# My old nemesis.
# Even the old nemensis of Old Harry Dwmpus. Feck.
# Immediately, its a pain. And its slow, so break out memoization in the forlorn
# hope of base case exit redemption. Part 1 acceptably fast. Part 2, not so much.
# And then, while making a cup of tea, the five-head-slap moment when i realised
# I hadn't memoized my part2 function. Its actually pretty decent now.
# Star star, tick tick, bosh bosh.

use v5.10;
use Memoize;
memoize('countMyFunkyTowelsNowSirOhYes');

my @patterns;
my @designs;

while(<>) {
	chomp;
	next unless length;
	if (/,/) { @patterns = split /, /; }
	else { push @designs, $_; }
}

my $c = 0;
foreach (@designs) {
	$c += countMyFunkyTowelsNowSirOhYes($_, \@patterns, 0);
}

say "Part1 = $c";

$c = 0;
foreach (@designs) {
	$c += countMyFunkyTowelsNowSirOhYes($_, \@patterns, 1);
}

say "Part2 = $c";

sub countMyFunkyTowelsNowSirOhYes {
	my ($d, $pref, $part2) = @_;
	my $count = 0;
	# borkable base case
	return 1 unless length $d;
	foreach my $p (@{$pref}) {
		if (index($d, $p) == 0) {
			my $towelright = substr $d, length $p;
			$count += (countMyFunkyTowelsNowSirOhYes($towelright, $pref, $part2));
			}
		}
	return ($part2) ? $count : ($count > 0);
}
