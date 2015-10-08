//////////////////////////////////////////////////////////////////////////////////
// Company: WPI
// Engineer: Richard Walker
// 
// Create Date:    19:26:15 10/15/2014 
// Design Name: 
// Module Name:    seg_mux_counter 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 0-4 counter whoose output is used to drive the 
//					 input for the mux in the seven segment decoder\
//
//					 N.B. The input clock should nominally be 25 MHz	
//					
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module seg_mux_counter(
    input clock_in, 
    input reset,
    output reg [1:0] count_out
    );
	
	/* the number of cycles it takes to reach 1/2 the required period */
	parameter COUNT_25M = 499;
	
	/* Registers for the counter */
	reg [8:0] counter_25M;
	reg clock_25k = 1'b0; // used as the 25 kHz clock
	
	/* generate a 25 kHz clock from the 25 MHz clock */
	always @ (posedge clock_in or posedge reset)
	begin
		// If reset is pressed 
		if (reset)
			begin
				counter_25M <= 0;
				clock_25k <= 1'b0;
			end
		else
			// if the counter reached 1/2 the value of the period
			if (counter_25M == COUNT_25M)
				begin
					counter_25M <= 0;
					clock_25k <= !clock_25k;
				end
			// the counter hasn't reached 1/2 value yet
			else
				counter_25M <= counter_25M + 1'b1;
	end
	
	/* Count from 0 to 3 */
	always @ (posedge clock_25k or posedge reset)
	begin
		// if reset, set the count value to 0
		if (reset)
			count_out <= 2'b00;
		// else keep counting
		else
			// if count reached 3, start back at 0
			if (count_out == 2'b11)
				count_out <= 2'b00;
			else
				count_out <= count_out + 1'b1;
	end

endmodule
