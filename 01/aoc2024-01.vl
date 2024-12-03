// aoc2024-01.vl
// a behavioural verilog model to solve day 1 of AoC2024
// Yes, this is ridiculous, but this is the first step to a hardware
// solution instead of software ;)
// The barrier here is implementing bubble sort in hardware, which
// is totally doable but is easiest with microcode, at which point this
// behavioural model isn't even close. 
// If I have time I'll get it done with a counter and a pair of registers.
// Do not hold your breath.

`define MEMSIZE 1000

module test;
	reg [31:0] mem [0:2*`MEMSIZE-1];
	reg [31:0] le [0:`MEMSIZE-1];
	reg [31:0] ri [0:`MEMSIZE-1];
	reg [31:0] out;

	integer i, j, t, s, d;

	initial begin
		// load interleaved memory map
		$readmemh("inputh.dat", mem);
		for(i=0; i<`MEMSIZE; i=i+1) begin
			le[i] = mem[2*i];
			ri[i] = mem[2*i+1];
		end

		//sort left
		for (i=0; i<`MEMSIZE; i=i+1)
			for (j=0; j<`MEMSIZE - i; j=j+1)
				if (le[j] > le[j+1]) begin
					t = le[j]; le[j] = le[j+1]; le[j+1] = t;
				end

		//sort right
		for (i=0; i<`MEMSIZE; i=i+1)
			for (j=0; j<`MEMSIZE - i; j=j+1)
				if (ri[j] > ri[j+1]) begin
					t = ri[j]; ri[j] = ri[j+1]; ri[j+1] = t;
				end

		//part1
		s = 0;
		for(i=0; i<`MEMSIZE; i=i+1) begin
			if (le[i] > ri[i])
				d = le[i] - ri[i];
			else
				d = ri[i] - le[i];
			s = s + d;
		end
		assign out = s;
		$display("Pt1: [%d]", out);

		//part2
		s = 0;
		for(i=0; i<`MEMSIZE; i=i+1) begin
			s = s + le[i] * simil(le[i]);
		end
		assign out = s;		
		$display("Pt2: [%d]", out);
	end


function [31:0] simil;
	input [31:0] lval;
	begin
		simil = 0;
		for(j=0; j<`MEMSIZE; j=j+1) begin
			if (ri[j] == lval)
				simil = simil + 1;
		end
	end
endfunction

endmodule