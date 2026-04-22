module i_mem #(
    parameter int ADDR_WIDTH = 12,
    parameter int MEM_ADDR_WIDTH = 32,
    parameter int DATA_WIDTH = 32,
    parameter int MEM_DEPTH = 1 << (ADDR_WIDTH - 2)  // 1024
) (
    input [MEM_ADDR_WIDTH-1:0] addr,
    output [DATA_WIDTH-1:0] dataR
);

  reg [DATA_WIDTH-1:0] mem[0:MEM_DEPTH-1];

  initial begin
    for (int i = 0; i < MEM_DEPTH; i++) mem[i] = 32'd0;

    $readmemh("program.hex", mem);

    $display("i_mem: First instruction loaded is %h", mem[0]);
  end

  wire [$clog2(MEM_DEPTH)-1:0] word_index;
  assign word_index = addr[ADDR_WIDTH-1:2];

  assign dataR = mem[word_index];

endmodule
