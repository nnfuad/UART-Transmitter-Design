module uart_tx(
    input clk,
    input rst,
    input tx_start,
    input [7:0] tx_data,

    output reg tx,
    output reg tx_busy
);

parameter CLKS_PER_BIT = 10;

reg [3:0] state;
reg [7:0] data_reg;
reg parity_bit;
reg [3:0] bit_index;
reg [15:0] clk_count;

localparam IDLE   = 0;
localparam START  = 1;
localparam DATA   = 2;
localparam PARITY = 3;
localparam STOP   = 4;

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin
        state <= IDLE;
        tx <= 1'b1;
        tx_busy <= 0;
        clk_count <= 0;
        bit_index <= 0;
    end

    else
    begin

        case(state)

        //----------------------------------
        // IDLE
        //----------------------------------
        IDLE:
        begin
            tx <= 1'b1;
            tx_busy <= 0;

            if(tx_start)
            begin
                data_reg <= tx_data;

                // Even parity
                parity_bit <= ^tx_data;

                tx_busy <= 1;
                state <= START;
            end
        end

        //----------------------------------
        // START BIT
        //----------------------------------
        START:
        begin
            tx <= 1'b0;

            if(clk_count < CLKS_PER_BIT-1)
                clk_count <= clk_count + 1;
            else
            begin
                clk_count <= 0;
                state <= DATA;
            end
        end

        //----------------------------------
        // DATA BITS
        //----------------------------------
        DATA:
        begin

            tx <= data_reg[bit_index];

            if(clk_count < CLKS_PER_BIT-1)
                clk_count <= clk_count + 1;
            else
            begin
                clk_count <= 0;

                if(bit_index < 7)
                    bit_index <= bit_index + 1;
                else
                begin
                    bit_index <= 0;
                    state <= PARITY;
                end
            end
        end

        //----------------------------------
        // PARITY BIT
        //----------------------------------
        PARITY:
        begin

            tx <= parity_bit;

            if(clk_count < CLKS_PER_BIT-1)
                clk_count <= clk_count + 1;
            else
            begin
                clk_count <= 0;
                state <= STOP;
            end
        end

        //----------------------------------
        // STOP BIT
        //----------------------------------
        STOP:
        begin

            tx <= 1'b1;

            if(clk_count < CLKS_PER_BIT-1)
                clk_count <= clk_count + 1;
            else
            begin
                clk_count <= 0;
                state <= IDLE;
            end
        end

        endcase

    end

end

endmodule