interface FIFO_interface(clk);
    //parameters : 
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    //clock :
    input bit clk;
    //ports :
    logic [FIFO_WIDTH-1:0] data_in;
    logic rst_n, wr_en, rd_en;
    logic [FIFO_WIDTH-1:0] data_out;
    logic wr_ack, overflow;
    logic full, empty, almostfull, almostempty, underflow;
    //modports :
    modport DUT (
    input clk,rst_n, wr_en, rd_en,data_in,
    output data_out,wr_ack, overflow,full, empty, almostfull, almostempty, underflow
    );
    modport TEST (
    input clk,data_out,wr_ack, overflow,full, empty, almostfull, almostempty, underflow,
    output rst_n, wr_en, rd_en,data_in
    );
    modport MONITOR (
    input clk,data_out,wr_ack, overflow,full, empty, almostfull, 
          almostempty, underflow,rst_n, wr_en, rd_en,data_in
    );
endinterface