`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WPI
// Engineer: Richard Walker
// 
// Create Date:    17:18:22 11/02/2014 
// Design Name: 
// Module Name:    ctrl_logic 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Control logic for the SRAM
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ctrl_logic(
    input clk,	// 100 MHz clock
    input rst,
    input [7:0] switches,
	 
	 // write and read buttons
	 input write,
	 input read,
	 
	 // output to tell if read or write occurred 
	 output write_out,
	 output read_out,
	 
	 // Goes high if you're in read mode
	 output read_mode,
	 
	 output [22:0] addr,   // Address line
	 inout [7:0] databus,  // The Data line
	 
	 output reg ce,	// Chip enable
    output reg we, // Write enable
    output reg oe, // Oupute enable
    
	 /* these are just grounded signals */
	 output sram_clk,
    output adv,
    output cre,
    
	 /* Internal bus used to hold the data from the SRAM */
	 output reg [7:0] internal_bus,
	 
	 /* Lower and Upper byte */
	 output lb,
    output ub
    );

	/* State machine states */
	parameter [1:0] wait_state     = 2'b00,
						 write_state 	 = 2'b01,
						 addr_state     = 2'b10,
						 read_state     = 2'b11;
	
	/* Holds the next state and current state logic */
	reg [1:0] current_state, next_state;
	
	/* Represents 0 for all the unused write addresss (addr[22:2]) */
	parameter [20:0] unusedAddr = 0;
	
	/* Represents blank input data when we're reading from the SRAM */
	parameter [7:0] blank_data = 0;
	
	/* 0-3 Counter signals */
	reg cnt_e; 					// enable 
	reg [2:0] addr_count;	// output from the counter
	
	/* Clock divide signals */
	reg [3:0] clk_count;
	wire clk_10_en;
	
	/* Wire to hold the value for input data */
	wire [7:0] input_data;
	
	/* flag to tell that write mode is done */
	wire write_finish;
	
	/* -------------- Assignments -------------- */
	
	/* These control signals are just low in Async mode */
	assign sram_clk = 0;
	assign adv = 0;
	assign cre = 0;
	
	/* Assign the following SRAM controls */
	assign	lb = 1'b0; // it's don't care unless write is enabled, but needs to be low when write is enabled
	assign	ub = 1'b1; // it's don't care, but should be high when write is enabled b/c we're not using upper byte
	
	/* Assigns which address should be written to. 
		If your in write mode, then the state machine sets the address,
		If your in read mode the address comes from the switches */		
	assign addr = (write_finish) ? {unusedAddr,switches[1:0]} : {unusedAddr,addr_count[1:0]}; 
	
	/* If we're in write mode, let the input data be equal to the switches 
		else, let the input data be 0 */
	assign input_data = (write_finish) ?  blank_data : switches;  
	
	/* Goes high if you're in read mode */
	assign read_mode = write_finish;
	
	/* If address count is not equal to 3 then we're still in write mode */
	assign write_finish = (addr_count == 4);
	
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
		
	/* 0-3 Counter used to keep track which address 
		should written to */
	always @ (posedge clk_10_en, posedge rst)
		if (rst) 
			addr_count <= 0;
		/* if the counter is enabled, increment the count by 1 */
		else if (cnt_e)
			if (addr_count == 4)
				addr_count <= 0;
			else 
				addr_count <= addr_count + 1'b1;
	
	
	/* ---------- SRAM Tri-State Assignments ---------------*/
	
	/* Every clock edge, place the data from the SRAM unto this internal bus */
	always @ (posedge clk)
		if (oe == 0)
			internal_bus <= databus;
		else 
			internal_bus <= internal_bus;
	
	/* If output enable is low, we're writing to the SRAM, else put it in high Z mode */
	assign databus = (we == 0) ? input_data : 8'bz; 
	
	/* -----------------------------------------------------*/
	
	/* Output logic to if a write or read has occured */
	assign write_out = (current_state == write_state) ? 1'b1 : 1'b0;
	assign read_out  = (current_state == read_state)  ? 1'b1 : 1'b0;
	
	/* ------------- State Machine ---------------- */

	/* State machine sequential logic */
	always @ (posedge clk_10_en, posedge rst)
		if (rst)
			current_state <= wait_state;
		else
			current_state <= next_state;
			
	/* Next State logic */
	always @ (current_state, write, read, write_finish)
		case (current_state)
			
			/* Wait state, just keep looping until the you're ready to load the data into memory */	
			wait_state: begin
								
								/* Set the outputs to the default values */
								ce = 1'b1; // Disable the chip
								we = 1'b1; // Disable write
								oe = 1'b1; // Disable Output enable
								
								/* Disable the address counter */
								cnt_e = 1'b0;
									
								/* If you haven't written in the last address yet */
								if (~write_finish) 
									/* Check if the write button has been pushed */
									if (write)	
										next_state = write_state; // go the the write state
									else
										next_state = wait_state; // Stay in this state
								
								/* You have written to the last address (addr 3) */
								else
									/* Check if the read button has been pushed */
									if (read)	
										next_state = read_state; // go the the read state
									else
										next_state = wait_state; // Stay in this state
							end
		
			/* Write State, Set the the control outputs to their corresponding values
				that allows data to be written */	
			write_state: begin
			
								/* Set the outputs values for writing */
								ce = 1'b0; // Enable the chip
								we = 1'b0; // Enable write
								oe = 1'b1; // Disable Output enable
								
								/* Disable the address counter */
								cnt_e = 1'b0;
									
									/* Go to the next state */
									next_state = addr_state;
							 end
			
			/* Address wait state, used to buy an addtional 100ns for the data to be written
				and for the address counter to be updated*/
			addr_state: begin	

								/* Set the outputs to the default values */
								ce = 1'b1; // Disable the chip
								we = 1'b1; // Disable write
								oe = 1'b1; // Disable Output enable
								
								/* Enable the address counter */
								cnt_e = 1'b1;
								
								/* Go to the next state */
								next_state = wait_state;
							end
			
			/* Read State, Set the the control outputs to their corresponding values
				that allows data to be written */	
			read_state: begin
			
								/* Set the outputs values for reading */
								ce = 1'b0; // Enable the chip
								we = 1'b1; // Disable write
								oe = 1'b0; // Enable Output enable
								
								/* Disable the address counter */
								cnt_e = 1'b0;
									
									/* Go to the next state */
									next_state = wait_state;	
							end			
		
		endcase

endmodule
