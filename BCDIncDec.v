`timescale 1ns / 1ps

module BCDIncDigit(input [3:0] digit, input inc, output reg [3:0] out, output reg incNext);
    always@(*) begin
        if(digit == 9 && inc) begin
            incNext = 1;
            out = 0;
        end
        else begin
            incNext = 0;
            out = digit + inc;
        end    
    end
endmodule

module BCDInc(input [15:0] BCD, output [15:0] inc);

wire [3:0] incNexts;

BCDIncDigit digit0(.digit(BCD[3:0]), .inc(1), .out(inc[3:0]), .incNext(incNexts[0]));
BCDIncDigit digit1(.digit(BCD[7:4]), .inc(incNexts[0]), .out(inc[7:4]), .incNext(incNexts[1]));
BCDIncDigit digit2(.digit(BCD[11:8]), .inc(incNexts[1]), .out(inc[11:8]), .incNext(incNexts[2]));
BCDIncDigit digit3(.digit(BCD[15:12]), .inc(incNexts[2]), .out(inc[15:12]), .incNext(incNexts[3]));

endmodule

module BCDDecDigit(input [3:0] digit, input dec, output reg [3:0] out, output reg decNext);
    always@(*) begin
        if(digit == 0 && dec) begin
            decNext = 1;
            out = 9;
        end
        else begin
            decNext = 0;
            out = digit - dec;
        end
    end
endmodule

module BCDDec(input [15:0] BCD, output [15:0] dec);

wire [3:0] decNexts;

BCDDecDigit digit0(.digit(BCD[3:0]), .dec(1),               .out(dec[3:0]), .decNext(decNexts[0]));
BCDDecDigit digit1(.digit(BCD[7:4]), .dec(decNexts[0]),     .out(dec[7:4]), .decNext(decNexts[1]));
BCDDecDigit digit2(.digit(BCD[11:8]), .dec(decNexts[1]),    .out(dec[11:8]), .decNext(decNexts[2]));
BCDDecDigit digit3(.digit(BCD[15:12]), .dec(decNexts[2]),   .out(dec[15:12]), .decNext(decNexts[3]));

endmodule

// incOrDec : 0 = inc, 1 = dec
module BCDIncDec(input [15:0] BCD, input incOrDec, output reg [15:0] nextBCD);

wire [15:0] inc, dec;

BCDInc increment(.BCD(BCD), .inc(inc));
BCDDec decrement(.BCD(BCD), .dec(dec));

always@(*)
    if(incOrDec == 0)
        nextBCD = inc;
    else
        nextBCD = dec;
endmodule
