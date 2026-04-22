module top (
    input clk,
    rst
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

  logic [31:0] instr;

  logic [31:0] data1;
  logic [31:0] data2;
  logic [31:0] imm_value;
  logic [31:0] alu_out;

  logic [31:0] lsu_reg_out;

  program_counter pc_inst (
      clk,
      rst,
      pc_next,
      pc
  );

  i_mem #(12, 32) im (
      pc[11:0],
      instr
  );

  main_ctrl cu (
      .opcode(instr[6:0]),
      .alu_src(alu_src),
      .reg_write(reg_write),
      .alu_op1(alu_op1),
      .alu_op0(alu_op0),
      .mem_to_reg(mem_to_reg),
      .mem_write(mem_write),
      .mem_read(mem_read)
  );

  register_file rf (
      .clk(clk),
      .dataW(mem_to_reg ? lsu_reg_out : alu_out),
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

  always_comb begin
    pc_next = pc + 32'd4;
  end

endmodule
