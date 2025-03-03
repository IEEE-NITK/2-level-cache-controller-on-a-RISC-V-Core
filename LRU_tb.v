`timescale 1ns / 1ps

module LRU_tb();
    reg clk, clr;
    reg [31:0] data;
    
    // Instantiate the LRU module
    LRU uut (
        .data(data),
        .clr(clr),
        .clk(clk)
    );

    // Clock Generation: Toggle every 5 time units
    always #5 clk = ~clk;

    initial begin
        $dumpfile("lru_tb.vcd");
        $dumpvars(0, LRU_tb);

        // Initialize signals
        clk = 0;
        clr = 1;
        data = 32'h00000000;

        // Reset LRU
        #10 clr = 0;
        
        // **Test Cases**
        data = 32'hDEADBEEF; #10;
        data = 32'hCAFEBABE; #10;
        data = 32'h12345678; #10;
        data = 32'h87654321; #10;
        data = 32'hAAAAAAAA; #10;

        #50 $finish;
    end

    initial begin
        $monitor("Time = %0t | Tree = %b", $time, uut.tree);
    end
endmodule
