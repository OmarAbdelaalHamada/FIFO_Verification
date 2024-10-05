////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_interface.DUT FIFO_if);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;

localparam max_fifo_addr = $clog2(FIFO_DEPTH);

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge FIFO_if.clk or negedge FIFO_if.rst_n) begin
	if (!FIFO_if.rst_n) begin
		wr_ptr <= 0;
		FIFO_if.wr_ack <= 0;//I add this line to reset wr_ack
		FIFO_if.overflow <= 0;//I add this line to reset overflow
	end
	else if (FIFO_if.wr_en && count < FIFO_DEPTH) begin
		mem[wr_ptr] <= FIFO_if.data_in;
		FIFO_if.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		FIFO_if.wr_ack <= 0; 
		if (FIFO_if.full && FIFO_if.wr_en)
			FIFO_if.overflow <= 1;
		else
			FIFO_if.overflow <= 0;
	end
end

always @(posedge FIFO_if.clk or negedge FIFO_if.rst_n) begin
	if (!FIFO_if.rst_n) begin
		rd_ptr <= 0;
		FIFO_if.underflow <= 0;//I add this line to reset underflow
	end
	else if (FIFO_if.rd_en && count != 0) begin
		FIFO_if.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		FIFO_if.underflow <= 0;
	end
	else begin
		if(FIFO_if.empty && FIFO_if.rd_en) begin
			FIFO_if.underflow <= 1;
		end
		else begin
			FIFO_if.underflow <= 0;
		end
	end
end

always @(posedge FIFO_if.clk or negedge FIFO_if.rst_n) begin
	if (!FIFO_if.rst_n) begin
		count <= 0;
	end
	else begin//add case wr_en = 1 and rd_en = 1
		if	((({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b10) && !FIFO_if.full)) 
			count <= count + 1;
		else if ((({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b01) && !FIFO_if.empty))
			count <= count - 1;
			else if(({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b11)) begin 
				if(FIFO_if.full)
				count <= count - 1;
				else if(FIFO_if.empty)
				count <= count + 1;
			end
	end
end

assign FIFO_if.full = (count == FIFO_DEPTH)? 1 : 0;
assign FIFO_if.empty = (count == 0)? 1 : 0;
assign FIFO_if.almostfull = (count == FIFO_DEPTH-1)? 1 : 0; // convert (count == FIFO_DEPTH-2) to (count == FIFO_DEPTH-1)
assign FIFO_if.almostempty = (count == 1)? 1 : 0;

//Asswetions 
//check on reset :

always_comb begin
	if (!FIFO_if.rst_n) begin
		reset_assertion: assert final((!wr_ptr) && (!rd_ptr) && (!count));																																							//reset assertion
	end
end
//check on flages :
always_comb begin
	full_assertion: assert ((count == FIFO_DEPTH) === FIFO_if.full);
	almostfull_assertion: assert final(FIFO_if.almostfull == (count == FIFO_if.FIFO_DEPTH-1));
	empty_assertion: assert final(FIFO_if.empty == (count == 0));																																								//emprt assertion
	almostempty_assertion: assert final(FIFO_if.almostempty == (count == 1));
end
//check on overflow :
property overflow_test;
	@(posedge FIFO_if.clk) disable iff(~FIFO_if.rst_n)
	(FIFO_if.full && FIFO_if.wr_en)  |=> FIFO_if.overflow;
endproperty
assert property(overflow_test)
	else $error("Assertion overflow_test failed!");
cover property(overflow_test);
//check on underflow :
property underflow_test;
	@(posedge FIFO_if.clk) disable iff(~FIFO_if.rst_n)
	(FIFO_if.empty && FIFO_if.rd_en)  |=> FIFO_if.underflow;
endproperty
assert property(underflow_test)
	else $error("Assertion underflow_test failed!");
cover property(underflow_test);
//check on wr_ack :
property wr_ack_test ;
	@(posedge FIFO_if.clk) disable iff(~FIFO_if.rst_n)
	 (FIFO_if.wr_en && count < FIFO_DEPTH)  |=> FIFO_if.wr_ack;
endproperty
assert property(wr_ack_test)
	else $error("Assertion wr_ack_test failed!");
cover property(wr_ack_test);
endmodule