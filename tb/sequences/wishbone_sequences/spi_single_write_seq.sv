`ifndef SPI_SINGLE_WRITE_SEQ
`define SPI_SINGLE_WRITE_SEQ
class spi_single_write_seq extends wb_base_seq;
    `uvm_object_utils(spi_single_write_seq)
    function new(string name = "spi_single_write_seq");
        super.new(name);
    endfunction: new

    task body();
        super.body();
        
        configure_spi();

        write_reg(reg_block_h.SPDR, status, 8'b1011_0011);
    endtask: body
endclass
`endif