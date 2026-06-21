`ifndef REGISTER_ENV
`define REGISTER_ENV
typedef uvm_reg_predictor #(wishbone_transaction) register_predictor; 

class register_env extends uvm_env;
	`uvm_component_utils(register_env);
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction
	
	
	
	register_adapter       adapter_h;
	register_predictor     predictor_h;
	simple_spi_regs        reg_block_h;
	
	
	
	function void build_phase(uvm_phase phase);

		super.build_phase(phase);
		predictor_h = register_predictor::type_id::create("predictor_h", this);
		adapter_h   = register_adapter::type_id::create("adapter_h", this);
		reg_block_h = simple_spi_regs::new("reg_block_h");
		reg_block_h.build();
        reg_block_h.lock_model();
		
		
		uvm_config_db #(simple_spi_regs)::set(null, "*", "reg_block", reg_block_h);
	endfunction
	
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		
		predictor_h.map     = reg_block_h.default_map;
		predictor_h.adapter = adapter_h;
		
	endfunction 
endclass
`endif