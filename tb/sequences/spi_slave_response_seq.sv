`ifndef SPI_SLAVE_RESPONSE_SEQ
`define SPI_SLAVE_RESPONSE_SEQ
class spi_slave_response_seq extends uvm_sequence #(spi_transaction);
    `uvm_object_utils(spi_slave_response_seq)

    function new(string name = "spi_slave_response_seq");
		super.new(name);
	endfunction: new

    spi_transaction tr;

    task body();
        tr = spi_transaction::type_id::create("tr");
        start_item(tr);
        tr.rx_data = 8'b1010_0011;
        finish_item(tr);
    endtask
endclass
`endif