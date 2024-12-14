#!/usr/bin/perl
# aoc2024-14-2

# advent of code 2024 | ed chester
# day 14 part 2 - Restroom Redoubt

my @robots;
my ($maxc, $maxr) = (101, 103);
my $i=0;

while(<>) {
# 	chomp;
	/^p=(.+),(.+)\s+v=(.+),(.+)$/;
	push @robots, [$1, $2, $3, $4];
	}

do { move(); $i++;} until (lookslikeathingericthinkslookslikeatree());

my @g = grid();
show(\@g);
print "$i\n";

sub move {
	for (my $nr=0; $nr<=$#robots; $nr++) {
		my ($rc, $rr, $vc, $vr) = $robots[$nr]->@*;
		my $newc = $rc + $vc;
		my $newr = $rr + $vr;
		if ($newc >= $maxc) { $newc = $newc - $maxc; }
		if ($newc < 0) { $newc = $newc + $maxc; }
		if ($newr >= $maxr) { $newr = $newr - $maxr; }
		if ($newr < 0) { $newr = $newr + $maxr; }
		$robots[$nr] = [$newc, $newr, $vc, $vr];
	}
}

sub lookslikeathingericthinkslookslikeatree {
	my @g = grid();
	for (my $r=0; $r<$maxr; $r++) {
		my $line = '';
		for (my $c=0; $c<$maxc; $c++) { $line .= $g[$c][$r]; }
		return 1 if ($line =~ m/\d{8,}/);
	}
	return 0;
}

sub grid {
	my @g;
	for (my $r=0; $r<$maxr; $r++) {
		for (my $c=0; $c<$maxc; $c++) { $g[$c][$r] = '.'; }
	}
	foreach (@robots) {
		my ($rc, $rr, $vc, $vr) = $_->@*;
		$g[$rc][$rr] += 1;
	}
	return @g;
}

sub show {
	my $gr = shift;
	my @g = $gr->@*;
	for (my $r=0; $r<$maxr; $r++) {
		for (my $c=0; $c<$maxc; $c++) { print $g[$c][$r]; }
		print "\n";
	}
	print "\n";
}
