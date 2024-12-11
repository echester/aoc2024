#!/usr/bin/perl
# aoc2024-11-v3

# advent of code 2024 | ed chester
# day 11 - Plutonian Pebbles

# "I will try anything at all, no matter how likely to be fruitless or time consuming,
# before actually resigning myself to writing a recursive function :/ "
# - Is this an effective strategy?
# Hell no.
#
# Am I pissed at how short this code is?
# Hell yes.

use Memoize;
memoize('blinklikeafreak');

my @stones = (); # downgraded to array because order irrelevant and stones don't affect each other
my $c = 0;

# get the input
while(<>) {	chomp; @stones = split / /; }

# part1
foreach (@stones) { $c += blinklikeafreak($_, 25, 0); }
print "pt1 = $c\n";

# part2
$c = 0;
foreach (@stones) { $c += blinklikeafreak($_, 75, 0); }
print "pt2 = $c\n";

sub blinklikeafreak {
	my ($stone, $max, $thisiter) = @_;

	if ($thisiter < $max) {
		# 0 -> 1
		if ($stone == 0) {
			return blinklikeafreak(1, $max, $thisiter+1);
		}
		# even lengths -> split in 2
		elsif (length($stone) % 2 == 0) {
			my $a = blinklikeafreak(int(substr $stone, 0, length($stone)/2), $max, $thisiter+1);
			my $b = blinklikeafreak(int(substr $stone, length($stone)/2, length($stone)/2), $max, $thisiter+1);
			return $a + $b;
		}
		# others *= 2024
		else {
			return blinklikeafreak($stone * 2024, $max, $thisiter+1);
		}
	}
	# endgame - at max blinks return 1 for the original stone (yep, this took an age to debug!)
	return 1;
}
