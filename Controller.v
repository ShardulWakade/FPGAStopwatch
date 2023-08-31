`timescale 1ns / 1ps

module Controller(input clk, input isDone, input isEnd, input s,
                  output reg RST, output reg ldCounter, output reg counterVal, output reg ldWatch,
                  output wire [1:0] controllerState);
                  
reg [1:0] currentState;
reg [1:0] nextState;

assign controllerState = currentState;

initial currentState = 0;
initial nextState = 0;

// Output signals as a function of the current state.
always@(*) begin
    case(currentState)
        2'b00: begin 
               RST = 1; ldCounter = 1; counterVal = 0; ldWatch = 1;
               end
        2'b01: begin
               RST = 0; ldCounter = 0; counterVal = 0; ldWatch = 0;
               end
        2'b10: begin
               RST = 0; ldCounter = 1; counterVal = 0; ldWatch = 0;           
               end
        2'b11: begin
               RST = 0; ldCounter = 1; counterVal = 1; ldWatch = 1;
               end
    endcase
end

// Calculate nextState as a function of inputs
always@(*) begin
    if(isEnd) nextState = 2'b01;
    else begin
        case(currentState)
            2'b00 : nextState = 2'b01;
            2'b01 : if(s) nextState = 2'b10; else nextState = 2'b01;
            2'b10 : if(s) nextState = 2'b01; else if(isDone) nextState = 2'b11; else nextState = 2'b10;
            2'b11 : if(s) nextState = 2'b01; else nextState = 2'b10; 
        endcase;
    end
end

always@(posedge clk)
    currentState <= nextState;

endmodule
