module tb_top;

  logic clk;
  logic rst;
  int   i;
  int   instr_count;

  top dut (
      .clk(clk),
      .rst(rst)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, tb_top.dut);

    clk = 1'b0;
    rst = 1'b1;

    instr_count = 25;

    //for (i = 0; i < 4096; i++) begin
    //  dut.im.mem[i] = 32'h00000000;
    //end

    // R & I Type Test Instructions
    //dut.im.mem[0] = 32'h00A00093;  // addi x1,  x0, 10
    //dut.im.mem[1] = 32'hFF600113;  // addi x2,  x0, -10
    //dut.im.mem[2] = 32'h00300193;  // addi x3,  x0, 3
    //dut.im.mem[3] = 32'h00308233;  // add  x4,  x1, x3
    //dut.im.mem[4] = 32'h403082B3;  // sub  x5,  x1, x3
    //dut.im.mem[5] = 32'h00510313;  // addi x6,  x2, 5
    //dut.im.mem[6] = 32'h0030C3B3;  // xor  x7,  x1, x3
    //dut.im.mem[7] = 32'h00F0C413;  // xori x8,  x1, 15
    //dut.im.mem[8] = 32'h0030E4B3;  // or   x9,  x1, x3
    //dut.im.mem[9] = 32'h0040E513;  // ori  x10, x1, 4
    //dut.im.mem[10] = 32'h0030F5B3;  // and  x11, x1, x3
    //dut.im.mem[11] = 32'h00E0F613;  // andi x12, x1, 14
    //dut.im.mem[12] = 32'h003096B3;  // sll  x13, x1, x3
    //dut.im.mem[13] = 32'h00209713;  // slli x14, x1, 2
    //dut.im.mem[14] = 32'h0036D7B3;  // srl  x15, x13, x3
    //dut.im.mem[15] = 32'h00275813;  // srli x16, x14, 2
    //dut.im.mem[16] = 32'h001129B3;  // slt  x19, x2, x1
    //dut.im.mem[17] = 32'hFFB0AA13;  // slti x20, x1, -5
    //dut.im.mem[18] = 32'h00A02023;  // sw x10, 0(x0)
    //dut.im.mem[19] = 32'h00002A83;  // lw x21, 0(x0)

    //$readmemh("program.hex", dut.im.mem);

    #1;
    rst = 1'b0;
    #9;
    rst = 1'b1;

    repeat (instr_count) begin
      @(posedge clk);
    end
    #1;

    assert (dut.rf.mem[1] == 32'd10)
    else $fatal(1, "x1 failed");
    assert (dut.rf.mem[2] == -32'sd10)
    else $fatal(1, "x2 failed");
    assert (dut.rf.mem[3] == 32'd3)
    else $fatal(1, "x3 failed");
    assert (dut.rf.mem[4] == 32'd13)
    else $fatal(1, "x4 failed");
    assert (dut.rf.mem[5] == 32'd7)
    else $fatal(1, "x5 failed");
    assert (dut.rf.mem[6] == -32'sd5)
    else $fatal(1, "x6 failed");
    assert (dut.rf.mem[7] == 32'd9)
    else $fatal(1, "x7 failed");
    assert (dut.rf.mem[8] == 32'd5)
    else $fatal(1, "x8 failed");
    assert (dut.rf.mem[9] == 32'd11)
    else $fatal(1, "x9 failed");
    assert (dut.rf.mem[10] == 32'd14)
    else $fatal(1, "x10 failed");
    assert (dut.rf.mem[11] == 32'd2)
    else $fatal(1, "x11 failed");
    assert (dut.rf.mem[12] == 32'd10)
    else $fatal(1, "x12 failed");
    assert (dut.rf.mem[13] == 32'd80)
    else $fatal(1, "x13 failed");
    assert (dut.rf.mem[14] == 32'd40)
    else $fatal(1, "x14 failed");
    assert (dut.rf.mem[15] == 32'd10)
    else $fatal(1, "x15 failed");
    assert (dut.rf.mem[16] == 32'd10)
    else $fatal(1, "x16 failed");
    assert (dut.rf.mem[19] == 32'd1)
    else $fatal(1, "x19 failed");
    assert (dut.rf.mem[20] == 32'd0)
    else $fatal(1, "x20 failed");
    assert (dut.rf.mem[21] == 32'd907)
    else $fatal(1, "x21 failed");
    assert (dut.rf.mem[22] == 32'd907)
    else $fatal(1, "x22 failed");
    assert (dut.rf.mem[23] == 32'd139)
    else $fatal(1, "x23 failed");
    assert (dut.rf.mem[24] == 32'd907)
    else $fatal(1, "x24 failed");

    assert (dut.rf.mem[0] == 32'd0)
    else $fatal(1, "x0 must remain zero");
    assert (dut.pc == (instr_count * 4))
    else $fatal(1, "pc final value is wrong");

    $display("R/I test passed. PC=%0d", dut.pc);

    $finish;
  end

endmodule
