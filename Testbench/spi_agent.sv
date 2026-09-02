class spi_agent;
	spi_gen gen;
	spi_bfm bfm;
	spi_mon mon;
	spi_wishbone_mon mon_wish;
	spi_cov cov;

	function new();
		gen=new();
		bfm=new();
		mon=new();
		mon_wish=new();
		cov=new();
	endfunction

	task run();
		
		fork
			gen.run();
			bfm.run();
			mon.run();
			mon_wish.run();
			cov.run();
		join
		$display("Inside run task of agent");
	endtask
endclass
