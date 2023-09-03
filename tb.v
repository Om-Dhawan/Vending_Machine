`timescale 1ns / 1ps
`include "Projects/Vending_machine/main.v"

module vending_testbench;

	// Inputs
	reg [1:0] coin;
	reg coin_insert;
	reg coin_return;
	reg [1:0] product;
	reg enable;
	reg clk;
	reg reset;

	// Outputs
	wire [1:0] pro;
	wire [2:0] change;

	// Instantiate the Unit Under Test (UUT)
	vending_Controller uut (
		.coin(coin), 
		.coin_insert(coin_insert), 
		.coin_return(coin_return), 
		.product(product), 
		.enable(enable), 
		.clk(clk), 
		.reset(reset), 
		.pro(pro), 
		.change(change)
	);

	initial begin
        $dumpfile("Projects/Vending_machine/graph.vcd");
        $dumpvars(0,vending_testbench);
		// Initialize Inputs
		coin = 2'b11;
		coin_insert = 0;
		coin_return = 0;
		product = 2'b01;
		enable = 0;
		clk = 0;
		reset = 1;
        
		// Add stimulus here
			enable = 1;
		#10 reset = ~reset;
			coin_insert = 1;
		#30 coin_insert = 0;
	end
   always #5 clk = ~clk; // Clock Generation
endmodule
