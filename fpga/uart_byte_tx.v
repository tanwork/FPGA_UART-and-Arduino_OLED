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

	reg [15:0]div_cnt;//��Ƶ������
	reg [15:0]bps_dr;	//��Ƶ�������ֵ
	reg [3:0] bps_cnt;	//�����ʼ���ʱ��
	reg [7:0] r_data_byte;
	reg bps_clk;		//������ʱ��
	
	//����ʹ�ܡ�����������2ѡ1���������ȼ�
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

	//�ȼĴ淢�͵�����
	always@(posedge clk or negedge rst)begin
		if(!rst)
			r_data_byte <= 0;
		else if(send_en)
			r_data_byte <= data_byte;
		else
			r_data_byte <= r_data_byte;
    end
	
	//�����ʲ��ұ�
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
	
	//�����ʼ�ʱ��
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

	//���ɲ�����ʱ��
	always@(posedge clk or negedge rst)begin
		if(!rst)
			bps_clk <= 0;
		else if(div_cnt == 16'd1)
			bps_clk <= 1;
		else
			bps_clk <= 0;
    end
		
	//������ʱ��λ����������λ������
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
			
	//10ѡ1��·��
	always@(posedge clk or negedge rst)begin
		if(!rst)
			rs232_tx <= 1'b1;	//Ĭ�ϵ�
		else begin
			case(bps_cnt)
				0 :rs232_tx <= 1'b1;
				1 :rs232_tx <= 1'd0;					//����START_BIT
				2 :rs232_tx <= r_data_byte[0];
				3 :rs232_tx <= r_data_byte[1];
				4 :rs232_tx <= r_data_byte[2];
				5 :rs232_tx <= r_data_byte[3];
				6 :rs232_tx <= r_data_byte[4];
				7 :rs232_tx <= r_data_byte[5];
				8 :rs232_tx <= r_data_byte[6];
				9 :rs232_tx <= r_data_byte[7];
				10:rs232_tx <= 1'b1;					//����STOP_BIT
				default:rs232_tx <= 1'b1;
			endcase
		end
    end
			
endmodule
