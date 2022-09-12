# Read Me

* 功能

  本demo功能是实现：fpga读取双路12位adc的值后，通过串口将数据发送到arduino，arduino再进行串口解析将数据，将数据发送给oled显示。

  

* 文件结构

  * FPGA文件

    * exp_da 实验主模块

    * uart_tx_top 串口发送主模块

    * uart_byte_tx 串口发送byte模块

    * ad9226 adc模块

    * 还有一些时钟模块未包含进来

      

  * arduino文件

    * oled_driver(一些oled的库文件，自行下载)

* 实验设置

  双路adc读取数据一共24bit，刚好可以组成3bytes数据，然后将数据通过串口发送给arduino后，对接收到的3bytes数据进行恢复显示。

  arduino为了做数据同步，接收到的第一组数据必须为0。

  

* 实验结果

    * uart循环发送数据，串口助手显示数据

      * 循环发送数据

        ![](https://github.com/tanwork/FPGA_UART-and-Arduino_OLED/blob/main/imag/1.PNG)

      * 接收结果

        ![](https://github.com/tanwork/FPGA_UART-and-Arduino_OLED/blob/main/imag/2.PNG)

    * adc读取数据，串口助手显示数据

      ![](https://github.com/tanwork/FPGA_UART-and-Arduino_OLED/blob/main/imag/3.PNG)

      

      

      

      

