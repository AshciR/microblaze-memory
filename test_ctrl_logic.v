`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:09:22 11/02/2014
// Design Name:   ctrl_logic
// Module Name:   M:/ECE_574/Verilog_Projects/Project_2_5_2_1/test_ctrl_logic.v
// Project Name:  Project_2_5_2_1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ctrl_logic
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_ctrl_logic;

	// Inputs
	reg clk;
	reg rst;
	reg [7:0] switches;
	reg write;
	reg read;

	// Outputs
	wire [22:0] addr;
	wire ce;
	wire we;
	wire oe;
	wire sram_clk;
	wire adv;
	wire cre;
	wire lb;
	wire ub;

	// Bidirs
	wire [7:0] databus;

	// Instantiate the Unit Under Test (UUT)
	ctrl_logic uut (
		.clk(clk), 
		.rst(rst), 
		.switches(switches), 
		.write(write), 
		.read(read), 
		.addr(addr), 
		.databus(databus), 
		.ce(ce), 
		.we(we), 
		.oe(oe), 
		.sram_clk(sram_clk), 
		.adv(adv), 
		.cre(cre), 
		.lb(lb), 
		.ub(ub)
	);
	
	// 50 MHz Clock
	always
	begin
		clk = 0;
		#5;
		clk = 1;
		#5;
	end
	
	// SRAM model
	sram_model SRAM (
    .addr(addr), 
    .data(databus), 
    .oe_n(oe), 
    .we_n(we)
    );
	
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		switches = 0;
		write = 0;
		read = 0;

		// Wait 100 ns for global reset to finish
		#100;
      rst = 0;
		#200;
        
		// Add stimulus here
		
		// Write the 4 values into RAM
		switches = 255;
		write = 1;
		#100;
		write = 0;
		#300;
		
		switches = 128;
		write = 1;
		#100;
		write = 0;
		#300;
		
		switches = 64;
		write = 1;
		#100;
		write = 0;
		#300;
		
		switches = 32;
		write = 1;
		#100;
		write = 0;
		#300;
		
		// Finished Writing to the 4 addresses, time to read from them
		// remember the switches represent the address location now
		switches = 0;
		read = 1;
		#100;
		read = 0;
		#300;
		
		switches = 1;
		read = 1;
		#100;
		read = 0;
		#300;
		
		switches = 2;
		read = 1;
		#100;
		read = 0;
		#300;
		
		switches = 3;
		read = 1;
		#100;
		read = 0;
		#300;
		

	end
      
endmodule

