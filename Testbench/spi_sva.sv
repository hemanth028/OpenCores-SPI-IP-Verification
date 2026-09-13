module spi_sva (
    input wire       clk_i,
    input wire       rst_i,

    // Wishbone interface
    input wire       cyc_i,
    input wire       stb_i,
    input wire       we_i,
    input wire       ack_o,
    input wire [7:0] dat_o,

    // SPI interface
    input wire       sck_o,

    // Internal DUT signals
    input wire [7:0] spcr,
    input wire [1:0] state,
    input wire       ena
);

    default clocking def_clk @(posedge clk_i);
    endclocking


    
    //ACK MUST NOT REMAIN HIGH FOR TWO CONSECUTIVE CYCLES

    property ack_one_cycle;
        ack_o |=> !ack_o;
    endproperty

    assert property (ack_one_cycle)
        else begin $error(
            "SVA ERROR: ACK remained HIGH for more than one clock cycle"
        );
			$display("TIME=%0t",$time);
		end


    // WRITE ACCESS MUST EVENTUALLY GET ACK
		
    property write_en_ack;
        (cyc_i && stb_i && we_i) |-> ##[0:2] ack_o;
    endproperty

    assert property (write_en_ack)
        else begin $error(
            "SVA ERROR: Wishbone WRITE did not receive ACK"
        );	$display("TIME=%0t",$time);
	end


    // READ ACCESS MUST EVENTUALLY GET ACK
    
	property read_gets_ack;
        (cyc_i && stb_i && !we_i) |-> ##[0:2] ack_o;
    endproperty

    assert property (read_gets_ack)
        else begin $error(
            "SVA ERROR: Wishbone READ did not receive ACK"
        );	$display("TIME=%0t",$time);
	end


    // WHEN SPI IS DISABLED, SCK MUST BE LOW

	property sck_low_when_disabled;
        !spcr[6] |-> ((sck_o === 1'b0) or (sck_o===1'bx));
    endproperty

    assert property (sck_low_when_disabled)
        else begin
			$display("TIME=%0t",$time);
			$error("SVA ERROR: SCK is HIGH while SPI is disabled");
		end


    //WHEN SPI IS DISABLED, FSM MUST BE IDLE

    property fsm_idle_when_disabled;
        !spcr[6] |=>##[0:3] (state == 2'b00);
    endproperty

    assert property (fsm_idle_when_disabled)
        else begin $error(
            "SVA ERROR: SPI is disabled but FSM is not IDLE"
        );
				$display("TIME=%0t",$time);

		end

    
    //READ DATA MUST NOT BE X/Z WHEN ACK IS HIGH
		

    property read_data_known;
        (ack_o && !we_i) |-> !$isunknown(dat_o);
    endproperty

    assert property (read_data_known)
        else begin $error(
            "SVA ERROR: DAT_O contains X/Z during READ ACK"
        );
			$display("TIME=%0t",$time);


		end

    property sck_stable_state01;
        (state == 2'b01 && !ena) |=> $stable(sck_o);
    endproperty

    assert property (sck_stable_state01)
        else begin $error(
            "SVA ERROR: SCK changed in STATE 01 while ENA=0"
        );
				$display("TIME=%0t",$time);

		end

    
    //STATE 01 + ENA SHOULD TOGGLE SCK
    

    property sck_toggle_state01;
        (state == 2'b01 && ena) |=> (sck_o != $past(sck_o));
    endproperty

    assert property (sck_toggle_state01)
        else begin $error(
            "SVA ERROR: SCK did not toggle in STATE 01 when ENA=1"
        );
				$display("TIME=%0t",$time);
		end


    
    // STATE 11 + ENA SHOULD TOGGLE SCK

    property sck_toggle_state11;
        (state == 2'b11 && ena) |=> (sck_o != $past(sck_o));
    endproperty

    assert property (sck_toggle_state11)
        else begin $error(
            "SVA ERROR: SCK did not toggle in STATE 11 when ENA=1"
        );
			end


   


endmodule
