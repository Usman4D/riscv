module pipeline_reg #(
    type T = logic [31:0]
) (
    input logic clk,
    input logic rst,
    input logic write_en,
    input T data_in,
    output T data_out
);

  T data_r;
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      data_r <= '0;
    end else if (write_en) begin
      data_r <= data_in;
    end
  end

  assign data_out = data_r;

endmodule

