`ifndef TB_PKG
`define TB_PKG
`include "interfaces/spi_interface.sv"
`include "interfaces/wishbone_interface.sv"
package tb_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "uvm_base_classes/base_classes_pkg.sv"

    import reg_models_pkg::*;

    typedef base_agent_config #(virtual spi_interface)      spi_agent_config;
	typedef base_agent_config #(virtual wishbone_interface) wishbone_agent_config;

    // Items
    `include "items/spi_transaction.sv"
    `include "items/wishbone_transaction.sv"

    // Agents
    `include "agents/spi_agent/spi_driver.sv"
    `include "agents/spi_agent/spi_monitor.sv"
    `include "agents/spi_agent/spi_agent.sv"

    `include "agents/wishbone_agent/wishbone_driver.sv"
    `include "agents/wishbone_agent/wishbone_monitor.sv"
    `include "agents/wishbone_agent/wishbone_agent.sv"
    `include "agents/wishbone_agent/register_adapter.sv"

    // Scoreboard
    `include "scoreboard/simple_spi_scoreboard.sv"

    // Environment
    `include "environment/sequence_base_test.sv"
    `include "environment/register_env.sv"
    `include "environment/env_config.sv"
    `include "environment/env.sv"
    `include "environment/base_test.sv"

    // Sequences
    `include "sequences/spi_slave_response_seq.sv"
    `include "sequences/reg_base_seq.sv"
    `include "sequences/reg_write_seq.sv"
    `include "sequences/reg_read_seq.sv"
    `include "sequences/single_spi_read_vseq.sv"

    // Tests
    `include "tests/simple_test.sv"
    
endpackage
`endif