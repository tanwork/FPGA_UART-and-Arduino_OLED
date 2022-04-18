`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/22 14:46:50
// Design Name: 
// Module Name: ad9226
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


module ad9226(date_in,date_out,clk,clk_out);
input  [11:0]  date_in;
input   clk;
output [11:0] date_out;
output clk_out;

assign clk_out=clk;

reg  [11:0] date_out;
   always@( posedge clk )begin 
    date_out <= date_in;
   end    
endmodule 
