`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WPI
// Engineer: Richard Walker
// 
// Create Date:    17:13:44 10/30/2014 
// Design Name: 
// Module Name:    sram_decoder 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Reads the address line and data line then converts into info a 16-bit
// 				 form for the 7-segment display
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module sram_decoder(
    input [7:0] data,
    input [22:0] addr,
    output [15:0] data_to_seg
    );
	
	/* Concatnate the 8-bit addr representation with the data representaion. 
		The data is already 8-bits, so no need to decode it*/
	assign data_to_seg = {addr_seg, data};
	
	/* reg to hold the address info as 8-bits */
	reg [7:0] addr_seg;
	
	/* Decodes the 23-bit addr data into a 8-bit form for the 7-segment */
	always @ (addr)
	begin
		
			/* if the addr is more than 255, then it can not be displayed with 2 digits (in hex) */
			if (addr > 255)
				addr_seg <= 8'b00000000; // just display the address as "00"
			
			/* else the address can be represented */ 
			else
				addr_seg <= addr[7:0];
				
	end
	
endmodule
