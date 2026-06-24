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

    simple_spi_regs reg_block_h;
    bit cpol;
    bit cpha;

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(!uvm_config_db #(simple_spi_regs)::get(this, "", "reg_block", reg_block_h))
			`uvm_fatal(get_type_name(), "Failed to get reg_block")
    endfunction: connect_phase

    task _wait_for_reset_deassert_();
		@(posedge vif.clk iff vif.rst == 1);
	endtask: _wait_for_reset_deassert_

	task _wait_for_reset_assert_();
		@(negedge vif.rst);
	endtask: _wait_for_reset_assert_
    


    task edge_sck();
        case({cpol, cpha})
            2'b00: @(posedge vif.sck);
            2'b01: @(negedge vif.sck);
            2'b10: @(negedge vif.sck);
            2'b11: @(posedge vif.sck);
        endcase
        /*if(cpol)
            @(negedge vif.sck);
        else
            @(posedge vif.sck);*/
    endtask: edge_sck
    
    task wait_clock_phase();
        if(!cpha)
            return;
        
        if(cpol)
            @(posedge vif.sck);
        else
            @(negedge vif.sck);
    endtask: wait_clock_phase



    task _wait_for_sampling_event_(); 
        forever begin
            @(edge vif.sck);
            cpol = reg_block_h.SPCR.CPOL.get_mirrored_value();
            if (vif.sck == cpol)
                continue;
            
            cpha = reg_block_h.SPCR.CPHA.get_mirrored_value();
            wait_clock_phase();
            return;
        end
        
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
            `uvm_info(get_type_name(), $sformatf("mosi=%b, miso=%b", vif.mosi, vif.miso), UVM_LOW)
            if (i != 7)
                edge_sck();
        end
    endtask: _collect_transaction_data_

endclass
`endif