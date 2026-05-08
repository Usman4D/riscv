module lsu (
    input  logic [ 3:0] func,
    input  logic [31:0] mem_in,
    input  logic [31:0] reg_in,
    input  logic [ 1:0] byte_offset,
    output logic [31:0] reg_out,
    output logic [31:0] mem_out
);

  `define lb 4'b0000
  `define lh 4'b0001
  `define lw 4'b0010
  `define lbu 4'b0100
  `define lhu 4'b0101
  `define sb 4'b1000
  `define sh 4'b1001
  `define sw 4'b1010


  always_comb begin
    unique case (func)
      `lb:  reg_out = {{24{mem_in[7]}}, mem_in[7:0]};
      `lh:  reg_out = {{16{mem_in[7]}}, mem_in[15:0]};
      `lw:  reg_out = mem_in;
      `lbu: reg_out = {{24{1'b0}}, mem_in[7:0]};
      `lhu: reg_out = {{16{1'b0}}, mem_in[15:0]};
      `sb:  mem_out = {{24{reg_in[7]}}, reg_in[7:0]};
      `sh:  mem_out = {{16{reg_in[7]}}, reg_in[15:0]};
      `sw:  mem_out = reg_in;
      default: begin
        reg_out = 32'd0;
        mem_out = 32'd0;
      end
    endcase
  end
endmodule
