`timescale 1ns/1ps

module uart_tx_tb;

reg clk;
reg rst;
reg tx_start;
reg [7:0] tx_data;

wire tx;
wire tx_busy;

uart_tx uut(
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx),
    .tx_busy(tx_busy)
);

always #5 clk = ~clk;

initial
begin

    $dumpfile("uart.vcd");
    $dumpvars(0, uart_tx_tb);

    $display("\nUART TRANSMITTER WITH EVEN PARITY");
    $display("----------------------------------");

    $monitor(
      "Time=%0t | rst=%b | busy=%b | tx=%b | data=%h",
       $time,rst,tx_busy,tx,tx_data
    );

    clk = 0;
    rst = 1;
    tx_start = 0;
    tx_data = 8'h00;

    //-----------------------------------
    // TEST 0 : RESET
    //-----------------------------------
    #20;
    rst = 0;

    //-----------------------------------
    // TEST 1 : 0x41
    //-----------------------------------
    $display("\nTEST1 : Send 0x41");

    #20;
    tx_data = 8'h41;
    tx_start = 1;

    #10;
    tx_start = 0;

    #200;

    //-----------------------------------
    // TEST 2 : 0x42
    //-----------------------------------
    $display("\nTEST2 : Send 0x42");

    tx_data = 8'h42;
    tx_start = 1;

    #10;
    tx_start = 0;

    #200;

    //-----------------------------------
    // TEST 3 : 0x55
    //-----------------------------------
    $display("\nTEST3 : Send 0x55");

    tx_data = 8'h55;
    tx_start = 1;

    #10;
    tx_start = 0;

    #200;

    //-----------------------------------
    // TEST 4 : 0xAA
    //-----------------------------------
    $display("\nTEST4 : Send 0xAA");

    tx_data = 8'hAA;
    tx_start = 1;

    #10;
    tx_start = 0;

    #200;

    //-----------------------------------
    // TEST 5 : 0xFF
    //-----------------------------------
    $display("\nTEST5 : Send 0xFF");

    tx_data = 8'hFF;
    tx_start = 1;

    #10;
    tx_start = 0;

    #200;

    $display("\nSimulation Complete");
    $finish;

end

endmodule