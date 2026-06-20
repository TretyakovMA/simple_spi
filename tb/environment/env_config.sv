`ifndef ENV_CONFIG
`define ENV_CONFIG
class env_config extends uvm_object;
	`uvm_object_utils(env_config)

	//reset_agent_config     reset_agent_config_h;

	spi_agent_config      spi_agent_config_h;
	wishbone_agent_config wishbone_agent_config_h;


	bit has_spi_agent      = 1;
    bit has_wishbone_agent     = 1;
	
	bit has_register_env    = 1;
	
	function new(string name = "env_config");
		super.new(name);
		
		//reset_agent_config_h         = reset_agent_config::type_id::create("reset_agent_config_h");

		if(has_spi_agent)
			spi_agent_config_h      = spi_agent_config::type_id::create("spi_agent_config_h");
		if(has_wishbone_agent)
			wishbone_agent_config_h = wishbone_agent_config::type_id::create("wishbone_agent_config_h");
		
	endfunction: new
	
endclass
`endif