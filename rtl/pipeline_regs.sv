module pipeline_reg #(
    type T = logic [31:0]
) (
    input logic clk,
    input logic rst,
    input logic write_en,
    input logic flush,
    input T data_in,
    output T data_out
);

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      data_out <= '0;
    end else begin
      if (flush) begin
        data_out <= '0;
      end else if (write_en) begin
        data_out <= data_in;
      end
    end
  end

endmodule

