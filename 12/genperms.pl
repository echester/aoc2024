#!/usr/bin/perl
#utility script to gen patterns

for (my $i=0; $i<256; $i++) {
    my $b = sprintf "%08b", $i;
    print "\n(\$ctype =~ \/$b\/) || \n";
    showgrid($b);
}

sub showgrid {
    my @c = split //, shift;
    print $c[0],$c[1],$c[2],"\n";
    print $c[3],'X',$c[4],"\n";
    print $c[5],$c[6],$c[7],"\n";
}
