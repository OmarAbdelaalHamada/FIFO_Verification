package FIFO_scoreboard_pkg;
import FIFO_transaction_pkg::*;
import shared_pkg::*;
//FIFO_scoreboard class :
    class FIFO_scoreboard;
        logic [FIFO_WIDTH-1:0] data_out_ref;
        reg[15:0] fifo [$];
		logic [3:0] queue_size;
        function void check_data(FIFO_transaction check_data_element);
        reference_model(check_data_element);
            if(check_data_element.data_out === data_out_ref) begin
                correct_counter++;
            end
            else begin
                error_counter++;
                $display("error!!!!!!");
            end
        endfunction

        function void reference_model(FIFO_transaction reference_model_element);
            queue_size = fifo.size();
            if(!reference_model_element.rst_n) begin
                for(integer i = 0;i < queue_size; i++) begin
                    fifo.pop_front();
                end
                queue_size = fifo.size();
            end
            else begin
                queue_size = fifo.size();
                case ({reference_model_element.wr_en,reference_model_element.rd_en})
                    2'b00: begin
                        data_out_ref = data_out_ref;
                    end
			        2'b10:
			        begin 
			        	if(queue_size != 8)
			        		fifo.push_back(reference_model_element.data_in);
                            data_out_ref = data_out_ref;
			        end
			        2'b01:
			        begin 
			        	if(queue_size!= 0)
			        		data_out_ref = fifo.pop_front();
			        end
			        2'b11:
			        begin
			        if(queue_size == 0)
			        	begin
			        		fifo.push_back(reference_model_element.data_in);
                            data_out_ref <= data_out_ref;
			        	end
			        else if (queue_size == 8)
			        		data_out_ref = fifo.pop_front();
			        else
			        	begin
			        		data_out_ref = fifo.pop_front();
                            fifo.push_back(reference_model_element.data_in);
			        	end
			        end
			    endcase
            end
        endfunction
    endclass
endpackage