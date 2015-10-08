`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WPI	
// Engineer: Richard Walker
// 
// Create Date:    20:46:25 11/02/2014 
// Design Name: 
// Module Name:    fgpa_sram 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Top module for implementing the SRAM on the FPGA board
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module fgpa_sram(
    input fpga_clk,
    input rst,
    input [7:0] switches,
    input write,
    input read,
    
	 output [3:0] anodes,
	 output [6:0] segments,
	 
	 inout [7:0] databus,
    output [25:0] addr,
    
	 // Status signals
	 output clk_lock,
	 output write_out,
	 output read_out,
	 output read_led,
	 output write_led,
	 
	 output ce,
    output we,
    output oe,
    output sram_clk,
    output adv,
    output cre,
    output lb,
    output ub
    );
	
	/* Set the unused memory outputs to ground */
	assign addr[25:23] = 3'b0;
	
	/* 100MHz and 25MHz clk line */
	wire clk_100;
	wire clk_25;
	
	/* Wires to hold the data read from the inout bus */
	wire [7:0] internal_bus;
	wire [7:0] seg_data;
	
	/* 16-bit data that gets sent to the 7-seg display */
	wire [15:0] data_to_seg;
	
	/* Assign a LED to tell which mode your currently in */
	assign read_led = read_mode;
	assign write_led = ~read_mode;
	
	/* Flashes if read or write occurs */
	assign write_out = (write_flash) ? 1'b0 : 1'b1;
	assign read_out  = (read_flash)  ? 1'b0 : 1'b1;
	
	/* DCM */
	dcm_100 U1
   (// Clock in ports
    .CLK_IN1(fpga_clk),      // IN
    // Clock out ports
    .CLK_OUT1(clk_100),     // OUT
	 .CLK_OUT2(clk_25),     // OUT
    // Status and control signals
    .RESET(rst),// IN
    .LOCKED(clk_lock));      // OUT
	 
	 /* The SRAM Interface */
	 ctrl_logic U2 (
    .clk(clk_100), 
    .rst(rst), 
    .switches(switches), 
    .write(write_b), 
    .read(read_b),
	 .write_out(write_flash), 
    .read_out(read_flash),
	 .read_mode(read_mode), 	 
    .addr(addr[22:0]), 
    .databus(databus), 
    .ce(ce), 
    .we(we), 
    .oe(oe), 
    .sram_clk(sram_clk), 
    .adv(adv), 
    .cre(cre), 
    .internal_bus(internal_bus), 
	 .lb(lb), 
    .ub(ub)
    );
	 
	 /* Write button debouncer */
	 button_debounce U3 (
    .clk(clk_100), 
    .rst(rst), 
    .button(write), 
    .pulse(write_b)
    );
	 
	 /* Read button debouncer */
	 button_debounce U4 (
    .clk(clk_100), 
    .rst(rst), 
    .button(read), 
    .pulse(read_b)
    );
	 
	 /* SRAM decoder for the 7-segment */
	 sram_decoder U5 (
    .data(seg_data), 
    .addr(addr[22:0]), 
    .data_to_seg(data_to_seg)
    );
	
	/* The data the should be decoded by the SRAM decoder 
		if you're in read mode, show the internal_bus data
		if you're in write mode show the switch data */
	assign seg_data = read_mode ? internal_bus : switches;
	
	/* 7-Segment display */
	seven_seg_interface U6 (
    .clock_in(clk_25), 
    .reset(rst), 
    .data_in(data_to_seg), 
    .segs_out(segments), 
    .anode_out(anodes)
    );

endmodule
