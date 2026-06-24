`ifndef WISHBONE_DRIVER
`define WISHBONE_DRIVER
class wishbone_driver extends base_driver #(
	.INTERFACE_TYPE   (virtual wishbone_interface), 
	.TRANSACTION_TYPE (wishbone_transaction      )
);
    `uvm_component_utils(wishbone_driver)

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

    task _wait_for_reset_deassert_();
		@(posedge vif.clk iff vif.rst == 1);
	endtask: _wait_for_reset_deassert_

	task _wait_for_reset_assert_();
		@(negedge vif.rst);
	endtask: _wait_for_reset_assert_
    
    task _reset_();
        vif.cyc   <= 0;
        vif.stb   <= 0;
        vif.adr   <= 0;
        vif.we    <= 0;
        vif.dat_m <= 0;
    endtask: _reset_
    
    task _drive_transaction_(wishbone_transaction tr);
        @(posedge vif.clk);
        vif.cyc   <= tr.cyc;
        vif.stb   <= tr.stb;
        vif.adr   <= tr.adr;
        vif.we    <= tr.we;
        vif.dat_m <= tr.dat_m;

        @(posedge vif.clk iff vif.ack);

        _reset_();
    endtask: _drive_transaction_

endclass
`endif