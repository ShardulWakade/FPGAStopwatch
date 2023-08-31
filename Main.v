`timescale 1ns / 1ps

/*
    MODULE INTERFACES

      module ClockDiv2500(input clk, output clk2500);
    
      module ClockDiv4(input clk, output clk4);
    
      module Controller(input clk, input isDone, input isEnd, input s,
                  output reg RST, output reg ldCounter, output reg counterVal, output reg ldWatch,
                  output wire [1:0] controllerState);
                  
      module CounterDiv(input clk, input load, input valSel, input clear, output [6:0] outputVal);
      
      module DoneLogic(input [6:0] val, output wire isDone);
        
      module DisplayBCD(input clk, input [15:0] BCD, output [6:0] sevenSeg, output dp, output [3:0] an);
    
      module EndLogic(input [15:0] watch, input dir, output reg isEnd);
        
      module BCDIncDec(input [15:0] BCD, input incOrDec, output reg [15:0] nextBCD);
      
      module ResetMux(input [1:0] mode, input [7:0] extVal, output reg [15:0] resetVal);
      
      module WatchMux(input [15:0] watchInRight, input [15:0] watchInLeft, input sel, output reg [15:0] watchIn);
      
      module OneShot(input clk, input wire in, output wire pulse);
*/

module Main(input clk, input [7:0] watchVal, input [1:0] mode, input startStop, input reset,
             output [6:0] seg, output dp, output [3:0] an);

wire clk10000;
wire clk2500;
wire isDone;
wire isEnd;
wire s;
wire r;
wire RST;
wire ldCounter;
wire counterVal;
wire ldWatch;
wire [6:0] counterOut;
wire [15:0] watchIn;
wire [15:0] watch;
wire [15:0] watchInRight;
wire [15:0] watchInLeft;
wire [1:0] controllerState;

ClockDiv2500 div2500(.clk(clk), .clk2500(clk2500));
ClockDiv4 div10000(.clk(clk2500), .clk4(clk10000));

OneShot rShot(.clk(clk10000), .in(reset), .pulse(r));
OneShot sShot(.clk(clk10000), .in(startStop), .pulse(s));

Controller controller(.clk(clk10000), .isDone(isDone), .isEnd(isEnd), .s(s), 
                .RST(RST), .ldCounter(ldCounter), .counterVal(counterVal), .ldWatch(ldWatch),
                 .controllerState(controllerState));
                
CounterDiv counter(.clk(clk10000), .load(r | ldCounter), .valSel(counterVal), .clear(r | RST),
             .outputVal(counterOut));

DoneLogic dl(.val(counterOut), .isDone(isDone));

LoadReg16 watchR(.clk(clk10000), .load(r | ldWatch), .watchIn(watchIn), .watchOut(watch));

DisplayBCD display(.clk(clk2500), .BCD(watch), .sevenSeg(seg), .dp(dp), .an(an));

EndLogic el(.watch(watch), .dir(mode[1]), .isEnd(isEnd));

BCDIncDec incdec(.BCD(watch), .incOrDec(mode[1]), .nextBCD(watchInRight));

ResetMux rm(.mode(mode), .extVal(watchVal), .resetVal(watchInLeft));

WatchMux wm(.watchInRight(watchInRight), .watchInLeft(watchInLeft), .sel(r | RST), .watchIn(watchIn));

endmodule
