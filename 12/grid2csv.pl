#!/usr/bin/perl
# utility script to comma sep everything
while(<>) {
	chomp;
	foreach (split //) { print "$_,"; }
	print "\n";
}
