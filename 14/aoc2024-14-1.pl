#!/usr/bin/perl
# aoc2024-14-1

# advent of code 2024 | ed chester
# day 14 part 1 - Restroom Redoubt
#
# This was a weirdly easy day 14 challenge, though what you have below is rather
# cleaned up from the quick mess that I used first. Moving robots around on a wrapped
# grid a fixed number of times, and then counting subsets of them.

my @robots;
my ($maxc, $maxr) = (101, 103);
my $i=99;

while(<>) {
	chomp;
	/^p=(.+),(.+)\s+v=(.+),(.+)$/;
	push @robots, [$1, $2, $3, $4];
}

move() foreach (0..$i);

print 1 *
	cquad(0, int $maxr/2, 0, int $maxc/2) *
	cquad(1 + int $maxr/2, $maxr, 0, int $maxc/2) *
	cquad(0, int $maxr/2, 1 + int $maxc/2, $maxc) *
	cquad(1 + int $maxr/2, $maxr, 1 + int $maxc/2, $maxc),
	"\n";

sub cquad {
	my ($fr, $tr, $fc, $tc) = @_;
	my $nrobots = 0;
	for (my $r=$fr; $r<$tr; $r++) {
		for (my $c=$fc; $c<$tc; $c++) {
			foreach (@robots) {
				my ($rc, $rr, $vc, $vr) = $_->@*;
				$nrobots++ if ($c == $rc && $r == $rr);
			}
		}
	}
	return  $nrobots;
}

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

sub grid {
	my @g;
	for (my $r=0; $r<$maxr; $r++) {
		for (my $c=0; $c<$maxc; $c++) { $g[$c][$r] = '.'; }
	}
	foreach (@robots) {
		my ($rc, $rr, $vc, $vr) = $_->@*;
		$g[$rc][$rr] = '*';
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
