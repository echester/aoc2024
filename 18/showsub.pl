
sub show {
	for (my $r=0; $r<$size; $r++) {
		for (my $c=0; $c<$size; $c++) {
			my $adr = join '_', ($r, $c);
			if (defined ($nogo{$adr})) { print "#"; }
			else {
				print '.';
				}
		}
		print "\n";
	}
	print "\n";
}
