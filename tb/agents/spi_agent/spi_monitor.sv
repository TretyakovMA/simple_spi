`ifndef SPI_MONITOR
`define SPI_MONITOR
class spi_monitor extends base_monitor #(
	.INTERFACE_TYPE   (virtual spi_interface), 
	.TRANSACTION_TYPE (spi_transaction      )
);
	`uvm_component_utils(spi_monitor)
    
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
        @(posedge vif.clk iff (vif.rst == 0 && vif.rst == 1));// никогда не выполнится
    endtask: _wait_for_sampling_event_

    task _collect_transaction_data_ (spi_transaction tr);
        for(int i = 0; i < 8; i++) begin
            tr.tx_data[i] = vif.mosi;
            tr.rx_data[i] = vif.miso;
            @(posedge vif.sck);
        end
    endtask: _collect_transaction_data_

endclass
`endif