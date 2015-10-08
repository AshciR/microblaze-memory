`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:56:14 10/30/2014 
// Design Name: 
// Module Name:    sram_model 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module sram_model(
    input [9:0] addr,
    inout [7:0] data,
    input oe_n,
    input we_n
    );
	
	/* Creates an array of 1024 memory cells, each 8-bits wide */
	reg [7:0] sram[0:1023];
	
	/* Load the data on the rising edge of we_n signal */
	always @ (posedge we_n)
		sram[addr] = data;
	
	/* Create tri-state signal for the data 
		drive data lines when oe_n is low, else tri-state */
	assign data = (oe_n == 0) ? sram[addr] : 8'bz;
	

endmodule
