class spi_bfm;

    spi_tx tx;
    virtual spi_intf vif;
	bit [7:0] slave_data;
    function new();
        vif = top.pif;
    endfunction
	
	   bit dat_o_flag=1'b0;
	   bit fifo_write_done;
	   task run();
		repeat(spi_common::count)begin
	    fifo_write_done = 1'b0;
		dat_o_flag=1'b0;
	    //fork
	      //  begin
	            repeat(3) begin
	                tx = new();
	                gen2bfm.get(tx);
	                drive_tx(tx);
	            end
	       // end
	
	  //      begin
				//wait(vif.sck_o);
			
	            spi_drive();
				read_rx_fifo();
			
				tx.print("BFM");
	    //    end
	  //  join	
	 end
endtask

    task drive_tx(spi_tx tx);
		spi_common::ack_signal=1;
        @(vif.bfm_cb);
		
        vif.bfm_cb.cyc_i <= 1'b1;
        vif.bfm_cb.stb_i <= 1'b1;
        vif.bfm_cb.adr_i <= tx.adr_i;
        vif.bfm_cb.we_i  <= tx.we_i;
        vif.bfm_cb.dat_i <= tx.dat_i;
		
        // Wait for DUT acknowledgement
        wait(vif.bfm_cb.ack_o);
		spi_common::ack_signal=vif.bfm_cb.ack_o;
		tx.print("BFM");
		if ((tx.adr_i == 2'b10) && (tx.we_i == 1'b1))
       		 fifo_write_done = 1'b1;

 	        // End of Wishbone transaction
      //  @(vif.bfm_cb);
		
        vif.bfm_cb.cyc_i <= 1'b0;
        vif.bfm_cb.stb_i <= 1'b0;
      //  vif.bfm_cb.adr_i <= 2'b00;
        vif.bfm_cb.we_i  <= 1'b0;
    //    vif.bfm_cb.dat_i <= 8'h00;
	
        $display("BFM: adr=%b we=%b data=%h time=%0t fifo_done=%0d",tx.adr_i, tx.we_i, tx.dat_i, $time,fifo_write_done);

    endtask
	
	 task spi_drive();

        $display("SPI BFM: Waiting for DUT to start SPI transfer");

		wait(fifo_write_done ||vif.sck_o);
        $display("SPI BFM: SPI transfer started at time=%0t",$time);
//	  if ($root.top.dut.wfempty == 1'b1) begin
  //      $display("BFM: Checked internal DUT FIFO: It is empty!");
   	//  end
		$display("wfempty=%0d",$root.top.dut.wfempty);
		tx.mosi_data = 8'h00;
		slave_data =$urandom;
		vif.miso_i = slave_data[7];
		tx.miso_data=8'h00;
		fifo_write_done=0;
		$display("SPI CONFIG: CPOL=%0d CPHA=%0d",$root.top.dut.cpol,$root.top.dut.cpha);
        repeat(8) begin
			 // fork 
			 // 	begin 
			 $display("time=%0t",$time);

			spi_common::mon_start=1;
			if (vif.sck_o == 1'b1)
				     tx.mosi_data = {tx.mosi_data[6:0], vif.mosi_o};
			else begin
  				@(posedge vif.sck_o);
			  	  tx.mosi_data = {tx.mosi_data[6:0], vif.mosi_o};
				   $display("time=%0t",$time);
			end
			 //	 end
			//	 begin
       		 @(negedge vif.sck_o);
			// tx.miso_data={tx.miso_data[6:0],vif.miso_i};
			 //vif.miso_i =$urandom_range(0,1);
			 tx.miso_data={tx.miso_data[6:0],vif.miso_i};
		     slave_data = {slave_data[6:0], 1'b0};
    		 vif.miso_i = slave_data[7];
			 $display("SPI BFM: SCK=%b MOSI=%b MISO=%b time=%0t",vif.sck_o,vif.mosi_o,vif.miso_i,$time);

				//	 end
        //	join
		end
     //   vif.bfm_cb.miso_i <= 1'b0;
		dat_o_flag=1'b1;
	  spi_common::mon_start=0;

    endtask

	task read_rx_fifo();
	
	wait(dat_o_flag);
	 dat_o_flag=1'b0;
  	  
    vif.bfm_cb.cyc_i <= 1'b1;
    vif.bfm_cb.stb_i <= 1'b1;
    vif.bfm_cb.adr_i <= 2'b10;
    vif.bfm_cb.we_i  <= 1'b0;
    //vif.bfm_cb.dat_i <= 8'h00;
//	 @(vif.bfm_cb);

    wait (vif.ack_o);
    tx.dat_o = vif.dat_o;
	
    $display("BFM READ: DAT_O = %h time=%0t",tx.dat_o,$time);

    @(vif.bfm_cb);

   vif.bfm_cb.cyc_i <= 1'b0;
   vif.bfm_cb.stb_i <= 1'b0;
   vif.bfm_cb.we_i  <= 1'b0;
   vif.bfm_cb.dat_i <= 8'hxx;
   spi_common::iter=1;
endtask

endclass
