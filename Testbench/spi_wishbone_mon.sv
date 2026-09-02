class spi_wishbone_mon;
    spi_tx tx;
    virtual spi_intf vif;

    function new();
        vif = top.pif;
    endfunction

    task run();
        repeat(spi_common::count*3) begin
            tx = new();
			wait(spi_common::ack_signal);
            wait(vif.mon_cb.ack_o);
		
            tx.adr_i = vif.mon_cb.adr_i;
            tx.we_i  = vif.mon_cb.we_i;
            tx.dat_i = vif.mon_cb.dat_i;
            tx.dat_o = vif.mon_cb.dat_o;

            tx.print("MON_WISHBONE");

           // mon2sbd.put(tx);
            mon_wish2cov.put(tx);
			spi_common::ack_signal=0;

          //  @(vif.mon_cb);
        end
    endtask
endclass
