`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/07 19:35:32
// Design Name: 
// Module Name: exp_da
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


module exp_da(
    input         sys_clk      ,
    input         sys_rst_n    ,
    input   [3:0]      key         ,
    input   [11:0]     adc_input ,
    input   [11:0]     adc_input2 ,
    //seg_led interface
    output           clk_1Hz   ,
    output    [5:0]  seg_sel  ,       // �����λѡ�ź�
    output    [7:0]  seg_led  ,        // ����ܶ�ѡ�ź�

//  output        locked       
    output                da_clk      , //DA����ʱ��
    output                da_wrt      ,
    output     [13:0]     da_data     , //DA��������
    
    output                da_clk2      , //DA����ʱ��
    output                da_wrt2      ,
    output     [13:0]     da_data2      ,//DA��������
    output     u_tx                     ,
    output     wire_start,
     
    output                adc_clk1     ,
    output                adc_clk2     
    );
    
//    wire       clk_1Hz      ;
      wire       clk_10Hz      ;
      wire       clk_40m      ;
      wire       clk_50m      ;
//    wire       clk_80m      ;
      wire       clk_100m     ;
//    wire       clk_125m     ;
      wire       locked       ;
      wire        clk_2m       ;
      wire        clk_10m      ;
      wire        clk_20m      ;
      wire        clk_80m      ;
      wire        clk_125m     ;
      wire        adc_clk_input;
    
    wire      [13:0]     rd_addr;              //ROM��ַ
    wire      [9:0]      rd_data;              //ROM����
    wire      [9:0]      rd_data_out1;
    
    wire      [13:0]     rd_addr2;              //ROM��ַ
    wire      [9:0]     rd_data2;              //ROM����
    wire      [9:0]     rd_data_out2;
     
    wire      [19:0]     rd_data_out3;
    wire      [23:0]     adc_out;
    
    wire      clk_input;
    
    assign rd_data_out3='d0;
    assign clk_input=clk_10Hz;

    

   
    //ʱ���ź�
  clk_wiz_0 instance_name
   (
    // Clock out ports
    .clk_40m(clk_40m),     // output clk_40m
    .clk_50m(clk_50m),     // output clk_50m
    .clk_80m(clk_80m),     // output clk_80m
    .clk_125m(clk_125m),     // output clk_125m
    .clk_10m(clk_10m),     // output clk_10m
    // Status and control signals
    .resetn(sys_rst_n), // input resetn
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(sys_clk));      // input clk_in1
    
    
    count_10  count_10_u1(
    . rst_n   (sys_rst_n)  ,
    . clk_40m (clk_40m)  ,
    . clk_2m  (clk_2m)
    );
    
    count_2 count_2_u1(
    .sys_rst_n  (sys_rst_n)   ,
    .clk_40m    (clk_80m)   ,
    .clk_20m    (clk_20m)
     );
     
    count_1m u_count_1m(
    . clk_2m     (clk_2m)  ,
    . rst_n      (sys_rst_n)  ,
    . clk_1hz    (clk_1Hz)
    );
    
    count_1m u2(
    . clk_2m     (clk_20m)  ,
    . rst_n      (sys_rst_n)  ,
    . clk_1hz    (clk_10Hz)
    );
          
/////////////////////////vo1ʵ��//////////////////////////////////////
     blk_mem_gen_0 rom_u1 (
     .clka(clk_125m),    // input wire clka
     .addra(rd_addr),  // input wire [13 : 0] addra
     .douta(rd_data)  // output wire [9 : 0] douta
    );
    
    da_wave_send da_wave_send_u1(
    .clk       (clk_input)  ,   //ϵͳʱ��           
    .rst_n     (sys_rst_n)  ,   //ϵͳ��λ���͵�ƽ��Ч     
    .rd_data   (rd_data)  ,   //ROM����������           
    .rd_addr   (rd_addr)  ,    //��ROM��ַ          
    .da_clk    (da_clk)  ,   //DA����ʱ��   
    .da_wrt    (da_wrt)  ,   //DAд�ź�
    .da_data   (rd_data_out1),  //�����DA������ 
    .key1       (key[0]),
    .key2       (key[1])                            
    );
    
    
    blk_mem_gen_1 out_rom1 (
      .clka(clk_125m),            // input wire clka
      .addra(rd_data_out1),        // input wire [9 : 0] addra
      .douta(da_data)             // output wire [13 : 0] douta
        );
    
    
    
/////////////////////////vo2ʵ��//////////////////////////////////////
    
     //rom����
     blk_mem_gen_2 rom_u3 (
     .clka(clk_125m),    // input wire clka
     .addra(rd_addr2),  // input wire [13 : 0] addra
     .douta(rd_data2)  // output wire [9 : 0] douta
    );
    
    da_send_u2 da_wave_send_u2(
    .clk       (clk_input)  ,   //ϵͳʱ��           
    .rst_n     (sys_rst_n)  ,   //ϵͳ��λ���͵�ƽ��Ч     
    .rd_data   (rd_data2)  ,   //ROM����������           
    .rd_addr   (rd_addr2)  ,    //��ROM��ַ          
    .da_clk    (da_clk2)  ,   //DA����ʱ��   
    .da_wrt    (da_wrt2)  ,   //DAд�ź�
    .da_data   (rd_data_out2),     //�����DA������ 
    .key1       (key[2]),
    .key2       (key[3])
    );
    
     blk_mem_gen_3 rom_u4 (
     .clka(clk_125m),    // input wire clka
     .addra(rd_data_out2),  // input wire [9 : 0] addra
     .douta(da_data2)  // output wire [13 : 0] douta
    );
    
/////////////////////////����//////////////////////////////////
//    ila_0 your_instance_name (
//    	.clk(clk_50m), // input wire clk

//    	.probe0(da_clk), // input wire [0:0]  probe0  
//    	.probe1(da_wrt), // input wire [0:0]  probe1 
//    	.probe2(rd_addr), // input wire [13:0]  probe2 
//    	.probe3(da_data) // input wire [13:0]  probe3
//    );

////////////////////////////////////////////////////////
    //wire define
    wire    [19:0]  data;                 // �������ʾ����ֵ
    wire    [ 5:0]  point;                // �����С�����λ��
    wire            en;                   // �������ʾʹ���ź�
    wire            sign;                 // �������ʾ���ݵķ���λ
    
    //������ģ�飬�����������Ҫ��ʾ������
count u_count(
    .clk           (sys_clk  ),       // ʱ���ź�
    .rst_n         (sys_rst_n),       // ��λ�ź�
    .clk_1hz       (clk_input),
    .input_data    (rd_data_out3),

    .data          (data     ),       // 6λ�����Ҫ��ʾ����ֵ
    .point         (point    ),       // С���������ʾ��λ��,�ߵ�ƽ��Ч
    .en            (en       ),       // �����ʹ���ź�
    .sign          (sign     )        // ����λ
);

//����ܶ�̬��ʾģ��
seg_led u_seg_led(
    .clk           (sys_clk  ),       // ʱ���ź�
    .rst_n         (sys_rst_n),       // ��λ�ź�

    .data          (data     ),       // ��ʾ����ֵ
    .point         (point    ),       // С���������ʾ��λ��,�ߵ�ƽ��Ч
    .en            (en       ),       // �����ʹ���ź�
    .sign          (sign     ),       // ����λ���ߵ�ƽ��ʾ����(-)
    
    .seg_sel       (seg_sel  ),       // λѡ
    .seg_led       (seg_led  )        // ��ѡ
);

//////////////////adcģ��////////////////
wire [11:0] adc_out_put;
wire [11:0] adc_out_put2;

assign adc_clk_input=clk_2m;

ad9226 u1_ad9226(
   .date_in   (adc_input)  ,
   .date_out  (adc_out_put)  ,
   .clk       (adc_clk_input),
   .clk_out    (adc_clk1)
    );
    
ad9226 u2_ad9226(
   .date_in   (adc_input2)  ,
   .date_out  (adc_out_put2)  ,
   .clk       (adc_clk_input),
   .clk_out    (adc_clk2)
    );
    

//////////////////////uartģ��///////////////////////////////
reg enable;
wire isDone;
reg [23:0]adc_data;


always@(posedge sys_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)begin
        enable<='d1;
    end
    else if(isDone)begin
        adc_data[11:0]<=adc_out_put;
        adc_data[23:12]<=adc_out_put2;
        enable<='d1;
    end
    else
        enable<='d0;          
end  



////////// for testing uart 
//reg [2:0]cnt;   	
//always@(posedge sys_clk or negedge sys_rst_n)begin
//    if(!sys_rst_n)begin
//        cnt <= 0;
//        enable<='d1;
//    end
//    else if(isDone)begin
//        if(cnt>='d2)
//            cnt<='d0;
//        else
//            cnt <= cnt + 1'd1;
//        enable<='d1;
//    end 
//    else begin
//        cnt<=cnt;
//        enable<='d0; 
//    end
//end    
           
//always@(posedge sys_clk) begin
//    case(cnt)	//����߼�û�������������ĸ��� ֱ��"="
//        3'd0:adc_data = 'h0c0b0a;  
//        3'd1:adc_data = 'h030201; 
//        3'd2:adc_data = 'h060504;
//        default:adc_data=adc_data;
//    endcase
//end
 
 
uart_tx_top u_uart_tx_top(
	.clk      (sys_clk),
	.rst      (sys_rst_n),
	.enable   (enable),
	.send_data(adc_data),
	.rs232_tx (u_tx),
	.isDone   (isDone)
);

endmodule
