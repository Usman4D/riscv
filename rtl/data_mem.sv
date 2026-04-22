module data_mem #(
    parameter int ADDR_WIDTH = 12,  // 4 KB
    parameter int MEM_ADDR_WIDTH = 32,
    parameter int DATA_WIDTH = 32,
    parameter int MEM_DEPTH = 1 << (ADDR_WIDTH - 2)
) (
    input logic clk,
    input logic wr,
    input logic [MEM_ADDR_WIDTH-1:0] addr,
    input logic [DATA_WIDTH - 1:0] data_in,
    output logic [DATA_WIDTH-1:0] data_out
);

  // word-addressed memory
  reg [DATA_WIDTH-1:0] mem[MEM_DEPTH-1];

  // word index (ignore byte offset)
  wire [$clog2(MEM_DEPTH)-1:0] word_index;
  assign word_index = addr[ADDR_WIDTH-1:2];

  assign data_out   = mem[word_index];

  always_ff @(posedge clk) begin
    if (wr) mem[word_index] <= data_in;
  end

endmodule
