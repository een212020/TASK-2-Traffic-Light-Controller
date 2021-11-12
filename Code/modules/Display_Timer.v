`timescale 1ns / 1ps

module Display_Timer(
    clk, reset, ped_button, em_button, 
    TGiN, TGiE, TGiS, TGiW,
    state, count,
    N_color, E_color, S_color, W_color, 
    n_count, e_count, s_count, w_count,
    n_msb, n_lsb, e_msb, e_lsb, s_msb, s_lsb, w_msb, w_lsb 
    );
    
    input clk, reset, ped_button, em_button;
    input [7:0] TGiN, TGiE, TGiS, TGiW;
    
    output wire [3:0] state;
    output wire [7:0] count;
    output wire [7*7:0] N_color, E_color, S_color, W_color;
    output wire [7:0] n_count, e_count, s_count, w_count;
    output wire [6:0] n_msb, n_lsb, e_msb, e_lsb, s_msb, s_lsb, w_msb, w_lsb;   
    wire [7:0] TGN, TGE, TGS, TGW;
    // send TGx values for rounding
    round R0(TGiN, TGN);
    round R1(TGiE, TGE);
    round R2(TGiS, TGS);
    round R3(TGiW, TGW);
    // send rounded values into FSM
    fsm F1(clk, reset, ped_button, em_button, 
                TGN, TGE, TGS, TGW,
                state, count, 
                N_color, E_color, S_color, W_color, 
                n_count, e_count, s_count, w_count);
    // send countdown values for each road into seven segments            
    to_seven_seg S1(n_count, n_msb, n_lsb);
    to_seven_seg S2(e_count, e_msb, e_lsb);
    to_seven_seg S3(s_count, s_msb, s_lsb);
    to_seven_seg S4(w_count, w_msb, w_lsb);
    
endmodule
