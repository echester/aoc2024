#!/usr/bin/perl
# aoc2024-21

# advent of code 2024 | ed chester
# day 21 - Keypad Conundrum

# Absolutely the most surprising victory over part 1 have ever managed (or will ever).
# At nearly 6 hours in while i clean up my code, nobody else in the private leaderboard has it done,
# and i'm not sure why.

use v5.10;
my @codes;

my %kp1 = ( 'A_0' => '<', 'A_1' => '^<<', 'A_2' => '<^', 'A_3' => '^', 'A_4' => '^^<<', 'A_5' => '<^^', 'A_6' => '^^', 'A_7' => '<<^^^', 'A_8' => '<^^^', 'A_9' => '^^^',
			'0_1' => '^<', '0_2' => '^', '0_3' => '>^', '0_4' => '<^^', '0_5' => '^^', '0_6' => '>^^', '0_7' => '<^^^', '0_8' => '^^^', '0_9' => '>^^^',
            '1_2' => '>', '1_3' => '>>', '1_4' => '^', '1_5' => '^>', '1_6' => '>>^', '1_7' => '^^', '1_8' => '>^^', '1_9' => '>>^^',
            '2_3' => '>', '2_4' => '<^', '2_5' => '^', '2_6' => '>^', '2_7' => '<^^', '2_8' => '^^','2_9' => '>^^',
			'3_4' => '^<<', '3_5' => '^<', '3_6' => '^', '3_7' => '<<^^', '3_8' => '<^^', '3_9' => '^^',
			'4_5' => '>', '4_6' => '>>', '4_7' => '^', '4_8' => '^>', '4_9' => '^>>',
			'5_6' => '>', '5_7' => '<^', '5_8' => '^', '5_9' => '>^',
			'6_7' => '<<^', '6_8' => '<^', '6_9' => '^','7_8' => '>', '7_9' => '>>',
			'8_9' => '>' );

my %kp2 = ( 'A_>' => 'v', 'A_v' => 'v<', 'A_<' => 'v<<', 'A_^' => '<',
            '^_>' => 'v>', '^_<' => 'v<',
            '<_v' => '>', '<_^' => '>^',
            'v_<' => '<', 'v_>' => '>',
			'>_^' => '<^', '>_v' => '<',
            '<_<' => '', '>_>' => '', 'v_v' => '', '^_^' => '', 'A_A' => ''
);

my $part1 = 0;
while(<>) {
	chomp;
	$part1 += part1($_);
	}

say $part1;


sub part1 {
	my $code = shift;
	return complx($code, genseqkp2(genseqkp2(genseqkp1($code))));
}

sub genseqkp1 {
	my $code = shift;
	my @list = split //, $code;
	unshift @list, 'A';
	my $seq = '';

	for (my $i=1; $i<=$#list; $i++) {
		my $f = $list[$i-1];
		my $t = $list[$i];
		my $press = getkp1pressseq($f, $t);
		$seq .= $press;
	}
	return $seq;
}

sub genseqkp2 {
	my $inseq = shift;
	my @list = split //, $inseq;
	unshift @list, 'A';
	my $seq = '';
	for (my $i=1; $i<=$#list; $i++) {
		my $f = $list[$i-1];
		my $t = $list[$i];
		my $press = getkp2pressseq($f, $t);
		$seq .= $press;
	}
	return $seq;
}

sub getkp1pressseq {
	my ($f, $t) = @_;
	if (defined $kp1{j($f,$t)}) {
		return $kp1{j($f,$t)} . 'A';
	}
	else {
		return revseq($kp1{j($t,$f)}) . 'A';
	}
}

sub getkp2pressseq {
	my ($f, $t) = @_;
	if (defined $kp2{j($f,$t)}) {
		return $kp2{j($f,$t)} . 'A';
	}
	else {
		return revseq($kp2{j($t,$f)}) . 'A';
	}
}

sub revseq {
	my $seq = shift;
	my $rev = '';
	foreach (reverse split //, $seq) {
		if (/>/) { $rev .= '<'; }
		elsif (/</) { $rev .= '>'; }
		elsif (/v/) { $rev .= '^'; }
		elsif (/^/) { $rev .= 'v'; }
	}
	return $rev;
}

sub flippath { return scalar reverse shift; }

sub complx {
	my ($code, $seq) = @_;
	$code =~ s/A//;
	my $l = length $seq;
	return $code * length($seq);
}

sub j {	return join '_', @_; }
