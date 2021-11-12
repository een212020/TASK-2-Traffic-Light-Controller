`timescale 1ns / 1ps

module Testbench;
    reg clk, reset, ped_button, em_button;
    reg [7:0] data_in;
    wire [7*7:0] N_color, E_color, S_color, W_color;
    wire [7:0] n_count, e_count, s_count, w_count;
    wire [6:0] n_msb, n_lsb, e_msb, e_lsb, s_msb, s_lsb, w_msb, w_lsb;
    
    initial begin
        clk = 0;
        em_button = 0;
        ped_button = 0;
        reset = 0;#2
        data_in = 2;#2
        reset = 1; #100
        data_in = 10; #100
        data_in = 0; #100
        data_in = 5; #100
        data_in = 20; #130
        #0.25
        em_button = 1;#1
        em_button = 0;#200
        ped_button = 1;#1
        ped_button = 0; #200
        $finish;
    end
    
    Traffic_Main_Module DUT(clk, reset, data_in, ped_button, em_button,
                            N_color, E_color, S_color, W_color, 
                            n_count, e_count, s_count, w_count, 
                            n_msb, n_lsb, e_msb, e_lsb, s_msb, s_lsb, w_msb, w_lsb
                            );
    always #0.5 clk=~clk;
endmodule
