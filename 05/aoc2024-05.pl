#!/usr/bin/perl
# aoc2024-05
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
# In this version, I am leaving in the print debug output because I
# like it, and it was necessary to get this working. See my other solution
# for this day for a faster, cleaner approach. 

use v5.10;
use List::MoreUtils qw| first_index |;
use Time::HiRes qw| time |;

my $begin_time = time();

my @rules;
my @updates;
my $midsum = 0;
my $midsuminv = 0;

while(<>) {
	chomp;
	next unless length;
	if (/^(\d+)\|(\d+)$/) { push @rules, [$1,$2]; }
	else { push @updates, $_; }
	}

foreach (@updates) {
	my $mv = process($_);
	if ($mv > 0) {
		# say "VALID!";
		$midsum += $mv;
	}
	else {
		# say "NOT VALID";
		$midsuminv += fixed($_);
	}
}

say "pt1 = $midsum";
say "pt2 = $midsuminv";
my $end_time = time();
printf("%.3f\n", $end_time - $begin_time);

sub process {
	my @update = split /,/, shift;
	# say "Process Update: ", join ',', @update;
	my $valid = 0;
	for (my $i=0; $i<=$#update; $i++) {
		my $p = $update[$i];
		for (my $j=$i+1; $j<=$#update; $j++) {
			my $n = $update[$j];
			foreach my $r (@rules) {
				my ($b,$a) = @$r;
				if (($p==$b) && ($n==$a)) { $valid++; }
			}
		}
	}
	my $e = expt(scalar @update);
	return ($e == $valid) ? $update[ $#update/2 ] : -1;
}

sub fixed {
	my @update = split /,/, shift;
	# say "Fixing:";
	my $fixed = 0;
	my $temp;

	do {
	foreach my $r (@rules) {
		my ($b,$a) = @$r;
		# find these pages in the update list
		my $p_a = first_index { $_ eq $a } @update;
		my $p_b = first_index { $_ eq $b } @update;
		next unless ($p_a >= 0 && $p_b >= 0);
		# say "b $b at $p_b, a $a at $p_a";
		# next if (!$p_a |! $p_b);
		if ($p_a < $p_b) {
			$update[$p_a] = $b;
			$update[$p_b] = $a;
			# say " > new update try: ", join ',', @update;
			$temp = process(join ',', @update);
			if ($temp > 0) {
				# say "VALID!";
				$fixed++;
				last;
				}
			else {
				# say "NOT VALID";
				# redo;
			}
		}
	}
	} while (!$fixed);
	return $temp;
}

sub expt {
	# sum of all pos ints up to (but not) this one
	my ($v, $s) = (shift, 0);
	while ($v>0) { $s += $v - 1; $v--; }
	return $s;
}
