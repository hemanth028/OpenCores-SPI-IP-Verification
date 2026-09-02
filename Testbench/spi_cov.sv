class spi_cov;

    spi_tx tx;

    covergroup cg_wishbone;

        cp_addr: coverpoint tx.adr_i {
            bins SPCR = {2'b00};
            bins SPSR = {2'b01};
            bins FIFO = {2'b10};
            bins SPER = {2'b11};
        }

        cp_we: coverpoint tx.we_i {
            bins WRITE = {1'b1};
            bins READ  = {1'b0};
        }
        cp_addr_x_cp_we: cross cp_addr, cp_we;
        cp_cpol: coverpoint tx.dat_i[3]
            iff (tx.adr_i == 2'b00 && tx.we_i == 1'b1) {
            bins CPOL_0 = {1'b0};
            bins CPOL_1 = {1'b1};
        }
        cp_cpha: coverpoint tx.dat_i[2]
            iff (tx.adr_i == 2'b00 && tx.we_i == 1'b1) {
            bins CPHA_0 = {1'b0};
            bins CPHA_1 = {1'b1};
        }
        cp_spr: coverpoint tx.dat_i[1:0]
            iff (tx.adr_i == 2'b00 && tx.we_i == 1'b1) {
            bins SPR_0 = {2'b00};
            bins SPR_1 = {2'b01};
            bins SPR_2 = {2'b10};
            bins SPR_3 = {2'b11};
        }
        cp_spre: coverpoint tx.dat_i[1:0]
            iff (tx.adr_i == 2'b11 && tx.we_i == 1'b1) {
            bins SPRE_0 = {2'b00};
            bins SPRE_1 = {2'b01};
            bins SPRE_2 = {2'b10};
            bins SPRE_3 = {2'b11};
        }
        cp_cpol_x_cp_cpha: cross cp_cpol, cp_cpha;
        cp_cpol_x_cp_cpha_x_cp_spr:
            cross cp_cpol, cp_cpha, cp_spr;

        cp_spr_x_cp_spre:
            cross cp_spr, cp_spre;

    endgroup

    function new();
        cg_wishbone = new();
    endfunction

    task run();

        repeat (spi_common::count*3)begin
			
			wait(spi_common::ack_signal);
            tx = new();
            mon_wish2cov.get(tx);
            cg_wishbone.sample();
      //      tx.print("COV_WISHBONE");
        end

    endtask

endclass
