module register_file #(
    parameter int DATA_WIDTH = 32,
    parameter int ADDR_WIDTH = 5,
    parameter int MEM_DEPTH  = 1 << ADDR_WIDTH
) (
    input clk,
    input [DATA_WIDTH-1:0] dataW,
    input [ADDR_WIDTH-1:0] rs1,
    rs2,
    rd,
    input regWEn,
    output [DATA_WIDTH-1:0] data1,
    data2
);
  reg [DATA_WIDTH-1:0] mem[MEM_DEPTH];

  assign data1 = (rs1 == 'd0) ? 'd0 : mem[rs1];
  assign data2 = (rs2 == 'd0) ? 'd0 : mem[rs2];

  always_ff @(negedge clk) begin
    mem[0] = 32'd0;
    if (regWEn && (rd != 'd0)) begin
      mem[rd] <= dataW;
    end
  end


endmodule
