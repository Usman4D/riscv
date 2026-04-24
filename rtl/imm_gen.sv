module imm_gen (
    input [6:0] opcode,
    input [31:0] instr,
    output logic [31:0] imm
);

  logic [20:0] imm_field;
  always_comb begin
    case (opcode)
      cpu_defs::OP_ST: imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};
      cpu_defs::OP_B: imm = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
      cpu_defs::OP_JAL: begin
        imm = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
        //imm_field = instr[31:12] << 1;
        //imm = {
        //  {11{imm_field[20]}},
        //  imm_field[20],
        //  imm_field[10:1],
        //  imm_field[11],
        //  imm_field[19:12],
        //  imm_field[0]
        //};
      end
      default: imm = {{20{instr[31]}}, instr[31:20]};
    endcase
  end
endmodule
