module imm_gen (
    input [6:0] opcode,
    input [31:0] instr,
    output logic [31:0] imm
);

  always_comb begin
    case (opcode)
      cpu_defs::OP_ST: imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};
      cpu_defs::OP_JALR: imm = {{12{instr[20]}}, instr[20], instr[10:1], instr[11], instr[19:12]};
      default: imm = {{20{instr[31]}}, instr[31:20]};
    endcase
  end
endmodule
