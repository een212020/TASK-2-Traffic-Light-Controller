`timescale 1ns / 1ps

module north_sensor(
    reset, next_road, data_in, avg
    );
    input reset;
    input [1:0] next_road;
    input [7:0] data_in;
    output reg [7:0] avg;
    
    parameter SIZE = 6;
    parameter LEN = 2**SIZE;
    //vehicles stores values over the last LEN cycles
    reg [7:0] vehicles [LEN-1:0];
    reg [7:0] i;
    reg [15:0] sum_comb;
  
    always @(next_road or reset) begin 
        //initalise sum values as 0     
        sum_comb = 'd0;
        
        //initialise values in vehicles
        if(!reset) begin
            for (i=0; i<LEN; i=i+1)
                vehicles[i] = 20;
        end
        
        else if(next_road == 0) begin 
          //shift old values in vehicles         
          for (i=LEN-1; i>0; i=i-1)
              vehicles[i] = vehicles[i-1];
          //push new data into index 0
          vehicles[0] = data_in;
        end
      
      //addition of all values inside vehicles
       for(i=0; i< LEN; i=i+1) begin
          sum_comb = sum_comb + vehicles[i];
       end
      
      //average using right shift
       avg = sum_comb >> SIZE;
 
    end    
endmodule
