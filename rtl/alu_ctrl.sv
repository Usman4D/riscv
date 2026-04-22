module alu_ctrl (
    input [1:0] alu_op,
    input [6:0] funct_7,
    input [2:0] funct_3,
    output reg [3:0] op
);

  always_comb begin
    op = 4'b0000;
    case (alu_op)
      ctrl_defs::ALU_OP_I_TYPE: begin
        unique case (funct_3)
          3'b000: op = 4'b0010;  // ADDI
          3'b010: op = 4'b1110;  // SLTI
          3'b100: op = 4'b1001;  // XORI
          3'b110: op = 4'b0001;  // ORI
          3'b111: op = 4'b0000;  // ANDI
          3'b001: op = 4'b1000;  // SLLI
          3'b101: op = 4'b1010;  // SRLI
        endcase

      end
      ctrl_defs::ALU_OP_R_TYPE: begin
        unique case ({
          funct_7, funct_3
        })
          10'b0000000_000: op = 4'b0010;  // ADD
          10'b0100000_000: op = 4'b0110;  // SUB
          10'b0000000_010: op = 4'b1110;  // SLT
          10'b0000000_100: op = 4'b1001;  // XOR
          10'b0000000_110: op = 4'b0001;  // OR
          10'b0000000_111: op = 4'b0000;  // AND
          10'b0000000_001: op = 4'b1000;  // SLL
          10'b0000000_101: op = 4'b1010;  // SRL
        endcase
      end
      ctrl_defs::ALU_OP_LOAD_STORE: begin
        op = 4'b0010;
      end
      default: op = 4'b0000;
    endcase
  end

endmodule
