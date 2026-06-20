`ifndef SIMPLE_SPI_TB_TOP
`define SIMPLE_SPI_TB_TOP

module simple_spi_tb_top #(
    parameter int CLK_PERIOD = 10,
    parameter int TIME_RESET = 20
);
    logic clk;
    logic rst;

    import uvm_pkg::*;
    import tb_pkg::*;

    spi_interface      spi_if(clk, rst);
    wishbone_interface wb_if (clk, rst);

    

    simple_spi_top dut(
        .clk_i(clk),
        .rst_i(rst),

        .cyc_i(wb_if.cyc),
        .stb_i(wb_if.stb),
        .adr_i(wb_if.adr),
        .we_i(wb_if.we),
        .dat_i(wb_if.dat_m),
        .dat_o(wb_if.dat_s),
        .ack_o(wb_if.ack),
        .inta_o(wb_if.inta),

        .sck_o(spi_if.sck),
        .mosi_o(spi_if.mosi),
        .miso_i(spi_if.miso)
    );


    initial begin
        clk = 0;
        forever begin
            #(CLK_PERIOD / 2);
            clk = ~clk;
        end
    end
    
    initial begin
        rst = 0;
        #TIME_RESET;
        rst = 1;
    end

    initial begin
        $timeformat(-9, 0, " ns", 5);

		uvm_config_db #(virtual interface spi_interface)::set(null, "*", "spi_vif", spi_if);
		uvm_config_db #(virtual interface wishbone_interface)::set(null, "*", "wb_vif", wb_if);
        run_test();
    end

endmodule
`endif