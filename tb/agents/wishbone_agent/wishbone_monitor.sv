`ifndef WISHBONE_MONITOR
`define WISHBONE_MONITOR
class wishbone_monitor extends base_monitor #(
	.INTERFACE_TYPE   (virtual wishbone_interface), 
	.TRANSACTION_TYPE (wishbone_transaction      )
);
	`uvm_component_utils(wishbone_monitor)
    
    function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new



    task _wait_for_reset_deassert_();
		@(posedge vif.clk iff vif.rst == 1);
	endtask: _wait_for_reset_deassert_

	task _wait_for_reset_assert_();
		@(negedge vif.rst);
	endtask: _wait_for_reset_assert_

    task _wait_for_sampling_event_(); 
        @(posedge vif.clk iff (vif.cyc || vif.stb));
    endtask: _wait_for_sampling_event_

    task _collect_transaction_data_ (wishbone_transaction tr);
        tr.cyc = vif.cyc;
        tr.stb = vif.stb;
        tr.adr = vif.adr;
        tr.we  = vif.we;
        tr.dat_m = vif.dat_m;

        @(posedge vif.clk iff vif.ack);
        tr.dat_s = vif.dat_s;
        tr.ack   = vif.ack;
    endtask: _collect_transaction_data_
endclass
`endif