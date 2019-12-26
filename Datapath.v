/*
Datapath模块为该cpu的数据通路部分，内部由PC、NPC、DM、IM、EXT、ALU、IR等模块以及一些多路选择器和缓冲器组成
*/
`timescale 1ns / 1ns

module Datapath
        (
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
        );

        //PC and NPC
        wire [31:0]npc;
        wire [31:0]pc;

        //IMnoc
        wire [31:0]im_data;

        //IR
        wire [31:0]im_dout;

        //Register 
        wire [31:0]WriteData;
        wire [31:0]ReadDataA;
        wire [31:0]ReadDataB;

        //EXT
        wire [31:0]Imm32;

        //ALU
        wire DataOutC;
        wire Zero;

        //DL
        wire [31:0]DLOut;


        PC U_PC(npc[31:0],PCWr,clk,rst,pc[31:0]);
        /*
        INPUT:
            npc[31:0] <= NPC.npc[31:0]
            PCWr
            clk
            rst
        OUTPUT:
            pc[31:0]
        */

        NPC U_NPC(npcop[1:0],pc[31:0],im_dout[25:0],npc[31:0]);
        /*
        INPUT:
            npcop[1:0]
            pc[31:0] <= PC.pc[31:0]
            im_dout[25:0] <= IR.im_dout[31:0]
        OUTPUT:
            npc[31:0]
        */

        IMnoc U_IMnoc(pc[11:2],clk,im_data[31:0]);
        /*
        INPUT:
            address[11:2] <=  pc[11:2]
            clk
        OUTPUT:
            im_din[31:0]
        */

        IR U_IR(im_data[31:0],IRWr,rst,clk,im_dout[31:0]);
        /*
        INPUT:
            im_din[31:0] <= IMnoc.im_data[31:0]
            IRWr
            rst
            clk
        OUTPUT:
            im_dout
        */

        RF U_Register(im_dout[25:21],im_dout[20:16],im_dout[15:11],clk,RFWr,WriteData,ReadDataA,ReadDataB);
        /*
        INPUT:
            Reg1 (rs) <= im_dout[25:21]
            Reg2 (rt) <= im_dout[20:16]
            WriteReg (rd) <= im_dout[15:11]   //数据写入目的地址
            clk
            RFWr
            WriteData
        OUTPUT:
            DataOut1 => ReadDataA(A操作数)
            DataOut2 => ReadDataB(B操作数)
        */

        MUX_2 U_MUX2(ReadDataB,Imm32,DataOutB);

        ALU U_ALU(ReadDataA, DataOutB, aluop[3:0], Zero, DataOutC);
        /*
        INPUT:
            [31:0] A,     //操作数A
            [31:0] B,     //操作数B
            [3:0] aluop,  //运算操作数
        OUTPUT:
            zero,         //两操作数是否相等
            [31:0] C,     //运算结果
        */

        EXT U_EXT(im_dout[15:0],extop[1:0],Imm32[31:0]);
        /*
        INPUT:
            Imm16 <= im_dout[15:0]
            extop[1:0]
        OUTPUT:
            Imm32[31:0]
        */

        DL U_DL(DataOutC,rst,clk,DLOut[31:0]);
        /*
        INPUT:
            [31:0] din <= DataOutC
            rst
            clk
        OUTPUT:
            [31:0] dout => DLOut
        */

        DM U_DM(clk,dmwr,wren,DLOut[9:0],DataOutB,DMOut);
        /*
        INPUT:
            clk,              
            dmwr,             
            wren,             
            [11:2] address <= DLOut[9:0]
            [31:0] din <= DataOutB
        OUTPUT:
            [31:0] dout => DMOut
        */

        MUX_3 U_MUX3(pc[31:0], DLOut[31:0], DMOut, D_sel[1:0], WriteData);
        /*
        INPUT:
            d0 <= pc[31:0]
            d1 <= DLOut
            d2 <= DMOut
            [1:0]s <= [1:0]D_sel
        OUTPUT:
            dout
        */



        
        









endmodule 