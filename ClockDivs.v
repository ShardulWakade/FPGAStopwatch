`timescale 1ns / 1ps
module ClockDiv2500(input clk, output clk2500);

reg [11:0] counter;
reg clNext;

initial counter = 0;
initial clNext = 0;

assign clk2500 = clNext;

always@ (posedge clk) begin
    if(clNext) begin 
        counter = 0;
        clNext = 0;
    end
    else begin
        counter = counter + 1;
        if(counter == 2499)    // TODO : Change to 2499
            clNext = 1;
    end
end
endmodule

module ClockDiv4(input clk, output clk4);

reg [1:0] counter;

assign clk4 = counter[1];

initial counter = 0;
always@ (posedge clk)
    counter = counter + 1;
    
endmodule