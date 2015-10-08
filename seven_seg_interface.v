//////////////////////////////////////////////////////////////////////////////////
// Company: WPI
// Engineer: Richard Walker
// 
// Create Date:    19:55:16 10/15/2014 
// Design Name: 
// Module Name:    seven_seg_interface 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Interface to be used with the seven segment display
//					 on the Nexys 3 Board
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module seven_seg_interface(
    input clock_in,
	 input reset,
    input [15:0] data_in,
    output [6:0] segs_out,
	 output [3:0] anode_out
    );
		
	/* The output of the counter; 
		input to the mux on the decoder */
	wire[1:0] anode_sel;
	
	/* Instantiting the modules */
	
	// The Decoder/Mux Module
	seven_seg_deocder U1 (
    .data(data_in), 
    .anode_sel(anode_sel), 
    .anode(anode_out), 
    .segLED(segs_out)
    );
	 
	// The 0-3 Counter used for the mux
	seg_mux_counter U2 (
    .clock_in(clock_in), 
    .reset(reset), 
    .count_out(anode_sel)
    );

endmodule
