module master (
    input  logic        clk,
    input  logic        reset_n,
    input  logic        start,

    input  logic [7:0]  opcode,
    input  logic [23:0] address,
    input  logic [7:0]  write_data,
    input  logic [3:0]  burst_len,

    output logic        CS,
    output logic        SCLK,
    inout  wire [3:0]   IO
);

    typedef enum logic [2:0] {
        IDLE, OP, ADDR, DUMMY,  DATA, DONE, CS_WAIT
    } state_t;

    state_t state;

    logic [7:0]  sh8;
    logic [23:0] sh24;

    logic [7:0]  rd_shift;
    logic [5:0]  bit_cnt;
    logic [3:0]  byte_cnt;
    logic        byte_done;
    logic [3:0]  cs_cnt;

    logic phase;      // 0 = SCLK low, 1 = SCLK high
    logic [3:0] si;
    logic io_oe;

    assign SCLK = phase;

    // IO mapping (SPI single)
    assign IO = io_oe ? si : 4'bzzzz;   // SI
    wire   [3:0] so    = IO;               // SO
    //assign IO[3:2] = 2'bzz;
    //assign IO[3:1] = si[3:1];

    always_ff @(posedge phase or negedge reset_n) begin
        if (!reset_n) 
            byte_done <= 1'b0;
        else if (state == DATA && (opcode == 8'heb)?(bit_cnt >= 4):(bit_cnt == 7) && !io_oe)
            byte_done <= 1'b1;
        if (byte_done) begin
            byte_done <= 1'b0;
            if (state == DATA) $display("[%0t] READ BYTE = %02h", $time, rd_shift);
        end
    end

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state    <= IDLE;
            CS       <= 1'b1;
            phase    <= 1'b0;
            bit_cnt  <= 0;
            byte_cnt <= 0;
            cs_cnt   <= 0;
            io_oe    <= 1'b0;
            si[0]    <= 1'b0;
            rd_shift <= 8'h00;
        end else begin
            case (state)

            // ---------------- IDLE ----------------
            IDLE: begin
                CS <= 1'b1;
                phase <= 1'b0;
                bit_cnt <= 0;
                byte_cnt <= 0;
                if (start) begin
                    CS <= 1'b0;
                    sh8  <= opcode;
                    sh24 <= address;
                    io_oe <= 1'b1;   // drive SI for opcode
                    state <= OP;
                    $display("[%0t] SPI START opcode=%02h", $time, opcode);
                end
            end

            // ---------------- OPCODE ----------------
            OP: begin
                if (!phase) begin
                    si[0] <= sh8[7];
                    phase <= 1'b1;
                   
                end else begin
                    sh8 <= sh8 << 1;
                    bit_cnt <= bit_cnt + 1;
                    phase <= 1'b0;
                    if (bit_cnt == 7) begin
                        bit_cnt <= 0;
                        io_oe <= (opcode == 8'h9F) ? 1'b0 : 1'b1;
                        state <= (opcode == 8'h9F || opcode == 8'h01) ? DATA : (opcode == 8'h06)? DONE : ADDR;
                        CS <=  (opcode == 8'h06) ? 1'b1 : 1'b0;
                    end

                end
            end

            // ---------------- ADDRESS ----------------
            ADDR: begin
                if (!phase) begin
                        CS <= 1'b0;
                    if((opcode == 8'h38) || (opcode == 8'heb)) begin
                      si[3] <= sh24[23];
                      si[2] <= sh24[22];
                      si[1] <= sh24[21];
                      si[0] <= sh24[20];
                    end
                    else
                      si[0] <= sh24[23];
                    phase <= 1'b1;
                end else begin
                        CS <= 1'b0;
                    sh24 <= (opcode == 8'h38) || (opcode == 8'heb) ? ( sh24 << 4):( sh24 << 1);
                    bit_cnt <= (opcode == 8'h38) || (opcode == 8'heb) ?(bit_cnt + 4):(bit_cnt + 1);
                    phase <= 1'b0;
                    if ((opcode == 8'h38) || (opcode == 8'heb)?(bit_cnt == 20):(bit_cnt == 23)) begin
                        bit_cnt <= 0;
                        io_oe <= ((opcode == 8'h03)) ? 1'b0 : 1'b1;
                        state <= (opcode == 8'heb ) ? DUMMY:DATA;
                    end
                end
            end

            // ---------------- DUMMY ----------------
            DUMMY: begin
                if (!phase) begin
                  phase <= 1'b1;
                end else begin
                    bit_cnt <= bit_cnt + 1;
                    phase <= 1'b0;
                    si <= ((bit_cnt== 0)||(bit_cnt== 1))?$random:4'bzzzz;
                    if (bit_cnt== 5) begin
                        bit_cnt <= 0;
                        io_oe <= (opcode == 8'heb) ? 1'b0 : 1'b1;
                        state <= DATA;
                    end
                end
            end
            // ---------------- DATA ----------------
            DATA: begin
                // ---------- READ ----------
                if (!io_oe) begin
                    if (!phase) begin
                        phase <= 1'b1;
                    end else begin
                        rd_shift <= (opcode == 8'heb)?{rd_shift[3:0], so[3], so[2], so[1], so[0]}:{rd_shift[6:0], so[1]};
                        bit_cnt <= (opcode == 8'heb) ?(bit_cnt + 4):(bit_cnt + 1);
                        //bit_cnt <= bit_cnt + 1;
                        phase <= 1'b0;

                        if ((opcode == 8'heb)?(bit_cnt >= 4):(bit_cnt == 7)) begin
                            bit_cnt <= 0;
                            byte_cnt <= byte_cnt + 1;
                            if (byte_cnt == burst_len)
                                state <= DONE;
                        end
                    end
                end

                // ---------- WRITE ----------
                else begin
                    if (!phase) begin
                      if(opcode == 8'h38) begin
                        si[3] <= write_data[7-bit_cnt-0];
                        si[2] <= write_data[7-bit_cnt-1];
                        si[1] <= write_data[7-bit_cnt-2];
                        si[0] <= write_data[7-bit_cnt-3];
                      end
                      else
                        si[0] <= write_data[7-bit_cnt];
                      phase <= 1'b1;
                    end else begin
                        bit_cnt <= (opcode == 8'h38) ?(bit_cnt + 4):(bit_cnt + 1);
                        //bit_cnt <= bit_cnt + 1;
                        phase <= 1'b0;

                        if ((opcode == 8'h38)?(bit_cnt >= 4):(bit_cnt == 7)) begin
                            bit_cnt <= 0;
                            byte_cnt <= byte_cnt + 1;
                            if (byte_cnt == burst_len)
                                CS <=  (opcode == 8'h02 || opcode == 8'h01) ? 1'b1 : 1'b0;
                                state <= DONE;
                        end
                        else
                            CS <=   1'b0;
                    end
                end
            end

            // ---------------- DONE ----------------
            DONE: begin
                CS <= 1'b1;
                io_oe <= 1'b0;
                phase <= 1'b0;
                cs_cnt <= 0;
                $display("[%0t] SPI DONE opcode=%02h", $time, opcode);
                state <= CS_WAIT;
            end

            // ---------------- CS WAIT ----------------
            CS_WAIT: begin
                cs_cnt <= cs_cnt + 1;
                if (cs_cnt == 8)   // tSHSL >= 80ns
                    state <= IDLE;
            end

            endcase
        end
    end
endmodule
