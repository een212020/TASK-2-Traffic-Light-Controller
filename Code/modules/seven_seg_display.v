`timescale 1ns / 1ps

module seven_seg(x, seg);
input [3:0] x;
output reg [6:0 ]seg;

always @(x)
    begin
        case (x)
            4'h0 : seg = 7'b0000001;
            4'h1 : seg = 7'b1001111;
            4'h2 : seg = 7'b0010010;
            4'h3 : seg = 7'b0000110;
            4'h4 : seg = 7'b1001100;
            4'h5 : seg = 7'b0100100;
            4'h6 : seg = 7'b0100000;
            4'h7 : seg = 7'b0001111;
            4'h8 : seg = 7'b0000000;
            4'ha : seg = 7'b1111101;
            4'hb : seg = 7'b0011111;
            4'hc : seg = 7'b0001101;
            4'hd : seg = 7'b0111101;
            4'he : seg = 7'b1001111;
            4'hf : seg = 7'b1000111; 
            default : seg = 7'b1111111; 
        endcase
     end
endmodule
