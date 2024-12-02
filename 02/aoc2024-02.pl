#!/usr/bin/perl
# aoc2024-02
#
# advent of code 2024 | ed chester
# day 2
#
# "Red-Nosed Reports"
#
# This took me much longer than the code below would have you believe. 
# I tried to be too clever in part 1, and had a counter for the ways in which each report
# was invalid. Superficially, just changing my threshold tolerance from 0 to 1 for 'errors'
# would solve part 2, but that quickly unravelled.
# Had to leave for school run and meetings, and did it quickly having thought about it on
# the walk. 
# What's left is an ugly brute-force iteration over the possible arrays, and I'm not inspired
# to find a sneakier way.
# Comments added to the part 2 function so I remember later how it works ;)

my $part1 = my $part2 = 0;

sub sgn { return (0 > shift); }

sub issafe {
	my @levs = @_;
	my $d = my $l = 0; # diff, previous diff
	my $e = 0; # error count
	foreach my $i (1..$#levs) {
		$d = $levs[$i] - $levs[$i-1];
		$e++ if (abs $d > 3 || !$d || ($i>1) && (sgn($d) != sgn($l)));
		$l = $d;
	}
	return ($e == 0);
}

sub damped {
	# iterate safety check over reports while tolerating one level to be unsafe
	my @arr = @_;
	my $safe = 0;
	foreach my $i (0..$#arr) {
		# make a list of all the levels indices
		my @idxlist = 0..$#arr;
		# remove the index we don't want this time around
		splice(@idxlist, $i, 1);
		# assemble the new report with one level missing
		my @newarr = @arr[ @idxlist ];
		# ... and check if it is safe:
		$safe += issafe(@newarr);
	}
	return ($safe > 0);
}

# grab input
while(<>) {
	my @report = split;
	$part1 += issafe(@report);
	$part2 += damped(@report);
}

print "Part 1 : $part1\n";
print "Part 2 : $part2\n";
