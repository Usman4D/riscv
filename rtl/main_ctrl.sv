import pipeline_reg_types::*;

module main_ctrl (
    input [6:0] opcode,
    output ctrl_t ctrl
);

  always_comb begin
    ctrl.alu_src = 0;
    ctrl.reg_write = 0;
    ctrl.alu_op1 = 0;
    ctrl.alu_op0 = 0;
    ctrl.mem_read = 0;
    ctrl.mem_to_reg = 0;
    ctrl.mem_write = 0;
    ctrl.jump = 0;
    ctrl.branch = 0;

    if (opcode == cpu_defs::OP_REG) begin
      ctrl.alu_src = 0;
      ctrl.reg_write = 1;
      {ctrl.alu_op1, ctrl.alu_op0} = ctrl_defs::ALU_OP_R_TYPE;
    end else if (opcode == cpu_defs::OP_IMM) begin
      ctrl.alu_src = 1;
      ctrl.reg_write = 1;
      {ctrl.alu_op1, ctrl.alu_op0} = ctrl_defs::ALU_OP_I_TYPE;
    end else if (opcode == cpu_defs::OP_LD) begin
      ctrl.alu_src = 1;
      ctrl.reg_write = 1;
      ctrl.mem_read = 1;
      ctrl.mem_to_reg = 1;
      ctrl.mem_write = 0;
      {ctrl.alu_op1, ctrl.alu_op0} = ctrl_defs::ALU_OP_LOAD_STORE;
    end else if (opcode == cpu_defs::OP_ST) begin
      ctrl.alu_src = 1;
      ctrl.reg_write = 0;
      ctrl.mem_read = 0;
      ctrl.mem_to_reg = 0;
      ctrl.mem_write = 1;
      {ctrl.alu_op1, ctrl.alu_op0} = ctrl_defs::ALU_OP_LOAD_STORE;
    end else if (opcode == cpu_defs::OP_JALR || opcode == cpu_defs::OP_JAL) begin
      ctrl.jump = 1;
      ctrl.reg_write = 1;
      ctrl.alu_src = 1;
      {ctrl.alu_op1, ctrl.alu_op0} = ctrl_defs::ALU_OP_LOAD_STORE;
    end else if (opcode == cpu_defs::OP_LUI || opcode == cpu_defs::OP_AUIPC) begin
      ctrl.reg_write = 1;
    end else if (opcode == cpu_defs::OP_B) begin
      ctrl.branch = 1;
    end
  end
endmodule
