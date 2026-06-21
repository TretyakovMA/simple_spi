`ifndef WB_BASE_SEQ
`define WB_BASE_SEQ
class wb_base_seq extends uvm_reg_sequence;
    `uvm_object_utils(wb_base_seq)

    simple_spi_regs  reg_block_h;
	uvm_status_e     status;
    uvm_reg          registers[$];
    
    uvm_reg_data_t   value;
    uvm_reg_data_t   mirrored_value;

    function new(string name = "wb_base_seq");
        super.new(name);
    endfunction: new

    function void get_registers();
        if(!uvm_config_db #(simple_spi_regs)::get(null, "", "reg_block", reg_block_h))
			`uvm_fatal(get_type_name(), "Failed to get reg_block")
        
        reg_block_h.get_registers(registers);
    endfunction: get_registers

    task write_random_value(uvm_reg register);
        assert (register.randomize());
        value = register.get();
        write_reg(register, status, value);
    endtask: write_random_value

    task body();
        get_registers();
    endtask: body
endclass
`endif