/*
    NPC是下条指令计数器，主要功能是计算下一条指令地址，NPCOp[1:0]决定如何计算NPC
*/

`timescale 1ns / 1ns
module NPC
        (
            input [31:0] pc,            //本条指令的地址
            input [25:0] immediate，    //立即数
            input [1:0] npcop,          //计算方式
            output reg [31:0] npc       //下条指令的地址
        );
        
    always@(posedge clk)
        begin
            if(npcop==2'b00)
                begin
                    //顺序地址
                    //npc <- pc +1
                end
            else if(npcop==2'b01)
                begin
                    //计算B指令转移地址
                    //npc <- pc + { sign_ext(imm16 )}
                end
            else if(npcop==2'b10)
                begin
                    //计算J类指令转移地址
                    //npc <- { pc[31:28] , imm26 }
                end
        end

endmodule
