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

            output reg [5:0]OP;
            output reg [5:0]funct;
            output reg [31:0]IR;
            output reg [4:0]Aaddress;
            output reg [4:0]Baddress;
            output reg [31:0]DMdata;
            output reg [31:0]Adata;
            output reg [31:0]Bdata;
            output reg [4:0]Waddress;
            output reg [31:0]regBdata;
            output reg [31:2]PC;
            output reg [31:0]dmadd;
            output reg [31:0]IMdata;
        );

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

        //Datapath Out Point

        //ContralUnit Model
        ContralUnit U_CU(clk,rst,op[5:0],funct[5:0],zero,
                         B_sel,RFin_sel[1:0],RFWr,DMWr,npcop[1:0],extop[1:0],aluop[3:0],PCWr,IRWr,RFout_sel[1:0],);
        /*
            input clk,                  //时钟信号
            input rst，                 //复位信号
            input [5:0]op,              //指令格式中的OPCODE域
            input [5:0]funct,           //指令格式中的FUNCT域
            input zero,                 //ALU输出信号 0:ALU两操作数不相等，1:ALU两操作数相等

            output reg B_sel,           //ALU第二操作数的片选信号 0:RT域对应的数据 1:16位立即数通过EXT模块扩张后的数据
            output reg [1:0]RFin_sel,  //RF的写入数据的片选信号
            output reg RFWr,            //RF的写使能信号
            output reg DMWr,            //DM的写使能信号
            output reg [1:0]npcop,      //NPC的模式选择信号
            output reg [1:0]extop,      //EXT的模式选择信号
            output reg [3:0]aluop,      //ALU的运算控制信号
            output reg PCWr,            //PC写使能信号 0:禁止写 1:允许写
            output reg IRWr,            //IR写使能信号 0:禁止写 1:允许写
            output reg [1:0]RFout_sel   //RF的写回寄存器的地址片选信号
        */

        //Datapath Model
        Datapath U_DP(npcop[1:0],RFWr,aluop[3:0],PCWr,B_sel,RFin_sel[1:0],DMWr,IRWr,RFout_sel[1:0],extop[1:0],
                      op[5:0],funct[5:0],
                      IR[31:0],Aaddress[4:0],Baddress[4:0],DMdata[31:0],Adata[31:0],Bdata[31:0],Waddress[4:0],regBdata[31:0],
                      zero,
                      PC[31:2],dmadd[31:0],IMdata[31:0]);

        /*
            input [1:0]npcop,
            input RFWr,               //RF寄存器组写使能信号
            input [3:0]aluop,
            input PCWr,                 //PC写使能信号
            input sel,
            input [1:0]D_sel,
            input wren,
            input IRWr,
            input [1:0]R_sel,
            input [1:0]extop,
            input rst,
            input clk,
            
            output [5:0]op,             //im_dout[31:26]
            output [5:0]funct,          //im_dout[5:0]
            output [31:0]IR,            //im_dout
            output [4:0]Aaddress,       //im_dout[25:21]
            output [4:0]Baddress,       //im_dout[20:16]
            output [31:0]DMdata,        //DMOut
            output [31:0]Adata,         //ReadDataA
            output [31:0]Bdata,         //DataOutB
            output [4:0]Waddress,       //im_dout[15:11]
            output [31:0]regBdata,      //ReadDataB
            output zero,                //Zero
            output [31:2]PCdata,        //pc
            output [31:0]dmadd,         //DMOut
            output [31:0]IMdata         //im_data
        */

        

endmodule