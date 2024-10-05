import shared_pkg::*;
import FIFO_transaction_pkg::*;
import FIFO_scoreboard_pkg::*;
module FIFO_tb(FIFO_interface.TEST FIFO_if);
FIFO_transaction FIFO_transaction_tb;
initial begin
    test_finished  = 0;
    FIFO_transaction_tb = new();
    FIFO_if.rst_n = 0;
    @(negedge FIFO_if.clk);
    #0;
    repeat(10000) begin
        assert(FIFO_transaction_tb.randomize());
        FIFO_if.data_in = FIFO_transaction_tb.data_in;
        FIFO_if.rst_n = FIFO_transaction_tb.rst_n;
        FIFO_if.wr_en = FIFO_transaction_tb.wr_en;
        FIFO_if.rd_en = FIFO_transaction_tb.rd_en;
         @(negedge FIFO_if.clk);
        #0;
    end
    test_finished  = 1;
end
endmodule