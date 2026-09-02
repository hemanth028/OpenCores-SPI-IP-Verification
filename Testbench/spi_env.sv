class spi_env;
	spi_agent agent;
	spi_sbd sbd;

	function new();
		agent=new();
		sbd=new();
	endfunction

	task run();
		agent.run();
		sbd.run();
		$display("inside env");
	endtask
endclass
