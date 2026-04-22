`timescale 1ns / 1ps
module tb_alu;
localparam int ALUWIDTH = 32;

logic [3:0] op;
logic [ALUWIDTH-1:0] op1;
logic [ALUWIDTH-1:0] op2;
logic [ALUWIDTH-1:0] out;

alu dut(.*);

initial begin
 op = 'b0010;
 op1 = 'd10;
 op2 = 'd20;
#10 assert(out == 'd30);

 op = 'b0110;
 op1 = 'd10;
 op2 = 'd20;
#10 assert($signed(out) == -'d10);

 op = 'b0001;
 op1 = 'd10;
 op2 = 'd20;
#10 assert(out == 'd30);

 op = 'b0000;
 op1 = 'd10;
 op2 = 'd20;
#10 assert(out == 'd0);
end

endmodule
