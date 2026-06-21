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
        @(posedge vif.sck);
    endtask: _wait_for_sampling_event_

    task measure_divider(spi_transaction tr);
        int count = 0;
        @(posedge vif.sck);
        fork
            forever begin
                @(posedge vif.clk);
                count++;
            end
        join_none
        @(posedge vif.sck);
        tr.clk_count = count;
        disable fork;
    endtask: measure_divider

    task _collect_transaction_data_ (spi_transaction tr);
        fork
            measure_divider(tr);
        join_none

        for(int i = 0; i < 8; i++) begin
            tr.tx_data[7 - i] = vif.mosi;
            tr.rx_data[7 - i] = vif.miso;
            if (i != 7)
                @(posedge vif.sck);
        end
    endtask: _collect_transaction_data_

endclass
`endif