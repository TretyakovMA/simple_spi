`ifndef SPI_DRIVER
`define SPI_DRIVER
class spi_driver extends base_driver #(
	.INTERFACE_TYPE   (virtual spi_interface), 
	.TRANSACTION_TYPE (spi_transaction      )
);
	`uvm_component_utils(spi_driver)

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
        vif.miso <= 0;
    endtask: _reset_

    task _drive_transaction_(spi_transaction tr);
        foreach(tr.rx_data[i]) begin
            vif.miso <= tr.rx_data[i];
            @(posedge vif.sck);
        end
        _reset_();
    endtask: _drive_transaction_
endclass
`endif