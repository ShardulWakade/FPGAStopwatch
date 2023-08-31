`timescale 1ns / 1ps

module OneShot(input clk, input wire in, output wire pulse);

reg [1:0] cs;
initial cs = 0;

always@(posedge clk) begin
    case(cs)
        2'b00 : if(in) cs = 2'b01;
        2'b01 : if(in) cs = 2'b10; else cs = 2'b00;
        2'b10 : if(in == 0) cs = 2'b00;
    endcase
end

assign pulse = cs[0];

endmodule
