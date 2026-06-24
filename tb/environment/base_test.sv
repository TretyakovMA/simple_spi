`ifndef BASE_TEST
`define BASE_TEST
virtual class base_test extends uvm_test;
	`uvm_component_utils(base_test);
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new
	
	env                  env_h;
	env_config           env_config_h;
    custom_report_server my_server; 

    virtual function void adjust_agent_configs();
		env_config_h.spi_agent_config_h.has_monitor      = 1;
		env_config_h.wishbone_agent_config_h.has_monitor = 1;

		//env_config_h.reset_agent_config_h.reset_sensitive     = 0;
		env_config_h.spi_agent_config_h.reset_sensitive      = 1;
		env_config_h.wishbone_agent_config_h.reset_sensitive = 1;

	endfunction: adjust_agent_configs

	// Функция для выбора конфигурации env (выбор необходимых агентов)
	virtual function void adjust_env_config;
		return; //По умолчанию все включено
	endfunction: adjust_env_config

    // Функция для дополнительных действий при построении теста
	virtual function void build_hooks();
		return;
	endfunction: build_hooks
	


	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		// Создание конфигурации среды, с ней создаются все agent_config
		env_config_h = env_config::type_id::create("env_config_h", this);
		
		// Получение интерфейсов от top
		if(!uvm_config_db #(virtual interface spi_interface)::get(
			this, "", "spi_vif", env_config_h.spi_agent_config_h.vif
		)) `uvm_fatal(get_type_name(), "Faild to get reset interface")

		if(!uvm_config_db #(virtual interface wishbone_interface)::get(
			this, "", "wb_vif", env_config_h.wishbone_agent_config_h.vif
		)) `uvm_fatal(get_type_name(), "Faild to get user interface")
			


		// Настройка agent_configs
		adjust_agent_configs();

		// Настройка env_config
		adjust_env_config();
		
		// Готовый env_config отправляется к env и создается env
		uvm_config_db #(env_config)::set(
			this, "env_h", "env_config", env_config_h
		);
		env_h     = env::type_id::create("env_h", this);

		// Мой report_server создается только если симуляция запустилась с нужным флагом
`ifdef USE_CUSTOM_REPORT_SERVER
		my_server = new();
		uvm_report_server::set_server(my_server);
`endif

		// Вызов дополнительных действий при построении теста
		build_hooks();

	endfunction: build_phase
	
	
	
	virtual function void start_of_simulation_phase(uvm_phase phase);
		super.start_of_simulation_phase(phase);

		// Установка максимального времени симуляции
		// (если симуляция дойдет до 1 миллисекунды, то она завершится)
		uvm_top.set_timeout(10**4);

		// На всякий случай выводится топология проекта
		uvm_top.print_topology();
	endfunction: start_of_simulation_phase
endclass
`endif