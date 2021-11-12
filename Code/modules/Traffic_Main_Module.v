`timescale 1ns / 1ps

module Traffic_Main_Module(
    clk, reset, data_in, ped_button, em_button,
    N_color, E_color, S_color, W_color, 
    n_count, e_count, s_count, w_count,
    n_msb, n_lsb, e_msb, e_lsb, s_msb, s_lsb, w_msb, w_lsb
    );
    //inputs
    input clk, reset, ped_button, em_button;
    input [7:0] data_in;
    //outputs
    output wire [7*7:0] N_color, E_color, S_color, W_color;
    output wire [7:0] n_count, e_count, s_count, w_count;
    output wire [6:0] n_msb, n_lsb, e_msb, e_lsb, s_msb, s_lsb, w_msb, w_lsb;
    
    //wires and regs to be used between the different modules
    reg [1:0] next_road;
    wire [7:0] N_n, N_e, N_s, N_w;
    wire [7:0] TGn, TGe, TGs, TGw;
    wire [7:0] count;
    
    // check which road is next in the cycle
    always @(posedge state)begin
        if (!reset)
            next_road = 0;
        else begin
            case(state)
                0: next_road = 1;
                2: next_road = 2;
                4: next_road = 3;
                6: next_road = 0;
            endcase
        end
    end
    
    // sense vehicles at required road and find average of vehicles
    north_sensor S1(reset, next_road, data_in, N_n);
    east_sensor S2(reset, next_road, data_in, N_e);
    south_sensor S3(reset, next_road, data_in, N_s);
    west_sensor S4(reset, next_road, data_in, N_w);
    
    // send obtained average for TGx calculations
    Adaptation_Unit A1( reset, next_road, 
                        N_n, N_e, N_s, N_w, 
                        TGn, TGe, TGs, TGw 
                        );
                        
    // use updated TGx values for display
    Display_Timer D1(clk, reset, ped_button, em_button, 
                    TGn, TGe, TGs, TGw,
                    state, count,
                    N_color, E_color, S_color, W_color, 
                    n_count, e_count, s_count, w_count, 
                    n_msb, n_lsb, e_msb, e_lsb, s_msb, s_lsb, w_msb, w_lsb 
                    );
    
endmodule
