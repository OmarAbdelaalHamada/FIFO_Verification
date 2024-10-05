module FIFO_top();
bit clk;
initial begin
    forever begin
        #5 clk = ~clk;
    end
end
FIFO_interface FIFO_if(clk);
FIFO DUT(FIFO_if);
FIFO_tb test(FIFO_if);
FIFO_monitor monitor(FIFO_if);
endmodule