`timescale 1ns / 1ps

module Adaptation_Unit(
    reset, next_road,
    N_n, N_e, N_s, N_w, 
    TGn, TGe, TGs, TGw,
    tot, avg 
    );
    
    input reset;
    input [1:0] next_road;
    input [7:0] N_n, N_e, N_s, N_w;
    
    output reg [7:0] TGn, TGe, TGs, TGw;
    
    reg [7:0] TGin, TGie, TGis, TGiw;
    output reg [9:0] tot;
    output reg [7:0] avg;
    parameter b = 1;

    
    always @(next_road or reset) begin
        //initialise when low
        if(!reset) begin
            TGin <= 40;
            TGie <= 40;
            TGis <= 40;
            TGiw <= 40;
            TGn <= TGin;
            TGe <= TGie;
            TGs <= TGis;
            TGw <= TGiw;
        end
        
        //Calculate sum of Ni
        tot = N_n + N_e + N_s + N_w;
        //Calculate average using right shift
        avg = tot >> 2;      
        
        //update TGx values according to next_road value
        case (next_road)
            0: begin 
                    TGn = TGin + b*(N_n - avg);
                    TGin = TGn;
               end         
            1: begin
                    TGe = TGie + b*(N_e - avg);
                    TGie = TGe;
               end       
            2: begin
                    TGs = TGis + b*(N_s - avg);
                    TGis = TGs;
               end
            3: begin
                    TGw = TGiw + b*(N_w - avg);
                    TGiw = TGw;
               end
        endcase

    end
endmodule
