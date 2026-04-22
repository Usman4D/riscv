`timescale 1ns/1ps

module tb_imm_gen;

logic [31:0] instr;
logic [31:0] imm_value;

imm_gen imm_gen_inst(instr, imm_value);

initial begin
instr = {12'd56, {20{1'b0}}};
#10 assert(imm_value == 32'd56);

instr = {-12'd56, {20{1'b0}}};
#10 assert(imm_value ==  -32'd56);

instr = {12'd17, {20{1'b0}}};
#10 assert(imm_value == 32'd17);
end
endmodule
