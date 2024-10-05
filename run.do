vlib work
vlog -f file.txt +cover -covercells
vsim -voptargs=+acc work.FIFO_top -cover -classdebug 
add wave /FIFO_top/FIFO_if/*
add wave -position insertpoint  \
sim:/shared_pkg::test_finished
add wave -position insertpoint  \
sim:/FIFO_top/DUT/mem \
sim:/FIFO_top/DUT/wr_ptr \
sim:/FIFO_top/DUT/rd_ptr \
sim:/FIFO_top/DUT/count
add wave -position insertpoint  \
sim:/shared_pkg::correct_counter \
sim:/shared_pkg::error_counter
add wave -position insertpoint  \
sim:/FIFO_top/monitor/FIFO_scoreboard_monitor.data_out_ref
coverage save FIFO_top.ucdb -onexit
run -all
quit -sim
vcover report FIFO_top.ucdb -details -all -output coverage_rpt.txt