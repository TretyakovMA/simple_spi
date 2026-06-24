`ifndef SINGLE_SPI_READ_VSEQ
`define SINGLE_SPI_READ_VSEQ
class single_spi_read_vseq extends uvm_sequence#(uvm_sequence_item);
    `uvm_object_utils(single_spi_read_vseq)

    function new(string name = "single_spi_read_vseq");
		super.new(name);
	endfunction: new
    
    wishbone_sequencer wb_sequencer_h;
    spi_sequencer      spi_sequencer_h;

    spi_slave_response_seq spi_seq_h;
    reg_write_seq          reg_w_seq_h;
    reg_read_seq           reg_r_seq_h;

    task body();
        if (!uvm_config_db #(wishbone_sequencer)::get(null, "", "wishbone_sequencer", wb_sequencer_h))
            `uvm_fatal(get_type_name(), "Failed to get wishbone_sequencer from config_db");
        if (!uvm_config_db #(spi_sequencer)::get(null, "", "spi_sequencer", spi_sequencer_h))
            `uvm_fatal(get_type_name(), "Failed to get spi_sequencer from config_db");
        
        spi_seq_h = spi_slave_response_seq::type_id::create("spi_seq_h");
        reg_w_seq_h = reg_write_seq::type_id::create("reg_w_seq_h");
        reg_r_seq_h = reg_read_seq::type_id::create("reg_w_seq_h");

        reg_w_seq_h.start(wb_sequencer_h);
        spi_seq_h.start(spi_sequencer_h);
        //#10;
        reg_r_seq_h.start(wb_sequencer_h);

    endtask


endclass
`endif