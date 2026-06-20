`ifndef WISHBONE_AGENT
`define WISHBONE_AGENT

typedef uvm_sequencer #(wishbone_transaction) wishbone_sequencer;

class wishbone_agent extends base_agent #(
	.INTERFACE_TYPE   (virtual wishbone_interface), 
	.TRANSACTION_TYPE (wishbone_transaction      ), 
	.DRIVER_TYPE      (wishbone_driver           ), 
	.MONITOR_TYPE     (wishbone_monitor          )
);

	`uvm_component_utils(wishbone_agent);
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function string set_sequencer_name();
        return "wishbone_sequencer";  
    endfunction: set_sequencer_name

endclass
`endif