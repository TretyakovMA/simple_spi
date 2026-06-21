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

    `include "include/items_inc.svh"
    `include "include/spi_agent_inc.svh"
    `include "include/wishbone_agent_inc.svh"
    `include "include/scoreboard_inc.svh"
    `include "include/environment_inc.svh"
    `include "include/sequences_inc.svh"
    `include "include/tests_inc.svh"
    
endpackage
`endif