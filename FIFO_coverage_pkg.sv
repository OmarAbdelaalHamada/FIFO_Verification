package FIFO_coverage_pkg;
import FIFO_transaction_pkg::*;
//FIFO_coverage class :
    class FIFO_coverage;
        FIFO_transaction F_cvg_txn = new();
        //covergroup : 
        covergroup write_read_covgrp;
            wr_en_lable       : coverpoint       F_cvg_txn.wr_en;
            rd_en_lable       : coverpoint       F_cvg_txn.rd_en;
            full_lable        : coverpoint        F_cvg_txn.full;
            almostfull_lable  : coverpoint  F_cvg_txn.almostfull;
            overflow_lable    : coverpoint    F_cvg_txn.overflow;
            wr_ack_lable      : coverpoint      F_cvg_txn.wr_ack;
            empty_lable       : coverpoint       F_cvg_txn.empty;
            almostempty_lable : coverpoint F_cvg_txn.almostempty;
            underflow_lable   : coverpoint   F_cvg_txn.underflow;
            write_enable_full_bin        : cross wr_en_lable,full_lable;
            write_enable_almostfull_bin  : cross wr_en_lable,almostfull_lable;
            write_enable_overflow_bin    : cross wr_en_lable,overflow_lable
            {
                ignore_bins write_0_overflow_1 = (binsof(wr_en_lable) intersect {0} && binsof(overflow_lable) intersect {1});
            }
            write_enable_wr_ack_bin      : cross wr_en_lable,wr_ack_lable 
            {
                ignore_bins write_0_wr_ack_1 = (binsof(wr_en_lable) intersect {0} && binsof(wr_ack_lable) intersect {1});
            }
            read_enable_empty_bin        : cross rd_en_lable,empty_lable;
            read_enable_almostempty_bin  : cross rd_en_lable,almostempty_lable;
            read_enable_underflow_bin    : cross rd_en_lable,underflow_lable
            {
                ignore_bins read_0_underflow_1 = (binsof(rd_en_lable) intersect {0} && binsof(underflow_lable) intersect {1});
            }
        endgroup
        function new();
            write_read_covgrp = new();
        endfunction
        function void sample_data(FIFO_transaction F_txn);
            F_cvg_txn =  F_txn;
            write_read_covgrp.sample();
        endfunction
    endclass
endpackage