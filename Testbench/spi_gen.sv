class  spi_gen;
	
//	spi_tx tx;
	spi_tx spsr_tx;
	spi_tx sper_tx;
	spi_tx data_tx;

	function new();
	endfunction
	
	task run();
		
		repeat(spi_common::count)begin
			
			wait(spi_common::iter);
			spi_common::iter=0;
			spsr_tx=new();
			sper_tx=new();
			data_tx=new();
	
			spcr(spsr_tx);
			
		//	wait(spi_common::ack_signal);
			sper(sper_tx);
		//	wait(spi_common::ack_signal);
		//	repeat(spi_common::count)begin
				data(data_tx);
		//	end
		
		end
	endtask

	task spcr(spi_tx tx);
		if(!tx.randomize() with{tx.adr_i==2'b00;tx.we_i==1'b1;})//tx.dat_i==8'hd2;})
				$error("randmization 1 failed");
			else begin
				$display("randomization 1 done");
				gen2bfm.put(tx);
				tx.print("GEN_spcr");
			end
	endtask
	
	task sper(spi_tx tx);
		if(!tx.randomize() with{tx.adr_i==2'b11;tx.we_i==1'b1;tx.dat_i==8'h00;})
				$error("randmization sper failed");
			else begin
				$display("randomization sper done");
				gen2bfm.put(tx);
 			  	tx.print("GEN_sper");
			end
	endtask

	task data(spi_tx tx);
		if(!tx.randomize() with{tx.adr_i==2'b10;tx.we_i==1'b1;})
				$error("randmization data failed");
			else begin
				$display("randomization data done");
				gen2bfm.put(tx);
				tx.print("GEN_data");
			end
	endtask
endclass

//here three tx is instantiated bcoz So at the end, tx only represents your FIFO transaction.If  i want to generate three separate Wishbone transactions,three objects are needed.
