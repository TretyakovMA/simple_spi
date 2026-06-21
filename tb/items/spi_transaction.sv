`ifndef SPI_TRANSACTION
`define SPI_TRANSACTION
class spi_transaction extends uvm_sequence_item;
    `uvm_object_utils(spi_transaction)

	function new(string name = "spi_transaction");
		super.new(name);
	endfunction: new

    rand bit [7:0] rx_data; //miso
    bit[7:0]       tx_data; //mosi

    int            clk_count; //для sck

    function string convert2string();
        return $sformatf("mosi = %0b; miso = %0b; clk_count = %0d", tx_data, rx_data, clk_count);
    endfunction: convert2string

    function void do_copy(uvm_object rhs);
		spi_transaction copied_tr;
		
		if(rhs == null)
			`uvm_fatal(get_type_name(), "Tried to copy from a null pointer")
		if(!$cast(copied_tr, rhs))
			`uvm_fatal(get_type_name(), "Tried to copy wrong type")
		
		super.do_copy(rhs);
        this.rx_data   = copied_tr.rx_data;
        this.tx_data   = copied_tr.tx_data;
        this.clk_count = copied_tr.clk_count;
    endfunction: do_copy

    function spi_transaction clone_me();
		spi_transaction clone;
		uvm_object      tmp;
		
		tmp = this.clone();
		$cast(clone, tmp);
		return clone;
	endfunction: clone_me

    function bit do_compare (uvm_object rhs, uvm_comparer comparer);
		spi_transaction compared_tr;
		bit same = 1;
		
		if(rhs == null)
			`uvm_fatal(get_type_name(), "Tried to do comparsion to a null pointer")
		if (!$cast(compared_tr, rhs)) 
            same = 0;
        
        if(this.tx_data != compared_tr.tx_data) begin
            same = 0;
            `uvm_error(get_type_name(), {"mosi signal error:\nGet transaction:\n", compared_tr.convert2string(), "\n\nExpected:\n", this.convert2string()})
        end

        if(this.clk_count != compared_tr.clk_count) begin
            same = 0;
            `uvm_error(get_type_name(), {"sck signal error:\nGet transaction:\n", compared_tr.convert2string(), "\n\nExpected:\n", this.convert2string()})
        end

        same = super.do_compare(rhs, comparer) && same;
        return same;
    endfunction: do_compare
endclass
`endif