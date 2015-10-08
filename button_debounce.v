//////////////////////////////////////////////////////////////////////////////////
// Company: WPI
// Engineer: Richard Walker
// 
// Create Date:    18:12:37 10/27/2014 
// Design Name: 
// Module Name:    button_debounce 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Module used to debounce the load button for the write control
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module button_debounce(
    input clk, // 100 MHz clock
	 input rst,
    input button,
    output reg pulse
    );

	/* State machine states */
	parameter [1:0] press_state    = 2'b00, 
						 release_state  = 2'b01,
						 high_state     = 2'b10,
						 low_state      = 2'b11;
	
	/* Holds the next state and current state logic */
	reg [1:0] current_state, next_state;
	
	/* Clock divide signals */
	reg [3:0] clk_count;
	wire clk_10_en;
	
	/* -------------- Processes -------------- */
	
	/* Clock divider process, create a 10 MHz clock for the state machine
		and 0-3 counter from the 100 MHz input clock */
	always @ (posedge clk, posedge rst)
		if (rst)
			clk_count <= 0;
		else if (clk_count == 9)
			clk_count <= 0;
		else
			clk_count <= clk_count + 1'b1;
	
	/* Goes high when the count reached it's max value */
	assign clk_10_en = (clk_count == 9);
	
	/* ------------- State Machine ---------------- */

	/* State machine sequential logic */
	always @ (posedge clk_10_en, posedge rst)
		if (rst)
			current_state <= press_state;
		else
			current_state <= next_state;

	/* Next State logic */
	always @ (current_state, button)
		case (current_state)
			
			/* Button Pressed? */
			press_state: begin
								/* if the button is pressed */
								if (button)
									next_state = release_state; // go to released? state
								else
									next_state = press_state;  // Stay in this state
							 end
			
			/* Button Released? */
			release_state: begin
									/* is the button still high? */
									if (button)
										next_state = release_state; //stay in this state
									else
										/* the button has been released */
										next_state = high_state;
								end
						 
			/* High State used to begin the output pulse */
			high_state: begin
								next_state = low_state; // go to the low state
							end
			
			/* Low state used finish the output pulse */
			low_state: begin
								next_state = press_state; 
						  end
			
		endcase
		
		/* State machine logic */
		
		/* the current state is high, then start the pulse */ 
		always @ (pulse, current_state)
			if (current_state == high_state)
				pulse <= 1;
			else
				pulse <= 0;
		
	
endmodule
