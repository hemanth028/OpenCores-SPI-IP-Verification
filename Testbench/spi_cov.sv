class spi_cov;

    spi_tx tx;

    virtual spi_intf vif;
    bit [1:0] r_adr;
    bit       r_we;
    bit [7:0] r_dat;

    covergroup cg_regs;
        cp_adr: coverpoint r_adr {
            bins SPCR = {2'b00};
            bins SPSR = {2'b01};
            bins FIFO = {2'b10};
            bins SPER = {2'b11};
        }
        cp_we: coverpoint r_we {
            bins WRITE = {1'b1};
            bins READ  = {1'b0};
        }
        cp_adr_x_we: cross cp_adr, cp_we;
        cp_spie: coverpoint r_dat[7] iff (r_adr == 2'b00 && r_we) {
            bins SPIE_0 = {1'b0};
            bins SPIE_1 = {1'b1};
        }
        cp_icnt: coverpoint r_dat[7:6] iff (r_adr == 2'b11 && r_we) {
            bins ICNT[] = {[0:3]};
        }
        cp_spsr_clr: coverpoint r_dat[7:6] iff (r_adr == 2'b01 && r_we) {
            bins CLR_NONE = {2'b00};
            bins CLR_WCOL = {2'b01};
            bins CLR_SPIF = {2'b10};
            bins CLR_BOTH = {2'b11};
        }
        cp_spe: coverpoint r_dat[6] iff (r_adr == 2'b00 && r_we) {
            bins SPE_OFF = {1'b0};
            bins SPE_ON  = {1'b1};
        }
        cp_wffull: coverpoint r_dat[3] iff (r_adr == 2'b01 && !r_we);
        cp_wfempty: coverpoint r_dat[2] iff (r_adr == 2'b01 && !r_we);
        cp_rffull: coverpoint r_dat[1] iff (r_adr == 2'b01 && !r_we);
        cp_rfempty: coverpoint r_dat[0] iff (r_adr == 2'b01 && !r_we);
        cp_wcol: coverpoint r_dat[6] iff (r_adr == 2'b01 && !r_we);
        cp_spif: coverpoint r_dat[7] iff (r_adr == 2'b01 && !r_we);
    endgroup

    // spr / spre as the dut sees them when a byte is pushed into the write fifo
    bit [1:0] cur_spr, cur_spre;
    covergroup cg_rate;
        cp_spr_c:  coverpoint cur_spr;
        cp_spre_c: coverpoint cur_spre;
        cp_spr_x_cp_spre: cross cp_spr_c, cp_spre_c;
    endgroup

    function new();
        cg_wishbone = new();
        cg_regs = new();
        cg_rate = new();
        vif = top.pif;
    endfunction

    task run_regs();
        forever begin
            @(vif.mon_cb);
            if (vif.mon_cb.ack_o) begin
                r_adr = vif.mon_cb.adr_i;
                r_we  = vif.mon_cb.we_i;
                r_dat = (vif.mon_cb.we_i) ? vif.mon_cb.dat_i : vif.mon_cb.dat_o;
                cg_regs.sample();
                if (r_we && r_adr == 2'b00) cur_spr  = r_dat[1:0];
                if (r_we && r_adr == 2'b11) cur_spre = r_dat[1:0];
                if (r_we && r_adr == 2'b10) cg_rate.sample();
            end
        end
    endtask

    task run();

        fork
            run_regs();
        join_none

        repeat (spi_common::count*3)begin
			
			wait(spi_common::ack_signal);
            tx = new();
            mon_wish2cov.get(tx);
            cg_wishbone.sample();
      //      tx.print("COV_WISHBONE");
        end

    endtask

endclass
