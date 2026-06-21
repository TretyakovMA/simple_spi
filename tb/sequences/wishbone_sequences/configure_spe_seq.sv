`ifndef CONFIGURE_SPE_SEQ
`define CONFIGURE_SPE_SEQ
class configure_spe_seq extends wb_base_seq;
    `uvm_object_utils(configure_spe_seq)
    function new(string name = "configure_spe_seq");
        super.new(name);
    endfunction: new

    task body();
        super.body();

        write_reg(reg_block_h.SPCR, status, 8'b0101_0000);
    endtask: body
endclass
`endif