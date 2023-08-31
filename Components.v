`timescale 1ns / 1ps

module LoadReg16(input clk, input load, input [15:0] watchIn, output reg [15:0] watchOut);
    initial watchOut = 0;
    always@ (posedge clk)
        if(load) watchOut = watchIn;
endmodule

module ResetMux(input [1:0] mode, input [7:0] extVal, output reg [15:0] resetVal);
    always@(*) begin
        case(mode)
            2'b00 : resetVal = 16'h0000;
            2'b01 : begin
                resetVal[15:8] = extVal;
                resetVal[7:0] = 0;
            end
            2'b10 : resetVal = 16'h9999;
            2'b11 : begin
                resetVal[15:8] = extVal;
                resetVal[7:0] = 0;
            end
        endcase
    end
endmodule

module WatchMux(input [15:0] watchInRight, input [15:0] watchInLeft, input sel, output reg [15:0] watchIn);
    always@(*)
        if(sel)
            watchIn = watchInLeft;
        else
            watchIn = watchInRight;
endmodule