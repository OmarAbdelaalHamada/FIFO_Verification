import FIFO_transaction_pkg::*;
import FIFO_scoreboard_pkg::*;
import FIFO_coverage_pkg::*;
import shared_pkg::*;
module FIFO_monitor(FIFO_interface.MONITOR FIFO_if);
//class objects :
FIFO_transaction FIFO_transaction_monitor;
FIFO_scoreboard FIFO_scoreboard_monitor = new();
FIFO_coverage FIFO_coverage_monitor = new();
/////////////////////////////////////////
initial begin
    forever begin
        @(negedge FIFO_if.clk);
        FIFO_transaction_monitor = new();
        FIFO_transaction_monitor.clk = FIFO_if.clk;
        FIFO_transaction_monitor.rst_n = FIFO_if.rst_n;
        FIFO_transaction_monitor.wr_en = FIFO_if.wr_en;
        FIFO_transaction_monitor.rd_en = FIFO_if.rd_en;
        FIFO_transaction_monitor.data_in = FIFO_if.data_in;
        FIFO_transaction_monitor.data_out = FIFO_if.data_out;
        FIFO_transaction_monitor.wr_ack = FIFO_if.wr_ack;
        FIFO_transaction_monitor.overflow = FIFO_if.overflow;
        FIFO_transaction_monitor.full = FIFO_if.full;
        FIFO_transaction_monitor.empty = FIFO_if.empty;
        FIFO_transaction_monitor.almostfull = FIFO_if.almostfull;
        FIFO_transaction_monitor.almostempty = FIFO_if.almostempty;
        FIFO_transaction_monitor.underflow = FIFO_if.underflow;
        fork
            //process 1 :
            begin
                FIFO_coverage_monitor.sample_data(FIFO_transaction_monitor);
            end

            //process 2 :
            begin
                FIFO_scoreboard_monitor.check_data(FIFO_transaction_monitor);
            end
        join
        if(test_finished) begin
            $display("correct_counter = %0d , error_counter = %0d ",correct_counter,error_counter);
            $stop;
        end
    end
end
endmodule