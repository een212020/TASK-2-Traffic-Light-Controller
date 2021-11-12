`timescale 1ns / 1ps

module fsm(
    clk, reset, ped_button, em_button,
    TGn, TGe, TGs, TGw, 
    state, count, 
    N_color, E_color, S_color, W_color, 
    n_count, e_count, s_count, w_count
    );
    
    input clk;
    input reset;
    input ped_button;
    input em_button;
    input [7:0] TGn, TGe, TGs, TGw;
    
    output reg [3:0] state;
    output reg [7:0] count;
    output reg [7*7:0] N_color, E_color, S_color, W_color;
    output reg [7:0] n_count, e_count, s_count, w_count;
    
    reg ped, em;
    // stores state of fsm just before emergency or pedestrian button was pressed
    reg [3:0] last_state;
    // stores TGx values
    reg [7:0] TGN, TGE, TGS, TGW;
    // stores count remaining if emergency button pressed in the middle of a green state 
    reg [7:0] remaining;
    // the duration of the total cycle
    parameter Tcycle = 200;
    // duration of orange state
    parameter TO = 10;
    
    // em = HIGH at positive edge of em_button 
    always @(posedge em_button) begin
        em = 1;
        last_state = state;
    end
    // ped = HIGH at positive edge of ped_button
    always @(posedge ped_button) begin
        ped = 1;
        last_state = state;
    end
    // update TGx values in registers
    always @(TGn or TGe or TGs or TGw)begin
        TGN = TGn;
        TGE = TGe;
        TGS = TGs;
        TGW = TGw;
    end
    
    always @(posedge clk or posedge em) begin
        //initialise values when reset LOW
        if (!reset) begin
            ped = 0;
            em = 0;
            N_color = "Red";
            E_color = "Red";
            S_color = "Red";
            W_color = "Red";
            remaining = 0;
            count = 0;
            TGN <= 40;
            TGE <= 40;
            TGS <= 40;
            TGW <= 40;
            n_count = TGN-1; 
            e_count = TGN + TO;
            s_count = TGN + TGE + TO + TO;
            w_count = TGN + TGE + TGS + TO + TO + TO;
        end
        // enter when reset HIGH
        else begin
            // when count is zero and neither emergency nor pedestrian button was pressed               
            if (!count & !em & !ped) begin                       
                // next state based on current state
                case(state) 
                    0: state = 1;
                    1: state = 2;
                    2: state = 3;
                    3: state = 4;
                    4: state = 5;
                    5: state = 6;
                    6: state = 7;
                    7: state = 0;
                    default: state = 0;
                endcase
            end
            // if mergency or pedestrian button was pressed
            else if(em|ped) begin
                // check if system was in the middle of a green state
                if (state==0|state==2|state==4|state==6) begin
                    // if emergency button was pressed, store remaining count value 
                    // and immediately enter next state (orange)
                    if(em) begin
                        case(state)
                            0: remaining = n_count;
                            2: remaining = e_count;
                            4: remaining = s_count;
                            6: remaining = w_count;
                        endcase
                        state = state+1;
                    end
                    else begin
                        // if only pedestrian button was pressed wait till green state ends
                        if(!count)
                            state = state+1;
                        else begin
                            count = count - 1;
                            n_count = n_count - 1;
                            e_count = e_count - 1;
                            s_count = s_count - 1;
                            w_count = w_count - 1;
                        end
                    end
                end
                // if state is all-red state
                else if (state==8) begin
                    // when all-red state ends, enter next state based on last_state value
                    if (!count) begin
                           em <= 0;
                           ped <= 0;
                           remaining <= 0;
                           if (last_state==6 | last_state==7)
                                state = 0;
                           else begin
                                if (last_state==0 | last_state==2 | last_state==4)
                                    state = last_state+2;
                                else
                                    state = last_state+1;
                           end
                    end
                    // count down all-red state
                    else begin
                        count = count - 1;
                        n_count = n_count - 1;
                        e_count = e_count - 1;
                        s_count = s_count - 1;
                        w_count = w_count - 1;
                    end
                end
                // if state was orange when emergency or pedestrian was pressed
                // continue the countdown till 0 and then enter state 8 (all-red state)
                else begin
                    if (!count) state = 8;
                    else begin
                        count = count - 1;
                        n_count = n_count - 1;
                        e_count = e_count - 1;
                        s_count = s_count - 1;
                        w_count = w_count - 1;
                    end
                end 
            end
            // countdown when neither emergency nor pedestrian button was pressed
            else begin
                count = count - 1;
                n_count = n_count - 1;
                e_count = e_count - 1;
                s_count = s_count - 1;
                w_count = w_count - 1;
            end
            
        end 
    end
    
    // updates count values for all roads depending on state
    always @(state) begin
        case(state)
                0: begin   
                         N_color <= "Green"; 
                         n_count = TGN-1; 
                         w_count <= Tcycle-(TGW+TO) -1;
                         e_count <= e_count - 1;
                         s_count <= s_count - 1; 
                         count = n_count; 
                         W_color <= "Red";
                   end
                1: begin N_color = "Orange"; 
                         n_count = TO-1;
                         e_count <= e_count - 1;
                         s_count <= s_count - 1; 
                         w_count <= w_count - 1;
                         count = n_count; 
                   end
                2: begin E_color = "Green"; 
                         e_count = TGE-1; 
                         n_count = Tcycle-(TGN+TO)-1;
                         w_count <= w_count - 1;
                         s_count <= s_count - 1; 
                         count = e_count; 
                         N_color = "Red"; 
                   end
                3: begin E_color = "Orange"; 
                         e_count = TO-1;
                         n_count <= n_count - 1;
                         s_count <= s_count - 1;
                         w_count <= w_count - 1; 
                         count = e_count; 
                   end
                4: begin S_color = "Green"; 
                         s_count = TGS-1; 
                         e_count = Tcycle-(TGE+TO)-1;
                         w_count <= w_count - 1;
                         n_count <= n_count - 1; 
                         count = s_count; 
                         E_color = "Red"; 
                   end
                5: begin S_color = "Orange"; 
                         s_count = TO-1;
                         n_count <= n_count - 1;
                         e_count <= e_count - 1;
                         w_count <= w_count - 1; 
                         count = s_count; 
                   end
                6: begin W_color = "Green"; 
                         w_count = TGW-1; 
                         s_count = Tcycle-(TGS+TO)-1;
                         n_count <= n_count - 1;
                         e_count <= e_count - 1; 
                         count = w_count; 
                         S_color = "Red"; 
                   end
                7: begin W_color = "Orange"; 
                         w_count = TO-1;
                         n_count <= n_count - 1;
                         s_count <= s_count - 1;
                         e_count <= e_count - 1; 
                         count = w_count; 
                   end
                // all-red state
                8: begin
                        N_color <= "Red";
                        E_color <= "Red";
                        S_color <= "Red";
                        W_color <= "Red";
                        // All-red state has duration of 10
                        // value taken as 9 because counting done till 0 (10 counts)
                        count = 9;
                        // update all count values depending on the remaining value when emergency case
                        // interrupts a green state
                        if (last_state==0|last_state==1) begin
                            n_count <= 9;
                            e_count <= e_count-remaining+9;
                            s_count <= s_count-remaining+9;
                            w_count <= w_count-remaining+9;
                        end
                        else if (last_state==2|last_state==3) begin
                            e_count <= 9;
                            n_count <= n_count-remaining+9;
                            s_count <= s_count-remaining+9;
                            w_count <= w_count-remaining+9;
                        end
                        else if (last_state==4|last_state==5) begin
                            s_count <= 9;
                            n_count <= n_count-remaining+9;
                            e_count <= e_count-remaining+9;
                            w_count <= w_count-remaining+9;
                        end
                        else if (last_state==6|last_state==7) begin
                            w_count <= 9;
                            n_count <= n_count-remaining+9;
                            e_count <= e_count-remaining+9;
                            s_count <= s_count-remaining+9;
                        end
                   end
                // default starting value
                default: begin
                        state=0;
                        count=0;
                    end
        endcase
    end
endmodule
