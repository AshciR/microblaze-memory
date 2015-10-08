//////////////////////////////////////////////////////////////////////////////////
// Company: WPI
// Engineer: Richard Walker
// 
// Create Date:    18:21:47 10/15/2014 
// Design Name: 
// Module Name:    seven_seg_deocder 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Module used to interface with the 7 segment display
// 				 Takes an 16-bit input (4-bits per digit), then displays
//					 the digit on the 4 anodes of the seven segment display
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module seven_seg_deocder(
    input      [15:0] data,
    input      [1:0]  anode_sel,
    output reg [3:0]  anode,
    output reg [6:0]  segLED
    );

	/* Defining the constants */
	/* g f e d c b a */
	
	parameter zero  = 7'b1000000;  
	parameter one   = 7'b1111001;
	parameter two   = 7'b0100100;
	parameter three = 7'b0110000;
	parameter four  = 7'b0011001;
	parameter five  = 7'b0010010;
	parameter six   = 7'b0000010;
	parameter seven = 7'b1111000;
	parameter eight = 7'b0000000;
	parameter nine  = 7'b0010000;
	parameter a 	 = 7'b0001000;
	parameter b 	 = 7'b0000011;
	parameter c  	 = 7'b1000110;
	parameter d 	 = 7'b0100001;
	parameter e 	 = 7'b0000110;
	parameter f     = 7'b0001110;
	parameter off   = 7'b1111111;
	
	/* Splits the 16-bit bus into 4 4-bit parts.
	Each part will serve at the number representation for an anode
	AN3 AN2 AN1 AN0 */
	
	wire [3:0] data_3;
	wire [3:0] data_2;
	wire [3:0] data_1;
	wire [3:0] data_0;
	
	assign data_3 = data[15:12];
	assign data_2 = data[11:8];
	assign data_1 = data[7:4];
	assign data_0 = data[3:0];
	
	/* Decodes the data provided by the mux */
	always @ (data_to_seg) 
		case(data_to_seg)
			4'b0000: segLED = zero;
			4'b0001: segLED = one;
			4'b0010: segLED = two;
			4'b0011: segLED = three;
			4'b0100: segLED = four;
			4'b0101: segLED = five;
			4'b0110: segLED = six;
			4'b0111: segLED = seven;
			4'b1000: segLED = eight;
			4'b1001: segLED = nine;
			4'b1010: segLED = a;
			4'b1011: segLED = b;
			4'b1100: segLED = c;
			4'b1101: segLED = d;
			4'b1110: segLED = e;
			4'b1111: segLED = f;
			default: segLED = off;
		endcase; 
	 
	/* Checks the mux select signal then passes 
	the corresponding digit to the decoder */
	reg [3:0] data_to_seg; // the output of mux; input to the seg_decoder 
	
	always @ (anode_sel, data_to_seg, data_3, data_2, data_1, data_0)
		case(anode_sel) 
			2'b11:   data_to_seg = data_3; // Digit 3
			2'b10:   data_to_seg = data_2; // Digit 2
			2'b01:   data_to_seg = data_1; // Digit 1
			default: data_to_seg = data_0; // Digit 0
		endcase;		
	
	/* Checks the mux select signal then turns on the corresponding anode */
	always @ (anode_sel, anode)
		case(anode_sel) 
			2'b11:   anode = 4'b0111; // Anode 3
			2'b10:   anode = 4'b1011; // Anode 2
			2'b01:   anode = 4'b1101; // Anode 1
			default: anode = 4'b1110; // Anode 0
		endcase;	
	
endmodule
