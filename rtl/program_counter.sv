module program_counter #(
    parameter int PC_WIDTH = 32
) (
    input clk,
    input rst,
    input [PC_WIDTH-1:0] pc_next,
    output reg [PC_WIDTH-1:0] pc
);

  always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
      pc <= {PC_WIDTH{1'b0}};
    end else begin
      pc <= pc_next;
    end
  end

endmodule
