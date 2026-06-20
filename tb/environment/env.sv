`ifndef ENV
`define ENV
class env extends uvm_env;
	`uvm_component_utils(env);
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction
	
	env_config             env_config_h;

	spi_agent              spi_agent_h;
	wishbone_agent         wishbone_agent_h;

    simple_spi_scoreboard  scoreboard_h;

    function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		// Получение env_config от текущего теста
		if(!uvm_config_db #(env_config)::get(this, "", "env_config", env_config_h))
			`uvm_fatal(get_type_name(), "Faild to get env_config")
        
        scoreboard_h = simple_spi_scoreboard::type_id::create("scoreboard_h", this);

        uvm_config_db #(spi_agent_config)::set(this, "spi_agent_h", "agent_config", env_config_h.spi_agent_config_h);
		spi_agent_h      = spi_agent::type_id::create("spi_agent_h", this);

        uvm_config_db #(wishbone_agent_config)::set(this, "wishbone_agent_h", "agent_config", env_config_h.wishbone_agent_config_h);
		wishbone_agent_h      = wishbone_agent::type_id::create("wishbone_agent_h", this);

    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);

		spi_agent_h.ap.connect(scoreboard_h.spi_imp);
        wishbone_agent_h.ap.connect(scoreboard_h.wb_imp);
    endfunction: connect_phase
endclass
`endif