class spi_sbd;
	
	spi_tx tx;
	function new();
	endfunction

	task run();
		repeat(spi_common::count) begin
			mon2sbd.get(tx);
			if(tx.miso_data==tx.dat_o)	begin
				$display("miso_data=%02h dat_o=%02h",tx.miso_data,tx.dat_o);
				$display("miso matched");
				spi_common::match++;
			end
			else begin
				$display("mismatch");
				spi_common::mismatch++;
				$display("miso_data=%0d tx.dat_o=%0d",tx.miso_data,tx.dat_o);
			end
		end
	endtask
endclass
