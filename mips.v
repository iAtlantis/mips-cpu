/*
1)基本描述
MIPS为顶层文件，只含有复位信号rst和时钟信号clk，内部由控制器与数据通路组成。
2)模块接口
信号名	方向	描述
clk	I	时钟信号
rst	I	复位信号
3)功能定义
序号	功能名称	功能描述
1	构建CPU数据通路	连接内部组成模块，构建数据通路。
*/
`timescale 1ns / 1ns
module MIPS
        (
            input clk,          //时钟信号
            input rst           //复位信号
        );

        //数据通路
        //控制信号
        wire [5:0]op;
        wire [5:0]funct;
        wire zero;

        wire B_sel,           //ALU第二操作数的片选信号 0:RT域对应的数据 1:16位立即数通过EXT模块扩张后的数据
        wire [1:0]RFin_sel,   //RF的写入数据的片选信号
        wire RFWr,            //RF的写使能信号
        wire DMWr,            //DM的写使能信号
        wire [1:0]npcop,      //NPC的模式选择信号
        wire [1:0]extop,      //EXT的模式选择信号
        wire [3:0]aluop,      //ALU的运算控制信号
        wire PCWr,            //PC写使能信号 0:禁止写 1:允许写
        wire IRWr,            //IR写使能信号 0:禁止写 1:允许写
        wire [1:0]RFout_sel   //RF的写回寄存器的地址片选信号

        //DP模块

        //`````

        //ContralUnit ContralUnit();


        

endmodule