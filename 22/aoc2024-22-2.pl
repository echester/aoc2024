#!/usr/bin/perl
# aoc2024-22-2

# advent of code 2024 | ed chester
# day 22 - Monkey Market
#
# GOING TO ACTUALLY LABEL VARIABLES HERE cos the problem spec is unhinged and
# ultraconfusing. Also going to comment code because I will not follow this
# tomorrow.

use v5.10;
use List::Util qw| max |;

# buyer initial code list
my @in = ();
# tracker hash of totals for each sequence - CHECK OUT ITS SENSIBLE NAME!
my %totalsforseq;
# grab all input
while(<>) { chomp; push @in, $_; }

# loop over each buyer
foreach my $s (@in) {
	# look i know i don't need this but i added it in debug to track the hash to
	# see where the banana contributions were coming from and I am just leaving it
	# here as part of the evidence trail for how twisted this was
	my $buyer = $s;
	# init stuffs - probably more than i need tbh
	my @prices = ();
	my @diffs = ();
	my $p = 0;
	my %seqseen;

	# generate the secrets
	foreach (0..1999) {
		# keep the final digit
		my $bananas = $s % 10;
		# store it as price, in bananas
		push @prices, $bananas;
		# store the difference from previous secret's price
		push @diffs, $bananas - $p;
		# generate next secret
		$s = secret($s);
		# update the previous banana-price
		$p = $bananas;
	}

	# build all sequences of 4 differences in banana prices COS THAT MAKES SENSE
	for (my $i=3; $i<$#prices; $i++) {
		my @seq = @diffs[$i .. $i+3];
		# flatten the sequence to a string because this is already confusing and i want an easy hash index
		my $seqlabel = j(@seq);
		# if we've already had this sequence, it won't be seen used again
		next if (defined $seqseen{$seqlabel});
		# record the fact that the monkey dude has seen this sequence
		$seqseen{$seqlabel}++;
		# [store the banana price with the sequence it comes from WHOA I DON'T NEED THIS!!]
		$totalsforseq{$seqlabel} += $prices[$i+3];
	}
}

say max(values %totalsforseq);

sub secret {
	my $secret = shift;
	$secret = prune(mix($secret, $secret*64));
	$secret = prune(mix($secret, int ($secret/32)));
	return prune(mix($secret, $secret*2048));
}

sub mix {
	my ($secret, $mixval) = @_;
	return $secret ^ $mixval;
}

sub prune { return shift() % 16777216; }

sub j { return join '_', @_; }
