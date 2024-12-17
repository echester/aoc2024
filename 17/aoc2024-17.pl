#!/usr/bin/perl
# aoc2024-17

# advent of code 2024 | ed chester
# day 17 - Chronospatial Computer

# Without a doubt the hardest day 17 i've ever done, and I've done some fairly epic hikes.

# enable bitwise fiascos
use v5.28;

# just to grab the lowest value at the end
use List::Util qw| min |;

# registers
our $a = our $b = our $c = 0;

# program
my @ins;

# stack pointer
my $j = 0;

while(<>) {
	chomp;
	if (/ter A:\s(\d+)/) { $a = $1; }
	elsif (/ter B:\s(\d+)/) { $b = $1; }
	elsif (/ter C:\s(\d+)/) { $c = $1; }
	elsif (/ram:\s(.+)/) { @ins = split ',', $1; }
}

# part 1
say join ',', runmachine($a);

# part 2
my @possibles = (0);
# loop over output values from the end
for my $k (0 .. $#ins) {
	# store found possibles
	my @next = ();
	# loop over the set of previous possibles
	foreach my $pa (@possibles) {
		# loop over all of the following 8 values above the possible
		for (my $delta=0; $delta<8; $delta++) {
			my $target = ($pa << 3) + $delta;
			# get the subset of the program to check against
			my @check = @ins[$#ins-$k .. $#ins];
			# stringify them because I CANNOT BE BOTHERED TO IMPLEMENT ARRAY COMPARISON, OK??!?!?!
			my $t2 = join ',', @check;
			# get the actual output running with this possible target value
			my $t1 = join ',', runmachine($target);
			# check if the machine output matches the expected program subset
			if (index ($t1,$t2) != -1) { push @next, $target; }
		}
	}
	# empty the possibility list
	@possibles = ();
	# and drop the new folx into it - YES I SHOULD BE USING SPLICE BUT I'M FREAKING WORN OUT BY THIS PUZZLE
	push @possibles, @next;
}

say min(@possibles);

sub runmachine {
	# get start value
	$a = shift;
	# initialise stack pointer
	$j = 0;
	# output digit list
	my @outlist;
	# run like a lizard on hot soup
	while(1) {
		# bork if the stack pointer's left the arena
		last if ($j>$#ins);
		# grab instruction and operand from the list
		my ($opc, $v) = ($ins[$j], $ins[$j+1]);
		# ugly switch thing to call relevant operation sub
		if ($opc == 0) { adv($v); }
		elsif ($opc == 1) { bxl($v); }
		elsif ($opc == 2) { bst($v); }
		elsif ($opc == 3) { jnz($v); }
		elsif ($opc == 4) { bxc($v); }
		elsif ($opc == 5) { out(\@outlist, $v);}
		elsif ($opc == 6) { bdv($v); }
		elsif ($opc == 7) { cdv($v); }
		# shuffle along to the next instruction
		$j += 2;
	}
	return @outlist;
}

sub combo {
	my $x = shift;
	if ($x == 4) { $x = $a; }
	elsif ($x == 5) { $x = $b; }
	elsif ($x == 6) { $x = $c; }
	return $x;
}

sub adv { $a = $a >> combo(shift); }

sub bdv { $b = $a >> combo(shift); }

sub cdv { $c = $a >> combo(shift); }

sub bxl { $b = $b ^ shift; }

sub bst { $b = combo(shift) % 8;}

sub jnz { $j = shift() - 2 unless !$a; }

sub bxc { $b = $b ^ $c; }

sub out { my ($ar, $x) = @_; push @$ar, combo($x) % 8; }
