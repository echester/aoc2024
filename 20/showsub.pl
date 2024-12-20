sub show {
	for (my $r=0; $r<$size; $r++) {
		for (my $c=0; $c<$size; $c++) {
			my $adr = join '_', ($r, $c);
			if (defined ($wall{$adr})) { print "#"; }
			elsif ($adr eq $s) { print "S"; }
			elsif ($adr eq $e) { print "E"; }
			else { print '.'; }
		}
		print "\n";
	}
	print "\n";
}
