`timescale 1ns / 1ps


module uart_byte_tx(
	clk,
	rst,
	data_byte,
	send_en,
	baud_set,
	
	rs232_tx,
	tx_done,
	uart_state
);
	input clk;
	input rst;
	input [7:0]data_byte;
	input send_en;
	input [2:0]baud_set;
	
	output reg rs232_tx;
	output reg tx_done;
	output reg uart_state;

	reg [15:0]div_cnt;//分频计数器
	reg [15:0]bps_dr;	//分频计数最大值
	reg [3:0] bps_cnt;	//波特率计数时钟
	reg [7:0] r_data_byte;
	reg bps_clk;		//波特率时钟
	
	//发送使能。其中有两个2选1，存在优先级
	always@(posedge clk or negedge rst)begin
		if(!rst)
			uart_state <= 0;
		else if(send_en)
			uart_state <= 1;
		else if(bps_cnt == 4'd11)
			uart_state <= 0;
		else 
			uart_state <= uart_state;
    end

	//先寄存发送的数据
	always@(posedge clk or negedge rst)begin
		if(!rst)
			r_data_byte <= 0;
		else if(send_en)
			r_data_byte <= data_byte;
		else
			r_data_byte <= r_data_byte;
    end
	
	//波特率查找表
	always@(posedge clk or negedge rst)begin
		if(!rst)
			bps_dr <= 16'd5207;
		else begin
			case(baud_set)
				0:bps_dr <= 16'd5207;
				1:bps_dr <= 16'd2603;
				2:bps_dr <= 16'd1301;
				3:bps_dr <= 16'd867;
				4:bps_dr <= 16'd433;
				default:bps_dr <= 16'd5207;
			endcase
		end
    end
	
	//波特率计时器
	always@(posedge clk or negedge rst)begin
		if(!rst)
			div_cnt <= 0;
		else if(uart_state)begin
			if(div_cnt == bps_dr)
				div_cnt <= 0;
			else
				div_cnt <= div_cnt + 1'b1;
		end
		else
			div_cnt <= 0;
    end

	//生成波特率时钟
	always@(posedge clk or negedge rst)begin
		if(!rst)
			bps_clk <= 0;
		else if(div_cnt == 16'd1)
			bps_clk <= 1;
		else
			bps_clk <= 0;
    end
		
	//波特率时钟位数控制数据位数传递
	always@(posedge clk or negedge rst)begin
		if(!rst)
			bps_cnt <= 0;
		else if(bps_cnt == 4'd11)
			bps_cnt <= 0;
		else if(bps_clk)
			bps_cnt <= bps_cnt + 1'b1;
		else
			bps_cnt <= bps_cnt;
    end
	
	//tx_done
	always@(posedge clk or negedge rst)begin
		if(!rst)
			tx_done <= 0;
		else if(bps_cnt == 4'd11)
			tx_done <= 1;
		else
			tx_done <= 0;
    end
			
	//10选1多路器
	always@(posedge clk or negedge rst)begin
		if(!rst)
			rs232_tx <= 1'b1;	//默认的
		else begin
			case(bps_cnt)
				0 :rs232_tx <= 1'b1;
				1 :rs232_tx <= 1'd0;					//就是START_BIT
				2 :rs232_tx <= r_data_byte[0];
				3 :rs232_tx <= r_data_byte[1];
				4 :rs232_tx <= r_data_byte[2];
				5 :rs232_tx <= r_data_byte[3];
				6 :rs232_tx <= r_data_byte[4];
				7 :rs232_tx <= r_data_byte[5];
				8 :rs232_tx <= r_data_byte[6];
				9 :rs232_tx <= r_data_byte[7];
				10:rs232_tx <= 1'b1;					//就是STOP_BIT
				default:rs232_tx <= 1'b1;
			endcase
		end
    end
			
endmodule
