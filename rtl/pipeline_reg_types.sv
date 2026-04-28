package pipeline_reg_types;
  typedef struct packed {
    logic [31:0] pc;
    logic [31:0] instr;
  } if_id_t;

  typedef struct packed {logic [31:0] pc;} id_ex_t;
endpackage
