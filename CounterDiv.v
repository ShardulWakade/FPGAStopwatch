`timescale 1ns / 1ps

module CounterDiv(input clk, input load, input valSel, input clear, output [6:0] outputVal);

reg [6:0] counterVal;
assign outputVal = counterVal;

initial counterVal = 0;

always@(posedge clk) begin
    if(load) begin
       if(clear) begin
            counterVal = 0;
       end 
       else if(valSel) begin
            counterVal = 1;
       end
       else begin
            counterVal = counterVal + 1;
       end
    end    
end

endmodule
