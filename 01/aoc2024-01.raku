# aoc2024-01
# raku version
use v6;

my @left;
my @right;
my $c=0;

for @*ARGS[0].IO.lines -> $line {
	$line ~~ /^(\w+)\s+(\w+)/;
	push @left, $0.Int;
	push @right, $1.Int;
}

@left = @left.sort;
@right = @right.sort;

# part 1 - sum absolute differences of corresponding array elements
for 0..@left.end -> $i { $c += abs(@left[$i] - @right[$i]); }
say "Part 1 = $c";

# part 2 - accumulate left column values multiplied by their incidence in the right column
$c = 0;
for @left -> $l { $c += $l * @right.grep: $l; }
say "Part 2 = $c";
