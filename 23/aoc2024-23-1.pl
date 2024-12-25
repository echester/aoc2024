#!/usr/bin/perl
# aoc2024-23

# advent of code 2024 | ed chester
# day 23 - LAN Party
#
# Fairly straightforward hashing and counting part 1

use v5.10;
use Algorithm::Combinatorics qw| combinations |;

my %net;
my %sig;
my $part1 = 0;

while(<>) {
	/^(\w+)-(\w+)$/;
	push @{$net{$1}}, $2;
	push @{$net{$2}}, $1;
}

foreach (keys %net) {
	my @g = @{$net{$_}};
	my @gpairs = combinations(\@g, 2);
	foreach my $pair (@gpairs) {
		my $label = join '_', sort $_, ${$pair}[0], ${$pair}[1];
		$sig{$label}++;
	}
}

foreach my $s (keys %sig) {
	next unless ($s =~ /t._|_t./);
	$part1++ if ($sig{$s} == 3);
}

say $part1;
