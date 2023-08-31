`timescale 1ns / 1ps

/*
*   Takes in a 16 bit BCD value, with a clock and outputs the time-multiplex 7 seg display out.
*   7seg is assumed to be negative logic.
*/

module Mux4_1(
    input wire [3:0] input1,
    input wire [3:0] input2,
    input wire [3:0] input3,
    input wire [3:0] input4,
    input wire [1:0] sel,
    output reg [3:0] muxOut
);

    always @(*) begin
        case(sel)
        2'b00 : muxOut = input4;
        2'b01 : muxOut = input3;
        2'b10 : muxOut = input2;
        2'b11 : muxOut = input1;
        endcase
    end

endmodule

module notDecoder(
    input wire [1:0] sel,
    output reg [3:0] an
);

    always @(*) begin
        case(sel)
        2'b00 : an = 4'b1110;
        2'b01 : an = 4'b1101;
        2'b10 : an = 4'b1011;
        2'b11 : an = 4'b0111;
        endcase
    end

endmodule

module UpCounter(
    input clk,
    output [1:0] count
);

    reg [1:0] state;
    initial state = 0;
    
    assign count = state;
    
    always @(posedge clk) state = state + 1;
    
endmodule

module SevenSeg(
    input wire [3:0] hex,
    output reg [6:0] seg
    );
    always @ (*) begin
        case(hex)
            4'b0000 : seg = 7'b0000001;
            4'b0001 : seg = 7'b1001111;
            4'b0010 : seg = 7'b0010010;
            4'b0011 : seg = 7'b0000110;
            4'b0100 : seg = 7'b1001100;
            4'b0101 : seg = 7'b0100100;
            4'b0110 : seg = 7'b0100000;
            4'b0111 : seg = 7'b0001111;
            4'b1000 : seg = 7'b0000000;
            4'b1001 : seg = 7'b0001100;
            4'b1010 : seg = 7'b0001000;
            4'b1011 : seg = 7'b1100000;
            4'b1100 : seg = 7'b0110001;
            4'b1101 : seg = 7'b1000010;
            4'b1110 : seg = 7'b0110000;
            4'b1111 : seg = 7'b0111000;
        endcase 
    end
endmodule

module DisplayBCD(input clk, input [15:0] BCD, output [6:0] sevenSeg, output dp, output [3:0] an);

wire [1:0] counterOut;
UpCounter counter(.clk(clk), .count(counterOut));

notDecoder nd(.sel(counterOut), .an(an));

wire [3:0] MuxOut;
Mux4_1 inputMux(.input1(BCD[15:12]), .input2(BCD[11:8]), .input3(BCD[7:4]), .input4(BCD[3:0]),
                 .sel(counterOut), .muxOut(MuxOut) );

SevenSeg segm(.hex(MuxOut), .seg(sevenSeg));

assign dp = ~(counterOut == 2'b10);

endmodule