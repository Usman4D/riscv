interface commit_if (
    input clk
);
  logic valid;
  logic [4:0] rd;
  logic [31:0] pc;
  logic [31:0] data;
endinterface
