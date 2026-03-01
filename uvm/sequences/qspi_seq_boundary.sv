class qspi_seq_boundary extends uvm_sequence #(qspi_item);

   `uvm_object_utils(qspi_seq_boundary)

   function new(string name="qspi_seq_boundary");
      super.new(name);
   endfunction


   task body();

      qspi_item req;

      // boundary address list
      bit [23:0] addr_list [5] = '{
         24'h000000,
         24'h000001,
         24'h7FFFFF,
         24'hFFFFFE,
         24'hFFFFFF
      };

      foreach(addr_list[i]) begin

         req = qspi_item::type_id::create("req");

         start_item(req);

         // fix values manually (no random)
         req.opcode     = 8'h03;
         req.address    = addr_list[i];
         req.write_data = 8'hAA;
         req.burst_len  = 1;

         finish_item(req);

         `uvm_info("BOUNDARY_SEQ",
            $sformatf("Boundary addr = %06h", addr_list[i]),
            UVM_LOW)

      end

   endtask

endclass

