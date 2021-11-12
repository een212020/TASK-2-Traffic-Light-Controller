`timescale 1ns / 1ps

module adaptation_sensor_unit(
    reset, next_road, data,
    N_n, N_e, N_s, N_w,
    TGn, TGe, TGs, TGw,
    );
    input reset;
    input [1:0] next_road;
    input [7:0] data;
    
    output [7:0] TGn, TGe, TGs, TGw;
    output [7:0] N_n, N_e, N_s, N_w;
    
    wire [7:0] data_in;
    
    assign data_in = data;        

    
    north_sensor S1(reset, next_road, data_in, N_n);
    east_sensor S2(reset, next_road, data_in, N_e);
    south_sensor S3(reset, next_road, data_in, N_s);
    west_sensor S4(reset, next_road, data_in, N_w);
    
    Adaptation_Unit A1(
    reset, next_road,
    N_n, N_e, N_s, N_w, 
    TGn, TGe, TGs, TGw,
    );
    
endmodule
