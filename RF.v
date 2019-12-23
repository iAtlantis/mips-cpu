/*
    RF主要功能是保存寄存器文件，并支持对通用寄存器的访问。
1	写操作	当‘RegWre’==1且‘WriteReg’！=0时写入地址
2	读操作	将rs rt地址所对应的的数据从DataOut1和DataOut2输出
*/
`timescale 1ns / 1ns
module RF
        (
            input [4:0] Reg1,           //寄存器rs的地址
            input [4:0] Reg2,           //寄存器rt的地址
            input [4:0] WriteReg,       //寄存器地址的输入端（rd中的地址）
            input clk,                  //时钟信号  
            input RegWre,               //寄存器是否需要写功能
            input [31:0] WriteData,     //寄存器数据输入端
            output reg [31:0] DataOut1, //rs寄存器数据输出端
            output reg [31:0] DataOut2, //rt寄存器数据输出端  
        )；


endmodule