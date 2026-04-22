module alu #(
    parameter integer ALU_WIDTH = 32
) (
    input [3:0] op,
    input [ALU_WIDTH-1:0] op1,
    input [ALU_WIDTH-1:0] op2,
    output logic [ALU_WIDTH-1:0] out
);

  always_comb begin
    unique case (op)
      4'b0001: out = op1 | op2;
      4'b0000: out = op1 & op2;
      4'b0010: out = op1 + op2;
      4'b0110: out = op1 - op2;
      4'b1001: out = op1 ^ op2;
      4'b1000: out = op1 << op2[4:0];
      4'b1010: out = op1 >> op2[4:0];
      4'b1110:
      out = ($signed(op1) < $signed(op2)) ? {{(ALU_WIDTH - 1) {1'b0}}, 1'b1} : {ALU_WIDTH{1'b0}};
      default: out = {ALU_WIDTH{1'b0}};
    endcase
  end

endmodule
;
