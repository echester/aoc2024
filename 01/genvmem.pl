# generate verilog memory file from decimal
my $addr = 0;
while(<>) {
	/^(\w+)\s+(\w+)/;
	printf "@%08x\n%08x   %08x\n\n", $addr, $1, $2;
	$addr+=2;
}