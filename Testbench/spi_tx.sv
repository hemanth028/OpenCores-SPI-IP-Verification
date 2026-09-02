class spi_tx;
		
	rand bit [1:0] adr_i;
	rand bit [7:0] dat_i;
	rand bit       we_i;
//	rand int       idle_cycles; 
	
	bit [7:0] dat_o;
	bit [7:0] mosi_data;
	bit [7:0] miso_data;
	constraint addr_c{
		adr_i inside {2'b00, 2'b01, 2'b10, 2'b11};
	}
	constraint data_c {
    if (adr_i == 2'b00)
      /*  dat_i inside {
            8'h50, 8'h51, 8'h52, 8'h53,
            8'h54, 8'h55, 8'h56, 8'h57,
            8'h58, 8'h59, 8'h5A, 8'h5B,
            8'h5C, 8'h5D, 8'h5E, 8'h5F,
            8'hD0, 8'hD1, 8'hD2, 8'hD3
        };*/
   //   dat_i inside {
   	//	     8'hD0,8'hD1,8'hD2,8'hD3};
    	dat_i inside {
    8'h50, 8'h51, 8'h52, 8'h53,
    8'h70, 8'h71, 8'h72, 8'h73,
    8'hD0, 8'hD1, 8'hD2, 8'hD3,
    8'hF0, 8'hF1, 8'hF2, 8'hF3
};

	else if (adr_i == 2'b11)
        dat_i inside {
            8'h00, 8'h01, 8'h02, 8'h03,
            8'h40, 8'h41, 8'h42, 8'h43,
            8'h80, 8'h81, 8'h82, 8'h83,
            8'hC0, 8'hC1, 8'hC2, 8'hC3
        };
	}

	function void print(string name="spi_tx");
    $display("======================================");
    $display("\tComponent name = %0s", name);
    $display("\tADR_I = %02b", adr_i);
    $display("\tDAT_I = %02h", dat_i);
    $display("\tWE_I  = %0d", we_i);
    $display("\tDAT_O = %02h", dat_o);
    $display("\tMOSI  = %02h", mosi_data);
    $display("\tMISO  = %02h", miso_data);
    $display("======================================");
endfunction
	
endclass
