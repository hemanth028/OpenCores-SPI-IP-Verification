mailbox gen2bfm=new();
mailbox mon2cov=new();
mailbox mon2sbd=new();
mailbox mon_wish2cov=new();



class spi_common;
	
	function new();
	endfunction
	
	static int match;
	static int mismatch;
	static int count=50;
	static int ack_signal;
	static int iter=1;
	static int mon_start=0;


	
endclass
