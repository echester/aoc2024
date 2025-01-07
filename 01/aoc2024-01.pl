#!/usr/bin/perl
# aoc2024-01
#
# advent of code 2024 | ed chester
# day 1
#
# "Historian Hysteria"
#
# Massive props to Eric for another year of near-insanity in the 
# pursuit of superior code skillz.
#
# For the avoidance of doubt - the comments were written afterwards, and the print debug
# removed... i'm not that professional. Fo real. 

use lib '../../aocbocs';
use aocbocs;

# initialise stuffs
my @left = my @right = ();
my $c=0;

# grab input, dropping columm values into separate arrays
my @in = iFile2Columns();
my @left = sort @{$in[0]};
my @right = sort @{$in[1]};

# part 1 - sum absolute differences of corresponding array elements
for (my $i=0; $i<=$#left; $i++) { $c += abs($left[$i] - $right[$i]); }
printf "Part 1 = %d\n", $c;

# part 2 - accumulate left column values multiplied by their incidence in the right column
$c = 0;
foreach my $l (@left) { $c += $l * grep {$_ eq $l} @right; }
printf "Part 2 = %d\n", $c;
