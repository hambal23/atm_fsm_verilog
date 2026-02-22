`timescale 1ns/1ps

module tb();

reg clk = 0;
reg rst,confirm,pin_right,operation,bank_type;
reg [15:0] withdraw_amt;

wire allow_transaction,show_bal,transaction_done;

atm_fsm dut(clk,rst,confirm,pin_right,operation,bank_type,withdraw_amt,allow_transaction,show_bal,transaction_done);

always #5 clk = ~clk;

initial begin 

rst = 1;
#8 rst = 0;
pin_right = 1;
operation = 0;
bank_type = 0;

@(negedge clk)
pin_right = 0;

@(negedge clk)
pin_right =1;
operation = 1;
confirm = 1;
withdraw_amt = 16'd10000;

@(posedge clk)
if(transaction_done)
$display("TRANSACTION SUCCESSFULL!");
else
$display("TRANSACTION UNSUCCESSFULL");

@(negedge clk) 
operation = 0;
confirm = 0;
bank_type = 1;

if(show_bal)
$display("BALANCE IN THE ACCOUNT IS : ");

@(negedge clk)
operation = 1;
confirm = 1;
withdraw_amt = 16'd5000;

@(posedge clk)
if(transaction_done)
$display("TRANSACTION SUCCESSFULL!");
else
$display("TRANSACTION UNSUCCESSFULL");

@(negedge clk)
withdraw_amt = 16'd1000;

@(posedge clk)
if(!allow_transaction)
$display("ERROR : TRANSACTION NOT ALLOWED");

#10 $finish;

end

endmodule 
