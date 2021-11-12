`timescale 1ns / 1ps

module to_seven_seg(A, msb, lsb
    );
    input [7:0] A;
    output wire [6:0] msb, lsb;
//    always @(A) begin
//    msb = A[7:4];
//    lsb = A[3:0];
//    end
    seven_seg S1(A[7:4], msb);
    seven_seg S2(A[3:0], lsb);    
endmodule
