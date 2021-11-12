`timescale 1ns / 1ps

module Adaptation_tb;
    reg reset;
    reg [1:0] next_road;
    reg [7:0] data_in;
    wire [7:0] N_n, N_e, N_s, N_w;
    wire [7:0] TGn, TGe, TGs, TGw;
    
    initial begin
        reset = 1;#2
        next_road = 1; #10
        data_in = 100;#2
        next_road = 0;
        reset = 0; #50
        data_in = 100;#2
        next_road = 1; #50
        data_in = 200;#2
        next_road = 2; #50
        data_in = 150;#2
        next_road = 3; #50
        data_in = 240; #2
        next_road = 1; #10
        data_in = 190;#2
        next_road = 0;#50
        data_in = 100;#2
        next_road = 1; #50
        data_in = 200;#2
        next_road = 2; #50
        data_in = 228;#2
        next_road = 3; #50
        $finish;
    end
    
    adaptation_sensor_unit DUT(
    reset, next_road, data_in,
    N_n, N_e, N_s, N_w,
    TGn, TGe, TGs, TGw
    );
    
endmodule
