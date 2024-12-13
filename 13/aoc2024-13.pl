#!/usr/bin/perl
# aoc2024-13

# advent of code 2024 | ed chester
# day 13 - Claw Contraption
#
# Oh my days I was really expecting this to be an application of Chinese Remainder Theorem, 
# which I would have implemented incorrectly and then given up on.
#
# As it was, this is a straightforward simultaneous equation solution solved with row-echelon 
# reduction. I did have to look up what you do instead of determinants, but the 2 sub-determinants 
# work well and are used directly anyway. Tidy.
#
# (Just as well because i'm still debugging part 2 of yesterday and its major t!MeSuXoR)

my ($ax, $ay, $bx, $by, $tx, $ty);
my $tokenspt1 = my $tokenspt2 = 0;

while(<>) { 
    # parse lines => equations
    if    (/^.+A:\sX.(\d+).+Y.(\d+)/) { $ax = int($1); $ay = int($2); }   
    elsif (/^.+B:\sX.(\d+).+Y.(\d+)/) { $bx = int($1); $by = int($2); }   
    elsif (/^Priz.+X=(\d+).+Y.(\d+)/) { $tx = $1; $ty = $2; }

    # blank line => solve equation set
    else {
        if ($ax) {
            my @s = solve(0);
            $tokenspt1 += (3 * $s[0]) + $s[1] ; 
            @s = solve(10000000000000);
            $tokenspt2 += (3 * $s[0]) + $s[1] ; 
        }
    }
}

print "Part 1 = $tokenspt1\n";
print "Part 2 = $tokenspt2\n";

sub solve {
    my $offset = shift;
    $tx += $offset;
    $ty += $offset;
    my $codet = ($ax * $by) - ($bx * $ay);
    my $soldet = ($by * $tx) - ($bx * $ty);
    my $na = $soldet / $codet;

    return 0 if ($codet == 0);
    return 0 if ($soldet % $codet != 0);

    my $c = $ty - ($na * $ay);
    return 0 if ($c % $by != 0);

    my $nb = $c / $by;
    return ($na, $nb);
}
