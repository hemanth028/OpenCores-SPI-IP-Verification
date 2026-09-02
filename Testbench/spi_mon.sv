class spi_mon;
	spi_tx tx;

	virtual spi_intf vif;

	function new();
		vif=top.pif;
	endfunction

	task run();
		repeat(spi_common::count) begin
	//	forever begin
			tx=new();
			tx.mosi_data=8'h00;
			tx.miso_data=8'h00;
			$display("inside the mon");
			wait((!$root.top.dut.wfempty) || spi_common::mon_start==1'b1);
			repeat(8) begin
			//	if (vif.sck_o == 1'b1)
				//     tx.mosi_data = {tx.mosi_data[6:0], vif.mon_cb.mosi_o};
			//	else begin
  				@(posedge vif.sck_o);
			  	tx.mosi_data = {tx.mosi_data[6:0], vif.mon_cb.mosi_o};
				$display("mon :time=%0t",$time);
			//	end

				@(negedge vif.sck_o);
			    tx.miso_data={tx.miso_data[6:0],vif.mon_cb.miso_i};
			end
				wait(vif.ack_o);
				tx.dat_o=vif.dat_o;
				mon2sbd.put(tx);
				mon2cov.put(tx);
				tx.print("MON");
		//	end
		end
	endtask
endclass
