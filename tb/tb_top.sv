module tb_top;

  logic clk;
  logic rst;
  int   instr_count;

  commit_if commit_if (clk);

  top dut (
      .clk(clk),
      .rst(rst)
  );

  always #5 clk = ~clk;

  always @(posedge clk) begin
    if (commit_if.valid) begin
      $display("PC=%h RD=%0d DATA=%0d", commit_if.pc, commit_if.rd, commit_if.data);
    end
  end

  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, tb_top);

    clk = 1'b0;
    rst = 1'b0;

    instr_count = 100;

    #10;
    rst = 1'b1;

    repeat (instr_count) begin
      @(posedge clk);
      assign commit_if.valid = dut.mem_wb_vector_out.ctrl.reg_write;
      assign commit_if.pc = dut.mem_wb_vector_out.pc;
      assign commit_if.rd = dut.mem_wb_vector_out.rd;
      assign commit_if.data = dut.rf_write_data;
    end
    #1;

    //$display("-----------------------------------------");
    //$display(dut.rf.mem[2]);
    //$display("-----------------------------------------");
    //assert (dut.rf.mem[1] == 32'd10)
    //else $fatal(1, "x1 failed");
    //assert (dut.rf.mem[2] == -32'sd10)
    //else $fatal(1, "x2 failed");
    //assert (dut.rf.mem[3] == 32'd3)
    //else $fatal(1, "x3 failed");
    //assert (dut.rf.mem[4] == 32'd13)
    //else $fatal(1, "x4 failed");
    //assert (dut.rf.mem[5] == 32'd7)
    //else $fatal(1, "x5 failed");
    //assert (dut.rf.mem[6] == -32'sd5)
    //else $fatal(1, "x6 failed");
    //assert (dut.rf.mem[7] == 32'd9)
    //else $fatal(1, "x7 failed");
    //assert (dut.rf.mem[8] == 32'd5)
    //else $fatal(1, "x8 failed");
    //assert (dut.rf.mem[9] == 32'd11)
    //else $fatal(1, "x9 failed");
    //assert (dut.rf.mem[10] == 32'd14)
    //else $fatal(1, "x10 failed");
    //assert (dut.rf.mem[11] == 32'd2)
    //else $fatal(1, "x11 failed");
    //assert (dut.rf.mem[12] == 32'd10)
    //else $fatal(1, "x12 failed");
    //assert (dut.rf.mem[13] == 32'd80)
    //else $fatal(1, "x13 failed");
    //assert (dut.rf.mem[14] == 32'd40)
    //else $fatal(1, "x14 failed");
    //assert (dut.rf.mem[15] == 32'd10)
    //else $fatal(1, "x15 failed");
    //assert (dut.rf.mem[16] == 32'd10)
    //else $fatal(1, "x16 failed");
    //assert (dut.rf.mem[19] == 32'd1)
    //else $fatal(1, "x19 failed");
    //assert (dut.rf.mem[20] == 32'd0)
    //else $fatal(1, "x20 failed");
    //assert (dut.rf.mem[21] == 32'd907)
    //else $fatal(1, "x21 failed");
    //assert (dut.rf.mem[22] == 32'd907)
    //else $fatal(1, "x22 failed");
    //assert (dut.rf.mem[23] == 32'd139)
    //else $fatal(1, "x23 failed");
    //assert (dut.rf.mem[24] == 32'd907)
    //else $fatal(1, "x24 failed");

    //// step for jump test Instructions
    //instr_count = 8;
    //repeat (instr_count) begin
    //  @(posedge clk);
    //end

    //assert (dut.rf.mem[2] == 32'd11)
    //else $fatal(1, "x2 failed");
    //assert (dut.rf.mem[3] == 32'd22)
    //else $fatal(1, "x3 failed");
    //assert (dut.rf.mem[5] == 32'd24)
    //else $fatal(1, "x5 failed");

    //// step for branch/lui/auipc test instructions
    //instr_count = 42;
    //repeat (instr_count) begin
    //  @(posedge clk);
    //end

    //assert (dut.rf.mem[3] == 32'd1)
    //else $fatal(1, "x3 failed");
    //assert (dut.rf.mem[6] == 32'd6)
    //else $fatal(1, "x6 failed");
    //assert (dut.rf.mem[9] == 32'd9)
    //else $fatal(1, "x9 failed");
    //assert (dut.rf.mem[12] == 32'd12)
    //else $fatal(1, "x12 failed");
    //assert (dut.rf.mem[15] == 32'd15)
    //else $fatal(1, "x15 failed");
    //assert (dut.rf.mem[18] == 32'd18)
    //else $fatal(1, "x18 failed");
    //assert (dut.rf.mem[25] == 32'h12345000)
    //else $fatal(1, "x25 failed");
    //assert (dut.rf.mem[26] == 32'h0000112C)
    //else $fatal(1, "x26 failed");

    //assert (dut.rf.mem[0] == 32'd0)
    //else $fatal(1, "x0 must remain zero");

    //$display("R/I/J/branch tests passed. PC=%0d", dut.pc);

    $finish;
  end

  initial begin
    //$shm_open("waves.shm");
    //$shm_probe("AS");
  end

endmodule
