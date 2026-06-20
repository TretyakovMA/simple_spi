`ifndef SPI_AGENT
`define SPI_AGENT

typedef uvm_sequencer #(spi_transaction) spi_sequencer;

class spi_agent extends base_agent #(
	.INTERFACE_TYPE   (virtual spi_interface), 
	.TRANSACTION_TYPE (spi_transaction      ), 
	.DRIVER_TYPE      (spi_driver           ), 
	.MONITOR_TYPE     (spi_monitor          )
);

	`uvm_component_utils(spi_agent);
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function string set_sequencer_name();
        return "spi_sequencer";  
    endfunction: set_sequencer_name

endclass
`endif