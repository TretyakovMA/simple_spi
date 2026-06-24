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
    
    task _reset_();
        vif.miso <= 0;
    endtask: _reset_

    task edge_sck();
        case({cpol, cpha})
            2'b00: @(negedge vif.sck);
            2'b01: @(posedge vif.sck);
            2'b10: @(posedge vif.sck);
            2'b11: @(negedge vif.sck);
        endcase
        /*if(cpol)
            @(posedge vif.sck);
        else
            @(negedge vif.sck);*/
    endtask: edge_sck

    task wait_clock_phase();
        case({cpol, cpha})
            2'b01: @(posedge vif.sck);
            2'b11: @(negedge vif.sck);
            default: @(posedge vif.clk);
        endcase
        /*if(!cpha)
            return;
        
        if(cpol)
            @(negedge vif.sck);
        else
            @(posedge vif.sck);*/
    endtask: wait_clock_phase

    task _drive_transaction_(spi_transaction tr);
        //@(posedge vif.clk);
        cpol = reg_block_h.SPCR.CPOL.get_mirrored_value();
        cpha = reg_block_h.SPCR.CPHA.get_mirrored_value();
        wait_clock_phase();
        foreach(tr.rx_data[i]) begin
            vif.miso <= tr.rx_data[i];
            if(cpha && i == 0) begin
                if(cpol) @(posedge vif.sck);
                else     @(negedge vif.sck);
                @(posedge vif.clk);
            end
            else
                edge_sck();
            //if (i == 0)
                //wait_clock_phase();
            //edge_sck();
            //if (cpha)
                //if (i == 0 || i == 1)
                    //edge_sck();
                //else
                    //@(negedge vif.sck);
            //else
                //edge_sck();
        end
        _reset_();
    endtask: _drive_transaction_
endclass
`endif