#!/usr/bin/perl
# aoc2024-04
#
# advent of code 2024 | ed chester
# day 4
#
# "Ceres Search"
#
# I started late, I took an age, I had several false starts, and it was a
# shambles. Doing the following is inelegant, but it worked well because 
# the search strings are short.

my @grid;
my $p=3;

while(<>) {
	chomp;
	my $t = '.'x$p . $_ . '.'x$p;
	push @grid, [split //, $t];
}

for (0..2) { push @grid, [ split //, '.'x($#grid+$p+$p+1) ]; }
for (0..2) { unshift @grid, [ split //, '.'x($#grid+$p+$p+1) ]; }

my $count = 0;
for (my $r=0; $r<=$#grid; $r++) {	
	for (my $c=0; $c<=$#grid; $c++) {
		$count += genPoss(\@grid, $r, $c);
	}
}
print $count;

sub genPoss {
	my ($gr, $row, $col) = @_;
	my @grid = @$gr;
	my $s;
	my $count = 0;
	# \
	$s = join '', $grid[$row-3][$col-3], $grid[$row-2][$col-2], $grid[$row-1][$col-1], $grid[$row][$col];
	if (($s eq 'XMAS') || ($s eq 'SAMX')) { $count++; }
	# /
	$s = join '', $grid[$row+3][$col-3], $grid[$row+2][$col-2], $grid[$row+1][$col-1], $grid[$row][$col];
	if (($s eq 'XMAS') || ($s eq 'SAMX')) { $count++; }
	# -
	$s = join '', $grid[$row][$col+3], $grid[$row][$col+2], $grid[$row][$col+1], $grid[$row][$col];
	if (($s eq 'XMAS') || ($s eq 'SAMX')) { $count++; }
	# |
	$s = join '', $grid[$row-3][$col], $grid[$row-2][$col], $grid[$row-1][$col], $grid[$row][$col];
	if (($s eq 'XMAS') || ($s eq 'SAMX')) { $count++; }
	return $count;
}