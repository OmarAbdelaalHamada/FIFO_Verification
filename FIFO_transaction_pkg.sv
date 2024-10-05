package FIFO_transaction_pkg;
//parameters : 
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
//FIFO_transaction class :
    class FIFO_transaction;
        logic clk;
        rand logic [FIFO_WIDTH-1:0] data_in;
        rand logic rst_n, wr_en, rd_en;
        logic [FIFO_WIDTH-1:0] data_out;
        logic wr_ack, overflow;
        logic full, empty, almostfull, almostempty, underflow;
        integer RD_EN_ON_DIST;
        integer WR_EN_ON_DIST;
        //constructor :
        function new(integer RD_EN = 30, integer WR_EN = 70);
            this.RD_EN_ON_DIST = RD_EN;
            this.WR_EN_ON_DIST = WR_EN;
        endfunction
        //constraints :
        constraint reset_constraint{
            rst_n dist {
                0:/5,
                1:/95
            };
        }
        constraint write_en_constraint{
            wr_en dist {
                1:/WR_EN_ON_DIST,
                0:/(100 - WR_EN_ON_DIST)
            };
        }
        constraint read_en_constraint{
            rd_en dist {
                1:/RD_EN_ON_DIST,
                0:/(100 - RD_EN_ON_DIST)
            };
        }
    endclass
endpackage  