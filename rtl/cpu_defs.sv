package ctrl_defs;
  parameter ALU_OP_R_TYPE = 2'b10;
  parameter ALU_OP_I_TYPE = 2'b00;
  parameter ALU_OP_LOAD_STORE = 2'b01;
  parameter ALU_OP_BRANCH = 2'b11;
endpackage
package cpu_defs;
  parameter OP_REG = 7'b0110011;
  parameter OP_IMM = 7'b0010011;
  parameter OP_LD = 7'b0000011;
  parameter OP_ST = 7'b0100011;
  parameter OP_JALR = 7'b1100111;
  parameter OP_JAL = 7'b1101111;
  parameter OP_B = 7'b1100011;
endpackage
