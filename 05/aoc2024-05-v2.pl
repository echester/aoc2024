#!/usr/bin/perl
# aoc2024-05-v2
#
# advent of code 2024 | ed chester
# day 5
#
# "Print Queue"
#
# Print debug rUleZ ... and that's all i have to say about that. Not.
# Today was the day I needed a CPAN module and i discovered my whole
# environment was borked. Installed a fresh VM for part 2.
# Binned it. Swapped machines.
# Secure erased disk in primary workstation. Reinstalled environments.
# THAT'S what i think about AoC today. If H wasn't off school with 
# a vomitting bug I'd be as frustrated as a woodpecker with a rubber beak,
# but as it happens, dealing with all this was kinda fun. In the
# limit where 'kinda' takes very, very small values.
#
# This is the cleaner version.

use v5.10;
use List::MoreUtils qw| first_index |;

my @rules;
my @updates;
my $pt1 = my $pt2 = 0;

while(<>) {
	chomp;
	next unless length;
	if (/^(\d+)\|(\d+)$/) { push @rules, [$1,$2]; }
	else { push @updates, [ split /,/ ]; }
	}

foreach (@updates) {
	my @update = @$_;
	say "Check update: ", join ',', @update;
	my $mid = isValid(\@update);
	if ($mid > 0) { $pt1 += $mid; }
	else          {	$pt2 += fixed(\@update); }
}

say "pt1 = $pt1";
say "pt2 = $pt2";

sub isValid {
	my $ar = shift;
	my @u = @$ar;
	my $valid = 0;
	foreach my $r (@rules) {
		my ($b,$a) = @$r;
		my $i1 = first_index { $_ eq $b } @u;
		my $i2 = first_index { $_ eq $a } @u;
		$valid++ if $i1>=0 && $i2>=0 && $i1<$i2;
	}
	my $e = expt(scalar @u);
	return ($e == $valid) ? $u[$#u/2] : 0;
}

sub fixed {
	my $ar = shift;
	my @u = @$ar;
	my $fixed = 0;
	my $m;
	do {
		foreach my $r (@rules) {
			my ($b,$a) = @$r;
			my $i1 = first_index { $_ eq $a } @u;
			my $i2 = first_index { $_ eq $b } @u;
			next unless ($i1 >= 0 && $i2 >= 0);
			if ($i1 < $i2) {
				($u[$i1], $u[$i2]) = ($b, $a);
				$m = isValid(\@u);
				if ($m > 0) { $fixed++; last; }
			}
		}
	} while (!$fixed);
	return $m;
}

sub expt {
	# sum of all pos ints up to (but not) this one
	my ($v, $s) = (shift, 0);
	while ($v>0) { $s+=$v-1; $v--; }
	return $s;
}
