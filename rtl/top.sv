import pipeline_reg_types::*;

module top (
    input clk,
    rst
);
  // Pipeline Registers
  if_id_t  if_id_vector_in;
  if_id_t  if_id_vector_out;

  id_ex_t  id_ex_vector_in;
  id_ex_t  id_ex_vector_out;

  ex_mem_t ex_mem_vector_in;
  ex_mem_t ex_mem_vector_out;

  mem_wb_t mem_wb_vector_in;
  mem_wb_t mem_wb_vector_out;

  pipeline_reg #(
      .T(if_id_t)
  ) if_id_reg (
      .clk(clk),
      .rst(rst),
      .data_in(if_id_vector_in),
      .data_out(if_id_vector_out)
  );
  pipeline_reg #(
      .T(id_ex_t)
  ) id_ex_reg (
      .clk(clk),
      .rst(rst),
      .data_in(id_ex_vector_in),
      .data_out(id_ex_vector_out)
  );
  pipeline_reg #(
      .T(ex_mem_t)
  ) ex_mem_reg (
      .clk(clk),
      .rst(rst),
      .data_in(ex_mem_vector_in),
      .data_out(ex_mem_vector_out)
  );
  pipeline_reg #(
      .T(mem_wb_t)
  ) mem_wb_reg (
      .clk(clk),
      .rst(rst),
      .data_in(mem_wb_vector_in),
      .data_out(mem_wb_vector_out)
  );

  logic [31:0] pc_next;
  logic [31:0] instr;
  logic [31:0] imm_value;
  wire  [ 6:0] opcode;
  wire  [ 2:0] funct3;

  assign opcode = instr[6:0];
  assign funct3 = instr[14:12];

  // IF stage begin--------------------------------------------------------

  logic [31:0] pc;

  program_counter pc_inst (
      .clk(clk),
      .rst(rst),
      .pc(pc),
      .pc_next((id_ex_vector_out.ctrl.jump || id_ex_vector_out.ctrl.branch) ? pc_next : pc + 4)
  );

  i_mem im (
      .addr (pc),
      .dataR(if_id_vector_in.instr)
  );

  assign if_id_vector_in.pc = pc;

  // ID stage start------------------------------------------------------

  logic [31:0] data1;
  logic [31:0] data2;
  ctrl_t ctrl;

  main_ctrl cu (
      .opcode(if_id_vector_out.instr[6:0]),
      .ctrl  (ctrl)
  );

  logic [31:0] rf_write_data;

  register_file rf (
      .clk(clk),
      .dataW(rf_write_data),
      .rs1(if_id_vector_out.instr[19:15]),
      .rs2(if_id_vector_out.instr[24:20]),
      .rd(mem_wb_vector_out.rd),
      .regWEn(mem_wb_vector_out.ctrl.reg_write),
      .data1(data1),
      .data2(data2)
  );

  imm_gen imm (
      .opcode(if_id_vector_out.instr[6:0]),
      .instr(if_id_vector_out.instr),
      .imm(id_ex_vector_in.imm_value)
  );

  //forward instruction to EX stage
  assign id_ex_vector_in.instr = if_id_vector_out.instr;
  assign id_ex_vector_in.pc = if_id_vector_out.pc;
  assign id_ex_vector_in.ctrl = ctrl;
  assign id_ex_vector_in.rs1 = if_id_vector_out.instr[19:15];
  assign id_ex_vector_in.rs2 = if_id_vector_out.instr[24:20];
  assign id_ex_vector_in.rd = if_id_vector_out.instr[11:7];
  assign id_ex_vector_in.rs1_data = data1;
  assign id_ex_vector_in.rs2_data = data2;

  // EX stage begin--------------------------------------------------------

  logic [ 3:0] op;
  logic [31:0] alu_out;

  alu_ctrl ac (
      {id_ex_vector_out.ctrl.alu_op1, id_ex_vector_out.ctrl.alu_op0},
      id_ex_vector_out.instr[31:25],
      id_ex_vector_out.instr[14:12],
      op
  );

  // Forwarding unit 1
  logic [31:0] op1;
  logic [31:0] op2;

  always_comb begin
    if (ex_mem_vector_out.rd == id_ex_vector_out.rs1 && ex_mem_vector_out.rd != 0)
      op1 = ex_mem_vector_out.alu_out;
    else if (mem_wb_vector_out.rd == id_ex_vector_out.rs1 && mem_wb_vector_out.rd != 0)
      op1 = mem_wb_vector_out.alu_out;
    else op1 = id_ex_vector_out.rs1_data;

    if (id_ex_vector_out.ctrl.alu_src) op2 = id_ex_vector_out.imm_value;
    else if (ex_mem_vector_out.rd == id_ex_vector_out.rs2) op2 = ex_mem_vector_out.alu_out;
    else if (mem_wb_vector_out.rd == id_ex_vector_out.rs2) op2 = mem_wb_vector_out.alu_out;
    else op2 = id_ex_vector_out.rs2_data;
  end

  alu alu_inst (
      .op (op),
      .op1(op1),
      .op2(op2),
      .out(alu_out)
  );

  wire [31:0] pc_plus_4;
  assign pc_plus_4 = id_ex_vector_out.pc + 4;

  wire [31:0] pc_plus_offset;
  assign pc_plus_offset = id_ex_vector_out.pc + id_ex_vector_out.imm_value;

  `define beq 3'b000
  `define bne 3'b001
  `define blt 3'b100
  `define bge 3'b101
  `define bltu 3'b110
  `define bgeu 3'b111

  always_comb begin
    if (id_ex_vector_out.instr[6:0] == cpu_defs::OP_JALR) pc_next = alu_out;
    else if (id_ex_vector_out.instr[6:0] == cpu_defs::OP_JAL) pc_next = pc_plus_offset;
    else if (id_ex_vector_out.ctrl.branch) begin
      case (funct3)
        `beq:
        if (id_ex_vector_out.rs1_data == id_ex_vector_out.rs2_data) pc_next = pc_plus_offset;
        else pc_next = pc_plus_4;
        `bne:
        if (id_ex_vector_out.rs1_data != id_ex_vector_out.rs2_data) pc_next = pc_plus_offset;
        else pc_next = pc_plus_4;
        `blt:
        if ($signed(id_ex_vector_out.rs1_data) < $signed(id_ex_vector_out.rs2_data))
          pc_next = pc_plus_offset;
        else pc_next = pc_plus_4;
        `bge:
        if ($signed(id_ex_vector_out.rs1_data) > $signed(id_ex_vector_out.rs2_data))
          pc_next = pc_plus_offset;
        else pc_next = pc_plus_4;
        `bltu:
        if (id_ex_vector_out.rs1_data < id_ex_vector_out.rs2_data) pc_next = pc_plus_offset;
        else pc_next = pc_plus_4;
        `bgeu:
        if (id_ex_vector_out.rs1_data > id_ex_vector_out.rs2_data) pc_next = pc_plus_offset;
        else pc_next = pc_plus_4;
      endcase
    end else pc_next = pc_plus_4;

  end

  assign ex_mem_vector_in.instr = id_ex_vector_out.instr;
  assign ex_mem_vector_in.ctrl = id_ex_vector_out.ctrl;
  assign ex_mem_vector_in.alu_out = alu_out;
  assign ex_mem_vector_in.rd = id_ex_vector_out.rd;
  assign ex_mem_vector_in.rs2_data = id_ex_vector_out.rs2_data;
  assign ex_mem_vector_in.rs2 = id_ex_vector_out.rs2;
  assign ex_mem_vector_in.imm_value = id_ex_vector_out.imm_value;
  assign ex_mem_vector_in.pc_plus_4 = pc_plus_4;
  assign ex_mem_vector_in.pc_plus_offset = pc_plus_offset;

  // MEM stage begin--------------------------------------------------------

  logic [31:0] dm_data_out;
  logic [31:0] lsu_data_out;
  logic [31:0] lsu_reg_out;

  // Forwarding unit 2
  wire forward_2a;

  assign forward_2a = ex_mem_vector_out.rs2 == mem_wb_vector_out.rd;

  data_mem dm (
      .clk(clk),
      .data_in(lsu_data_out),
      .wr(ex_mem_vector_out.ctrl.mem_write),
      .addr(ex_mem_vector_out.alu_out),
      .data_out(dm_data_out)
  );

  lsu lsu_inst (
      .func({ex_mem_vector_out.instr[5], ex_mem_vector_out.instr[14:12]}),
      .mem_in(dm_data_out),
      .mem_out(lsu_data_out),
      .reg_in(forward_2a ? mem_wb_vector_out.alu_out : ex_mem_vector_out.rs2_data),
      .reg_out(lsu_reg_out)
  );

  assign mem_wb_vector_in.instr = ex_mem_vector_out.instr;
  assign mem_wb_vector_in.ctrl = ex_mem_vector_out.ctrl;
  assign mem_wb_vector_in.lsu_reg_out = lsu_reg_out;
  assign mem_wb_vector_in.alu_out = ex_mem_vector_out.alu_out;
  assign mem_wb_vector_in.rd = ex_mem_vector_out.rd;
  assign mem_wb_vector_in.imm_value = ex_mem_vector_out.imm_value;
  assign mem_wb_vector_in.pc_plus_4 = ex_mem_vector_out.pc_plus_4;
  assign mem_wb_vector_in.pc_plus_offset = ex_mem_vector_out.pc_plus_offset;

  // WB stage start--------------------------------------------------------

  // register file write data
  assign opcode = mem_wb_vector_in.instr[6:0];
  always_comb begin
    if (mem_wb_vector_out.ctrl.mem_to_reg) rf_write_data = mem_wb_vector_out.lsu_reg_out;
    else if (mem_wb_vector_out.ctrl.jump) rf_write_data = mem_wb_vector_out.pc_plus_4;
    else if (mem_wb_vector_out.instr[6:0] == cpu_defs::OP_LUI)
      rf_write_data = mem_wb_vector_out.imm_value;
    else if (mem_wb_vector_out.instr[6:0] == cpu_defs::OP_AUIPC)
      rf_write_data = mem_wb_vector_out.pc_plus_offset;
    else rf_write_data = mem_wb_vector_out.alu_out;
  end

endmodule
