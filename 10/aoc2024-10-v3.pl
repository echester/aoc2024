#!/usr/bin/perl
# aoc2024-10-v3

# advent of code 2024 | ed chester
# day 10 - Hoof It

# urgh. DFS. or BFS, depending whether i can remember which would be better here.
# This was weird - solved part2 before part1, and had to undo a change for part2.
#
# SHOCKER - i profiled my code and realised some obvious improvements. This is v3.
# Also - Devel::NYTProf is FAR superior to Devel:DProf, its amazing.
#
# This version brings in a module to deal with array intersections rather than using
# my function, which was _slow as_.

use Array::Utils qw| intersect |;
my %map;
my $r = my $c = 0;

while(<>) {
	chomp;
	foreach (split //) { $map{j($r,$c)} = $_; $c++; }
	$r++; $c=0;
}

my $ways = 0;
my $ratings = 0;

my @elev;
for (my $i=0; $i<=9; $i++) {
	$elev[$i] = [findlevel($i)];
}

foreach (@{$elev[0]}) {
	my @path;
	my @peaks;
	push @path, $_;
	while (@path) {
		my $h = pop @path;
		push @peaks, $h if ($map{$h} == 9);
		my @next = adj($h, $#map, $#map);
		push @path, $_ foreach intersect(@next, @{$elev[$map{$h} + 1]});
	}
	$ways += scalar uq(@peaks);
	$ratings += scalar @peaks;
}

print "Part 1 $ways\n";
print "Part 2 $ratings\n";

sub findlevel {
	my $level = shift;
	return grep { $map{$_} == $level} keys %map;
	}

sub adj {
	my ($node, $nr, $nc) = @_;
	my ($r, $c) = split /_/, $node;
	my @a;
	push @a, j($r-1, $c) unless $r==0;
	push @a, j($r+1, $c) unless $r==$nr;
	push @a, j($r, $c-1) unless $c==0;
	push @a, j($r, $c+1) unless $c==$nc;
	return @a;
}

sub j { return join '_', @_; }

sub uq { my %s; grep !$s{$_}++, @_; }
