#!/usr/bin/perl
# aoc2024-24-1

# advent of code 2024 | ed chester
# day 24 part 1 - Crossed Wires

# started by tracking unknown signals in a list and waiting for the list to be empty,
# but cleaned up to just use the value (v) held by each gate.

# get bitwise xor
use v5.38;

my %signals;
my @gates;

while(<>) {
	chomp;
	if (/(.+):\s*(\d)/) { $signals{$1} = $2; }
	elsif (/(\S+)\s*(\w+)\s*(\S+)\s*->\s*(\S+)/) {
		push @gates, { i => $1, j => $3, gate => $2, out => $4, v => undef };
		}
	}

do{
	foreach (@gates) {
		next unless (defined $signals{$_->{i}} && defined $signals{$_->{j}});
		if ($_->{gate} eq 'AND')    { $_->{v} = $signals{$_->{i}} && $signals{$_->{j}}; }
		elsif ($_->{gate} eq 'OR')  { $_->{v} = $signals{$_->{i}} || $signals{$_->{j}}; }
		elsif ($_->{gate} eq 'XOR') { $_->{v} = $signals{$_->{i}} ^ $signals{$_->{j}}; }
		$signals{$_->{out}} = $_->{v};
	}
} while (unstable());

# process result
my $val = 0;
foreach (keys %signals) {
	if (/^z(\d+)/) { $val += ($signals{$_} << $1); }
}

say "Part 1 = $val";

sub unstable {
	my $c = 0;
	foreach (@gates) { $c++ unless ( defined $_->{v} ); }
	return $c;
}
