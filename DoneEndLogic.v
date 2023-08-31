`timescale 1ns / 1ps

module DoneLogic(input [6:0] val, output wire isDone);

assign isDone = (val == 100); // TODO : Change to 100

endmodule

// dir = 0 means up, dir = 1 means down
module EndLogic(input [15:0] watch, input dir, output reg isEnd);

always@(*)
    if(dir)
        isEnd = (watch == 16'h0000);
    else
        isEnd = (watch == 16'h9999);
endmodule

