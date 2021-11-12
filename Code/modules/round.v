`timescale 1ns / 1ps

//try implementing as function
module round(x, out
    );
    input [7:0] x;
    output reg [7:0] out;
    reg [3:0] n;
    reg [3:0] rem;

    always @(x) begin
        n = 4'd10;
        rem = x%n;
        out = (x%n>5)? (x-rem + 10) : (x-rem);
    end
endmodule
