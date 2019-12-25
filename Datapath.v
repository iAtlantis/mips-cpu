/*
Datapath模块为该cpu的数据通路部分，内部由PC、NPC、DM、IM、EXT、ALU、IR等模块以及一些多路选择器和缓冲器组成
*/
`timescale 1ns / 1ns

module Datapath
        (
            input [1:0]npcop,
            input RegWre,
            input [3:0]aluop,
            input PCWr,
            input sel,
            input [1:0]x1,
            input wren,
            input IRWr,
            input [1:0]x2,
            input [1:0]extop,
            input rst,
            input clk,
            
            output [5:0]op,
            output [5:0]funct,
            output [31:0]IR,            //im_dout
            output [4:0]Aaddress,
            output [4:0]Baddress,
            output [31:0]DMdata,
            output [31:0]Adata,
            output [31:0]Bdata,
            output [4:0]Waddress,
            output [31:0]regBdata,
            output zero,
            output [31:2]PCdata,         //pc
            output [31:0]dmadd,
            output [31:0]IMdata         //im_data
        );

        //PC and NPC
        wire [31:0]npc;
        wire [31:0]pc;

        //IMnoc
        wire [31:0]im_data;

        //IR
        //wire [31:0]im_dout;

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

        EXT U_EXT(im_dout[15:0],extop[1:0],Imm32[31:0]);
        /*
        INPUT:
            Imm16 <= im_dout[15:0]
            extop[1:0]
        OUTPUT:
            Imm32[31:0]
        */

        









endmodule 