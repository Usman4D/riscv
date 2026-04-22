`timescale 1ns/1ps

module tb_alu_ctrl;
logic [1:0] alu_op;
logic [6:0] funct_7;
logic [2:0] funct_3;
logic [3:0] op;

alu_ctrl inst(.*);

initial begin
{alu_op, funct_7, funct_3} = 12'b100100000000;
#5 assert(op == 4'b0010);
{alu_op, funct_7, funct_3} = 12'b100000000000;
#5 assert(op == 4'b0110);
{alu_op, funct_7, funct_3} = 12'b100100000111;
#5 assert(op == 4'b0000);
{alu_op, funct_7, funct_3} = 12'b100100000110;
#5 assert(op == 4'b0001);
end

endmodule
