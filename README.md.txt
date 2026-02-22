# ATM CONTROL FSM USING VERILOG HDL 

This project implements an ATM Controller using a Finite State Machine (FSM) in Verilog HDL 
The Design Models core ATM operations such as :

. Pin verification 
. Amount Entry  
. Cash Withdrawal
. Balance Enquiry 

An additional feature was implemented to track cumulative withdrawal amount and enforce a daily withdrawal limit .

# KEY FEATURES 

. Moore Style FSM design 
. Separate Sequential and Combinational logic 
. Withdrawal limit cheecking
. Correct Pin checking 
. Total Withdrawal Limit Tracking
. Clean Next state and Output logic implementation 
. Synthesizable Verilog RTL 

Simulatioin was performed using a Verilog Testbench containing check for all edge cases like : 

. Correct pin + valid Withdrawal 
. Withdrwal exceeding daily limit 
