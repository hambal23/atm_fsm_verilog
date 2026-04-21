module atm_fsm(
input clk,
input rst,
input confirm,
input pin_right,
input operation,
input bank_type,
input [15:0] withdraw_amt,

output reg allow_transaction,
output reg show_bal,
output reg transaction_done
);

reg [15:0] amount_withdrawn_already;
wire [15:0] next_withdraw_amt;

parameter [15:0] limit_amt = 16'd15000;

reg [2:0] state, next_st;

// STATE ENCODING 

parameter IDLE             = 3'b000;
parameter PIN_CHECK        = 3'b001;
parameter AMOUNT_ENTRY     = 3'b010;
parameter CASH_WITHDRAW    = 3'b011;
parameter BALANCE_ENQUIRY  = 3'b100;
parameter SAVINGS          = 3'b101;
parameter CURRENT          = 3'b110;

assign next_withdraw_amt = amount_withdrawn_already + withdraw_amt;

// SEQUENTIAL BLOCK 

always @(posedge clk) // USING SYNCHRONOUS RESET 
begin
    if(rst)
    begin
        state <= IDLE;
        amount_withdrawn_already <= 0;
        allow_transaction <= 0;
    end
    else
    begin 
        state <= next_st;

        if(state == CASH_WITHDRAW)
        begin
            if(next_withdraw_amt <= limit_amt)
            begin
                amount_withdrawn_already <= next_withdraw_amt; // although 'amount_withdrawn_already' is an output it is not included in the output logic (programmed later in the code)
                allow_transaction <= 1; // because , it depends on the stored register updates (i.e it depends on 'amount_withdrawn_already') + clock edge , so it is evaluted here , in the sequential block only  
            end
            else
                allow_transaction <= 0;
        end
        else
            allow_transaction <= 0;
    end
end

// NEXT STATE LOGIC 

always @(*)
begin
    next_st = state;

    case(state)

        IDLE:
            next_st = PIN_CHECK;

        PIN_CHECK:
        begin
            if(pin_right)
            begin
                if(operation)
                    next_st = AMOUNT_ENTRY;
                else
                    next_st = BALANCE_ENQUIRY;
            end
            else
                next_st = PIN_CHECK;
        end

        AMOUNT_ENTRY:
        begin
            if(confirm)
                next_st = CASH_WITHDRAW;
        end

        CASH_WITHDRAW:
            next_st = IDLE;

        BALANCE_ENQUIRY:
        begin
            if(bank_type)
                next_st = SAVINGS;
            else
                next_st = CURRENT;
        end

        SAVINGS:
            next_st = IDLE;

        CURRENT:
            next_st = IDLE;

        default:
            next_st = IDLE;

    endcase
end

// OUTPUT LOGIC 

always @(*)
begin
    show_bal = 0;
    transaction_done = 0;

    case(state)

        CASH_WITHDRAW:
            transaction_done = 1;

        SAVINGS:
            show_bal = 1;

        CURRENT:
            show_bal = 1;

    endcase
end

endmodule