#!/usr/bin/perl
# aoc2024-03
#
# advent of code 2024 | ed chester
# day 3
#
# "YES! Finally a regex day, this is my wheelhouse."
#
# Fully straightforward parsing test, about which there is little to say tbh.
# I did fall into the obvious gotcha of having operations broken over 
# multiple lines, but that was a quick fix. 

$/ = undef;
my @o;
my $s=0;
my $m=1;

while(<>) {
	@o = $_ =~ /(?:mul\(\d{1,3},\d{1,3}\)|don't\(\)|do\(\))/g;
}

foreach (@o) {
	if (/\w+\((\d+),(\d+)/) { $s += $m*$1*$2; }
	elsif (/^don\'t/)       { $m = 0; }
	else                    { $m = 1; }
}

print "$s\n";
