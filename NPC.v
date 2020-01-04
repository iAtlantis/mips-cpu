/*
    NPC是下条指令计数器，主要功能是计算下一条指令地址，NPCOp[1:0]决定如何计算NPC
*/

`timescale 1ns / 1ns
module NPC
        (
            input [31:0] pc,            //本条指令的地址
            input [15:0] imm16,
            input [25:0] imm26,         //立即数
            input [1:0] npcop,          //计算方式
            output reg [31:0] npc       //下条指令的地址
        );
        
    always @ (npcop)
        begin
            case(npcop)
                2'b00:
                    begin
                        //顺序地址
                        npc = pc + 1;
                    end
                2'b01:
                    begin
                        //计算B指令转移地址
                        //npc <- pc + { sign_ext(imm16 )}
//                        if(imm16[15]==0)		
//                            imm16ex={14'b00000000000000,imm16[15:0],2'b0};
//								else if(imm16[15]==1)	
//                            imm16ex={14'b11111111111111,imm16[15:0],2'b0};
//								npc = pc + 4 + imm16ex;
                        if(imm16[15]==0)		
                            npc = pc + 1 + {16'b0000000000000000,imm16[15:0]};
								else if(imm16[15]==1)	
                            npc = pc + 1 + {16'b1111111111111111,imm16[15:0]};
                    end
                2'b10:
                    begin
                        //计算J类指令转移地址
                        npc = {pc[31:28],imm26,2'b0};
                    end
                endcase
        end

endmodule
