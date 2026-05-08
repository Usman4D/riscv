package pipeline_reg_types;
  typedef struct packed {
    logic reg_write;
    logic alu_src;
    logic mem_read;
    logic mem_to_reg;
    logic mem_write;
    logic jump;
    logic branch;
    logic alu_op1;
    logic alu_op0;
  } ctrl_t;
  typedef struct packed {
    logic [31:0] pc;
    logic [31:0] instr;
    ctrl_t ctrl;
  } if_id_t;
  typedef struct packed {
    logic [31:0] pc;
    logic [31:0] instr;
    logic [31:0] imm_value;
    logic [31:0] rs1_data;
    logic [31:0] rs2_data;
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [4:0] rd;
    ctrl_t ctrl;
  } id_ex_t;
  typedef struct packed {
    logic [31:0] pc;
    logic [31:0] instr;
    logic [31:0] alu_out;
    logic [31:0] rs2_data;
    logic [31:0] pc_plus_offset;
    logic [31:0] imm_value;
    logic [31:0] pc_plus_4;
    logic [4:0] rs2;
    logic [4:0] rd;
    ctrl_t ctrl;
  } ex_mem_t;
  typedef struct packed {
    logic [31:0] pc;
    logic [31:0] imm_value;
    logic [31:0] instr;
    logic [31:0] pc_plus_4;
    logic [31:0] pc_plus_offset;
    logic [31:0] lsu_reg_out;
    logic [31:0] alu_out;
    logic [4:0] rd;
    ctrl_t ctrl;
  } mem_wb_t;
endpackage
