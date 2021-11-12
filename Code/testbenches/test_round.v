`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.10.2021 19:46:48
// Design Name: 
// Module Name: test_round
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test_round();
reg [7:0] x, out;

initial begin
x = 'd26;
#100;
x = 'd53;
end

round DUT(.x(x), .out(out));

endmodule
