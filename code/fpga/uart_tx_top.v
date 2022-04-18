`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/12 12:17:28
// Design Name: 
// Module Name: uart_tx_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_tx_top(
	clk,
	rst,
	enable,
	send_data,
	rs232_tx,
	isDone
);
	input clk;
	input rst;
	input [23:0]send_data;
	input enable;
	output rs232_tx;
	output reg isDone;
//	wire enable_pe;
	
	reg flag;
	reg [2:0]xcnt;
	
	reg send_en;
	reg [7:0]data_byte;
	wire tx_done;

   	wire[7:0]  byte1;
	wire[7:0]  byte2;
	wire[7:0]  byte3;
	
	reg[23:0] send_data_reg;
	
	
	uart_byte_tx uart_byte_tx(
		.clk(clk),
		.rst(rst),
		.data_byte(data_byte),
		.send_en(send_en),
		.baud_set(3'd4),
		
		.rs232_tx(rs232_tx),
		.tx_done(tx_done)
	);
	
	always@(posedge clk or negedge rst)begin
		if(!rst)
			flag <= 0;
		else if(enable)
			flag <= 1;
		else if(xcnt >= 'd4)
			flag <= 0;
		else 
			flag <= flag;
    end

	
	always@(posedge clk or negedge rst)begin
		if(!rst)
			xcnt <= 0;
		else if(xcnt>='d4)
		  xcnt<='d0;
		else if(tx_done && flag)
		    xcnt <= xcnt + 1'd1;
        else
           xcnt <= xcnt; 
    end
        
			
	always@(posedge clk or negedge rst)begin
		if(!rst)
			send_en <= 0;
		else if(flag)
		    send_en <= 1;
        else 
            send_en <= 'd0;
    end
      
    always@(posedge clk or negedge rst)begin
        if(!rst)
            send_data_reg<='d0;
        else if(enable)
            send_data_reg<=send_data;
        else
            send_data_reg<=send_data_reg;
    end  
      
	always@(posedge clk or negedge rst)begin
		if(!rst)begin
            isDone  <= 0;
        end
        else if(xcnt>='d4)
            isDone  <= 1'b1; 
        else if(xcnt<'d4)
            isDone  <= 1'b0; 
		else 
            isDone  <= isDone; 
    end
        
        		
	always@(posedge clk)begin
		case(xcnt)	//组合逻辑没有阻塞非阻塞的概念 直接"="
		    3'd0:data_byte = 'h00;  
			3'd1:data_byte = send_data_reg[7:0];  
			3'd2:data_byte = send_data_reg[15:8]; 
			3'd3:data_byte = send_data_reg[23:16];
			default:data_byte ='hff;
		endcase
    end


//    edge_detect3 u2_edge_detect3(
//        .clk   (clk)  , 
//        .signal (enable)  ,
//        .pe	   (enable_pe)
//        );			
endmodule

