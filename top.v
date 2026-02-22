module atm_fsm
(
input clk,rst,confirm,pin_right,operation,bank_type,
input [15:0] withdraw_amt,
output reg allow_transaction,
output reg show_bal,
output reg transaction_done
);

reg [15:0] amount_withdrawn_already = 0; 
wire [15:0] next_withdraw_amt; 

parameter [15:0] limit_amt = 16'd15000;

reg [2:0] next_st , state;


/// STATE ENCODING 

parameter IDLE = 3'b000;
parameter PIN_CHECK = 3'b001;
parameter AMOUNT_ENTRY = 3'b010;
parameter CASH_WITHDRAW = 3'b011;
parameter BALANCE_ENQUIRY = 3'b100;
parameter SAVINGS = 3'b101;
parameter CURRENT = 3'b110;

assign next_withdraw_amt = amount_withdrawn_already + withdraw_amt;

// STATE TRANSITION

always@(posedge clk)
begin
if(rst)
begin

amount_withdrawn_already <= 0;

state <= IDLE;

end

else 
state <= next_st;

end

always@(posedge clk)
begin

if(state == CASH_WITHDRAW)
begin

/// amount_wihtdrawn_already is the variable that stores how much money has been withdrawn in a day
/// and how much more can be withdrawn

if(next_withdraw_amt <= limit_amt)
amount_withdrawn_already <= next_withdraw_amt;

end


end

// NEXT STATE LOGIC  

always@(*)
begin

next_st = IDLE;

case(state)

IDLE : begin

next_st = PIN_CHECK;

end 

PIN_CHECK : begin

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

AMOUNT_ENTRY : begin

if(confirm)
next_st = CASH_WITHDRAW;

end 

BALANCE_ENQUIRY : begin 

if(bank_type)
next_st = SAVINGS;
else
next_st = CURRENT;

end 

SAVINGS : begin

next_st = IDLE ;

end 

CURRENT : begin 

next_st = IDLE;

end

CASH_WITHDRAW : begin 

next_st = IDLE;

end 

endcase 

end

// OUTPUT LOGIC 

always@(*)
begin

show_bal = 0;
allow_transaction = 0 ;
transaction_done = 0;


case(state)

IDLE : begin

show_bal = 0;
transaction_done = 0;

end 

PIN_CHECK : begin

show_bal = 0;
transaction_done = 0;

end 

AMOUNT_ENTRY : begin 

show_bal = 0;
transaction_done = 0;

end 

CASH_WITHDRAW : begin 

show_bal = 0;
transaction_done = 1;

if(next_withdraw_amt <= limit_amt)
allow_transaction = 1;
else
allow_transaction = 0;

end 

BALANCE_ENQUIRY : begin 

show_bal = 0;
transaction_done = 0;

end 

SAVINGS : begin 

show_bal = 1;
transaction_done = 0;

end 

CURRENT : begin 

show_bal = 1;
transaction_done = 0;

end 

endcase 

end 

endmodule 



