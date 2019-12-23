/*
1)基本描述
mips模块是一个CPU，只含有复位信号rst和时钟信号clk，内部由PC、NPC、DM、IM、EXT、ALU、IR、Ctrl等模块以及一些多路选择器和缓冲器组成。
2)模块接口
信号名	方向	描述
clk	I	时钟信号
rst	I	复位信号
3)功能定义
序号	功能名称	功能描述
1	构建CPU数据通路	连接内部组成模块，构建数据通路。
*/
`timescale 1ns / 1ns
module mips
        (
            input clk,          //时钟信号
            input rst           //复位信号
        );

//1	构建CPU数据通路	连接内部组成模块，构建数据通路。


endmodule