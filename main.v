`timescale 1ns / 1ns

module vending_Controller(
	
	//00-five
	//01-ten   
	//10-quarter   
	//11-dollar
	
	input wire [1:0] coin,	 // Value of Coin
	input wire coin_insert,  // Push Button
	input wire coin_return,	 // Push Button
	input wire [1:0] product,// Input Product
	input wire enable,		 // Enable Pin
	
	input clk,					 // Input Clock
	input reset,				 // Synchronous Reset
	
	output reg [1:0] pro,	 // Output Product
	output reg [2:0] change	 // Change Return	
    );

// State Assignment for Vending Machine Controller
// Using Gray Code for State Assignment
parameter Idle = 3'b000;
parameter Choose = 3'b001;
parameter Insert = 3'b011;
parameter Vend = 3'b010;
parameter Return = 3'b110;

reg [2:0] prev_state=0;
reg [2:0] state = 0;
reg [1:0] local_pro = 0;
integer total = 0;

always@(*)begin
	case(prev_state)
	Idle : begin
				total = 0;
				if(enable == 1)
					begin
						state = Choose;
					end
				end
	Choose : begin
				if(product == 2'b00)
					begin
						total = 0;
					end 
				else if(product == 2'b01)
					begin
						local_pro = 2'b01;
						total = 65;
						state = Insert;
					end 
				else if (product == 2'b10)
					begin
						local_pro = 2'b10;
						total = 100;
						state = Insert;
					end 
				else if(product == 2'b11)
					begin
						local_pro = 2'b11;
						total = 150;
						state = Insert;
					end
				end
	Insert : begin
					if(coin_insert == 1)
						begin
							if(coin == 2'b11)
								begin
									total = total - 100;
								end 
							else if(coin == 2'b10)
								begin
									total = total - 25;
								end 
							else if(coin == 2'b01)
								begin
									total = total - 10;
								end 
							else if(coin == 2'b00)
								begin
									total = total - 5;
								end
						end
			 
			 //coin_insert = 0;
					
					if(total <= 0)
						begin
							state = Vend;
						end
					if(coin_return == 1)
						begin
							state = Return;
						end
				end
	Vend : begin
				pro = local_pro;
				if(total == 0)
					begin
						change = 0;
					end 
				else
					begin
						if(total <= -100)
							begin
								total = total + 100;
								change = 3'b100;
							end
						else if(total <= -25)
							begin
								total = total + 25;
								change = 3'b011;
							end 
						else if(total <= -10)
							begin
								total = total + 10;
								change = 3'b010;
							end 
						else if(total <= -5)
							begin
								total = total + 5;
								change = 3'b001;
							end
					end
				state = Idle;
			end
	Return : begin
					if(local_pro == 2'b01)
						begin
							if(total >= 25)
								begin
									total = total - 25;
									change = 3'b011;
								end 
							else if(total >= 10)
								begin
									total = total - 10;
									change = 3'b010;
								end 
							else if(total >= 5)
								begin
									total = total - 5;
									change = 3'b001;
								end 
							else if(total == 0)
								begin
									change = 0;
									state = Idle;
								end
						end 
					else if(local_pro == 2'b10)
						begin
							if(total >= 100)
								begin
									total = total - 100;
									change = 3'b100;
								end 
							else if(total >= 25)
								begin
									total = total - 25;
									change = 3'b011;
								end 
							else if(total >= 10)
								begin
									total = total - 10;
									change = 3'b010;
								end 
							else if(total >= 5)
								begin
									total = total - 5;
									change = 3'b001;
								end 
							else if(total == 0)
								begin
									change = 0;
									state = Idle;
								end
						end 
					else if(local_pro == 2'b11)
						begin
							if(total >= 100)
								begin
									total = total - 100;
									change = 3'b100;
								end 
							else if(total >= 25)
								begin
									total = total - 25;
									change = 3'b011;
								end 
							else if(total >= 10)
								begin
									total = total - 10;
									change = 3'b010;
								end 
							else if(total >= 5)
								begin
									total = total - 5;
									change = 3'b001;
								end 
							else if(total == 0)
								begin
									change = 0;
									state = Idle;
								end
				end
			end
		endcase
	end
	
always@(posedge clk)
	begin : FSM
		if(reset == 1)
			begin
				prev_state <= Idle;
			end
		else
			begin
				prev_state <= state;
			end
	end
endmodule