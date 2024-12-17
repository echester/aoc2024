#!/usr/bin/perl
# aoc2024-17

# advent of code 2024 | ed chester
# day 17 - Chronospatial Computer

use v5.28;

my $a = my $b = my $c = my $j = 0;
my @ins;
my @outlist;

while(<>) {
	chomp;
	if (/A:\s(\d+)/) { $a = $1; }
	elsif (/B:\s(\d+)/) { $b = $1; }
	elsif (/C:\s(\d+)/) { $c = $1; }
	elsif (/m:\s(.+)/) { @ins = split ',', $1; }
}

while(1) {
	last if ($j>$#ins);
	my ($opc, $v) = ($ins[$j], $ins[$j+1]);
	if ($opc == 0) { adv($v); }
	elsif ($opc == 1) { bxl($v); }
	elsif ($opc == 2) { bst($v); }
	elsif ($opc == 3) { jnz($v); }
	elsif ($opc == 4) { bxc($v); }
	elsif ($opc == 5) { out(\@outlist, $v); }
	elsif ($opc == 6) { bdv($v); }
	elsif ($opc == 7) { cdv($v); }
	$j += 2;
}

say join ',', @outlist;

sub adv {
	my $x = shift;
	if ($x == 4) { $x = $a; }
	elsif ($x == 5) { $x = $b; }
	elsif ($x == 6) { $x = $c; }
	$a = int( $a / 2**$x );
	}

sub bdv {
	my $x = shift;
	if ($x == 4) { $x = $a; }
	elsif ($x == 5) { $x = $b; }
	elsif ($x == 6) { $x = $c; }
	$b = int( $a / 2**$x );
	}

sub cdv {
	my $x = shift;
	if ($x == 4) { $x = $a; }
	elsif ($x == 5) { $x = $b; }
	elsif ($x == 6) { $x = $c; }
	$c = int( $a / 2**$x );
	}

sub bxl { $b = $b ^ shift; }

sub bst {
	my $x = shift;
	if ($x == 4) { $x = $a; }
	elsif ($x == 5) { $x = $b; }
	elsif ($x == 6) { $x = $c; }
	$b = $x % 8;
	}

sub jnz { $j = shift() - 2 unless !$a; }

sub bxc { $b = $b ^ $c; }

sub out {
	my ($ar, $x) = @_;
	if ($x == 4) { $x = $a; }
	elsif ($x == 5) { $x = $b; }
	elsif ($x == 6) { $x = $c; }
	push @$ar, $x % 8;
	}
