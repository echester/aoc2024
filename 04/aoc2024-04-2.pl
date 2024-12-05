#!/usr/bin/perl
# aoc2024-04
#
# advent of code 2024 | ed chester
# day 4 part 2
#
# "Ceres Search"
#
# I started late, I took an age, I had several false starts, and it was a
# shambles. Doing the following is inelegant, but it worked well because 
# the search strings are short.
#
# in part 2 i was allowing every possible kind of crossing, which after
# reading the instructions again made it much easier - just deleted a 
# bunch of checks. the only interesting thing here was inverting the usual
# trick to uniqify an array, to instead report only elements that were duplicated.

my @grid;
our @alocs;
my $p=3;

while(<>) {
	chomp;
	my $t = '.'x$p . $_ . '.'x$p; # pad the rows to embed in a sea of other symbols
	push @grid, [split //, $t];
}

# embed the grid in a sea of other symbols 
for (0..$p) { 
	push @grid, [ split //, '.'x($#grid+$p+$p+1) ];
	unshift @grid, [ split //, '.'x($#grid+$p+$p+1) ]; 
}

for (my $r=0; $r<=$#grid; $r++) {	
	for (my $c=0; $c<=$#grid; $c++) {
		genPoss(\@grid, $r, $c);
	}
}

@alocs = dupes(@alocs); # only keep things that appear more than once
print scalar @alocs;

sub genPoss {
	my ($gr, $row, $col) = @_;
	my @grid = @$gr;
	my $s;
	# \
	$s = join '', $grid[$row-2][$col-2], $grid[$row-1][$col-1], $grid[$row][$col];
	if (($s eq 'MAS') || ($s eq 'SAM')) { push @alocs, join ('_', $row-1, $col-1); }
	# /
	$s = join '', $grid[$row+2][$col-2], $grid[$row+1][$col-1], $grid[$row][$col];
	if (($s eq 'MAS') || ($s eq 'SAM')) { push @alocs, join ('_', $row+1, $col-1);}
}

sub dupes {
    my %s;
    grep $s{$_}++, @_;
}
