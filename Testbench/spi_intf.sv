`timescale 1ns/1ps
interface spi_intf(input logic clk_i, input logic rst_i);

    // Wishbone signals
    logic       cyc_i;
    logic       stb_i;
    logic [1:0] adr_i;
    logic       we_i;
    logic [7:0] dat_i;
    logic [7:0] dat_o;
    logic       ack_o;
    logic       inta_o;
    // SpI signals
    logic       sck_o;
    logic       mosi_o;
    logic       miso_i;

   clocking bfm_cb @(posedge clk_i);

	    default input #1step output #1ns;	
	    // BFM → DUT
	    output cyc_i;
	    output stb_i;
	    output adr_i;
	    output we_i;
	    output dat_i;
	    output miso_i;
	
	    // DUT → BFM
	    input dat_o;
	    input ack_o;
	    input inta_o;
		input mosi_o;
		input sck_o;
	endclocking


	clocking mon_cb @(posedge clk_i);
	
	    default input #1step output #1ns;
	
	    input sck_o;
	    input mosi_o;
	    input miso_i;
	    input dat_o;
	    input ack_o;
	    input inta_o;
		input adr_i;
		input dat_i;
		input we_i;
	endclocking
endinterface
