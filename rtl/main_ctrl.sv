module main_ctrl (
    input [6:0] opcode,
    output logic alu_src,
    reg_write,
    alu_op1,
    alu_op0,
    mem_read,
    mem_to_reg,
    mem_write
);


  always_comb begin
    alu_src = 0;
    reg_write = 0;
    alu_op1 = 0;
    alu_op0 = 0;
    mem_read = 0;
    mem_to_reg = 0;
    mem_write = 0;

    if (opcode == cpu_defs::OP_REG) begin
      alu_src = 0;
      reg_write = 1;
      {alu_op1, alu_op0} = ctrl_defs::ALU_OP_R_TYPE;
    end else if (opcode == cpu_defs::OP_IMM) begin
      alu_src = 1;
      reg_write = 1;
      {alu_op1, alu_op0} = ctrl_defs::ALU_OP_I_TYPE;
    end else if (opcode == cpu_defs::OP_LD) begin
      alu_src = 1;
      reg_write = 1;
      mem_read = 1;
      mem_to_reg = 1;
      mem_write = 0;
      {alu_op1, alu_op0} = ctrl_defs::ALU_OP_LOAD_STORE;
    end else if (opcode == cpu_defs::OP_ST) begin
      alu_src = 1;
      reg_write = 0;
      mem_read = 0;
      mem_to_reg = 0;
      mem_write = 1;
      {alu_op1, alu_op0} = ctrl_defs::ALU_OP_LOAD_STORE;
    end
  end
endmodule
