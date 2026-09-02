module top;
	reg clk_i;
	reg rst_i;

	always #1 clk_i=~clk_i;

	spi_intf pif(clk_i,rst_i);
	simple_spi_top dut (
   		.clk_i  (clk_i),
   		.rst_i  (rst_i),
   		.cyc_i  (pif.cyc_i),
   		.stb_i  (pif.stb_i),
   		.adr_i  (pif.adr_i),
   		.we_i   (pif.we_i),
   		.dat_i  (pif.dat_i),
   		.dat_o  (pif.dat_o),
   		.ack_o  (pif.ack_o),
   		.inta_o (pif.inta_o),
   		.sck_o  (pif.sck_o),
   		.mosi_o (pif.mosi_o),
   		.miso_i (pif.miso_i)
	);	
	spi_env env;
	initial begin
		clk_i=0;	
	//	rst_i=0;
	//	#1;
//		rst_i=1;

		env=new();

		env.run();
	end
	initial begin
    rst_i = 1'b0;
    pif.cyc_i = 1'b0;
    pif.stb_i = 1'b0;
    pif.adr_i = 2'b00;
    pif.we_i = 1'b0;
    pif.dat_i = 8'h00;
    pif.miso_i = 1'b0;

    repeat(2) @(posedge clk_i);

    rst_i = 1'b1;
end
	initial begin
		#20;
      wait((spi_common::match + spi_common::mismatch)==spi_common::count);
    //  $display("count=%0d  match=%0d  mismatch=%0d  bfm_count=%0d gen_count=%0d",spi_common::count,spi_common::match,spi_common::mis_match,spi_common::bfm_count,shr_common::gen_count );

     	 $display("###########################################################################");
      if(spi_common::match==spi_common::count && spi_common::mismatch==1'b0)
       		 $display("\tTEST PASSED :\tmatch=%0d\tmismatch=%0d", spi_common::match,spi_common::mismatch);
      	else
        	$display("\tTEST FAILED :\tmatch=%0d\tmismatch=%0d", spi_common::match, spi_common::mismatch);
      	$display("##########################################################################");
      	#50 $finish;
	end
bind simple_spi_top spi_sva sva_inst (
    .clk_i  (clk_i),
    .rst_i  (rst_i),

    .cyc_i  (cyc_i),
    .stb_i  (stb_i),
    .we_i   (we_i),
    .ack_o  (ack_o),
    .dat_o  (dat_o),

    .sck_o  (sck_o),

    .spcr   (spcr),
    .state  (state),
    .ena    (ena)
);
endmodule
