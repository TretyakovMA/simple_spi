`ifndef REG_WRITE_SEQ
`define REG_WRITE_SEQ
class reg_write_seq extends reg_base_seq;
    `uvm_object_utils(reg_write_seq)
    function new(string name = "reg_write_seq");
        super.new(name);
    endfunction: new

    task body();
        super.body();
        
        configure_spi();

        
        write_reg(reg_block_h.SPCR, status, 8'b1101_0001);

        write_reg(reg_block_h.SPDR, status, 8'b1010_0011);
    endtask: body
endclass
`endif