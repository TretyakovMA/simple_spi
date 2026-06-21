`ifndef REGISTER_ADAPTER
`define REGISTER_ADAPTER

class register_adapter extends uvm_reg_adapter;
	`uvm_object_utils(register_adapter)
  
	function new(string name = "register_adapter");
		super.new(name);
		supports_byte_enable = 0;
		provides_responses   = 0;
	endfunction
	


	//Функция преобразования операций с регистрами в транзакции шины
	virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
		wishbone_transaction tr;
		tr      = wishbone_transaction::type_id::create("tr");

		tr.cyc = 1;
		tr.stb = 1;
		
		tr.adr  = rw.addr; //Заполняем адрес регистра
		tr.we   = (rw.kind == UVM_WRITE) ? 1 : 0; //Определяем режим доступа
		
		//Заполняем данные в зависимости от режима доступа
		if (rw.kind == UVM_WRITE) begin
			tr.dat_m  = rw.data;
		end
		else begin
			tr.dat_s = rw.data;
		end
		`uvm_info (get_type_name(), {"reg2bus: ", tr.convert2string()}, UVM_FULL) 
		return tr; //Результатом является заполенная транзакция
	endfunction
	
	

	//Функция преобразования транзакций шины в операции с регистрами
	virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
		wishbone_transaction tr;
		
		if (!$cast(tr, bus_item)) begin
			`uvm_fatal(get_type_name(), "Invalid transaction type")
		end
		
		rw.kind = (tr.we == 1) ? UVM_WRITE : UVM_READ; //Определяем режим доступа
		rw.addr = tr.adr; //Заполняем адрес регистра

		//Заполняем данные в зависимости от режима доступа
		if (tr.we == 1) begin
			rw.data = tr.dat_m;
		end 
		else begin
			rw.data = tr.dat_s;
		end
		`uvm_info (get_type_name(), {"Get transaction: ", tr.convert2string()}, UVM_FULL) 
		`uvm_info (get_type_name(), $sformatf("bus2reg : addr=0x%0h data=0x%0h kind=%s status=%s", rw.addr, rw.data, rw.kind.name(), rw.status.name()), UVM_FULL)
		rw.status = UVM_IS_OK;  
	endfunction
	
endclass
`endif