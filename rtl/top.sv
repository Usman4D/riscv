import pipeline_reg_types::*;

module top (
    input clk,
    rst
);

  if_id_t if_id_vector_in;
  if_id_t if_id_vector_out;

  if_id_t id_ex_vector_in;
  if_id_t id_ex_vector_out;

  if_id_t ex_mem_vector_in;
  if_id_t ex_mem_vector_out;

  if_id_t mem_wb_vector_in;
  if_id_t mem_wb_vector_out;

  pipeline_reg if_id_reg (
      .clk(clk),
      .rst(rst),
      .data_in(if_id_vector_in),
      .data_out(if_id_vector_out)
  );
  pipeline_reg id_ex_reg (
      .clk(clk),
      .rst(rst),
      .data_in(id_ex_vector_in),
      .data_out(id_ex_vector_out)
  );
  pipeline_reg ex_mem_reg (
      .clk(clk),
      .rst(rst),
      .data_in(ex_mem_vector_in),
      .data_out(ex_mem_vector_out)
  );
  pipeline_reg mem_wb_reg (
      .clk(clk),
      .rst(rst),
      .data_in(mem_wb_vector_in),
      .data_out(mem_wb_vector_out)
  );

  logic [31:0] pc;
  logic [31:0] pc_next;

  logic reg_write;
  logic alu_src;
  logic alu_op1;
  logic alu_op0;
  logic mem_to_reg;
  logic mem_read;
  logic mem_write;
  logic jump;

  logic [31:0] instr;

  logic [31:0] data1;
  logic [31:0] data2;
  logic [31:0] imm_value;
  logic [31:0] alu_out;

  logic [31:0] lsu_reg_out;

  wire [6:0] opcode;
  wire [2:0] funct3;
  assign opcode = instr[6:0];
  assign funct3 = instr[14:12];

  program_counter pc_inst (
      .clk(clk),
      .rst(rst),
      .pc_next(pc_next),
      .pc(pc)
  );

  wire [31:0] pc_plus_4;
  assign pc_plus_4 = pc + 4;

  wire [31:0] pc_plus_offset;
  assign pc_plus_offset = pc + imm_value;

  `define beq 3'b000
  `define bne 3'b001
  `define blt 3'b100
  `define bge 3'b101
  `define bltu 3'b110
  `define bgeu 3'b111

  always_comb begin
    if (opcode == cpu_defs::OP_JALR) pc_next = alu_out;
    else if (opcode == cpu_defs::OP_JAL) pc_next = pc_plus_offset;
    else if (opcode == cpu_defs::OP_B) begin
      case (funct3)
        `beq:
        if (data1 == data2) pc_next = pc_plus_offset;
        else pc_next = pc_plus_4;
        `bne:
        if (data1 != data2) pc_next = pc_plus_offset;
        else pc_next = pc_plus_4;
        `blt:
        if ($signed(data1) < $signed(data2)) pc_next = pc_plus_offset;
        else pc_next = pc_plus_4;
        `bge:
        if ($signed(data1) > $signed(data2)) pc_next = pc_plus_offset;
        else pc_next = pc_plus_4;
        `bltu:
        if (data1 < data2) pc_next = pc_plus_offset;
        else pc_next = pc_plus_4;
        `bgeu:
        if (data1 > data2) pc_next = pc_plus_offset;
        else pc_next = pc_plus_4;
      endcase
    end else pc_next = pc_plus_4;

  end

  i_mem im (
      .addr (pc),
      .dataR(instr)
  );


  main_ctrl cu (
      .opcode(instr[6:0]),
      .alu_src(alu_src),
      .reg_write(reg_write),
      .alu_op1(alu_op1),
      .alu_op0(alu_op0),
      .mem_to_reg(mem_to_reg),
      .mem_write(mem_write),
      .mem_read(mem_read),
      .jump(jump)
  );

  logic [31:0] rf_write_data;

  // register file write data
  always_comb begin
    if (mem_to_reg) rf_write_data = lsu_reg_out;
    else if (jump) rf_write_data = pc_plus_4;
    else if (opcode == cpu_defs::OP_LUI) rf_write_data = imm_value;
    else if (opcode == cpu_defs::OP_AUIPC) rf_write_data = pc_plus_offset;
    else rf_write_data = alu_out;
  end

  register_file rf (
      .clk(clk),
      .dataW(rf_write_data),
      .rs1(instr[19:15]),
      .rs2(instr[24:20]),
      .rd(instr[11:7]),
      .regWEn(reg_write),
      .data1(data1),
      .data2(data2)
  );

  imm_gen imm (
      .opcode(instr[6:0]),
      .instr(instr),
      .imm(imm_value)
  );

  logic [3:0] op;
  alu_ctrl ac (
      {alu_op1, alu_op0},
      instr[31:25],
      instr[14:12],
      op
  );

  alu alu_inst (
      .op (op),
      .op1(data1),
      .op2((alu_src ? imm_value : data2)),
      .out(alu_out)
  );

  logic [31:0] dm_data_out;
  logic [31:0] lsu_data_out;
  data_mem dm (
      .clk(clk),
      .data_in(lsu_data_out),
      .wr(mem_write),
      .addr(alu_out),
      .data_out(dm_data_out)
  );

  lsu lsu_inst (
      .func({instr[5], instr[14:12]}),
      .mem_in(dm_data_out),
      .mem_out(lsu_data_out),
      .reg_in(data2),
      .reg_out(lsu_reg_out)
  );

endmodule
