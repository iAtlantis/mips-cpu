/*
    EXT主要功能是将16位的数据扩展为32位数据
    2'b00:无符号16to32
    2'b01:有符号16to32
    2'b10:拓展到高16位
*/
`timescale 1ns / 1ns
module EXT
        (
            input [15:0] Imm16,         //需要进行拓展的数据
            input [1:0] extop,          //拓展方式的控制信号：00:0拓展，01:符号拓展，10:将立即数拓展到高位
            output reg [31:0] Imm32     //拓展结果
        );
        
    always@(*)
    begin
        case(extop)
            2'b00:
                begin
                    Imm32 = {16'b0,Imm16};
                end
            2'b01:
                begin
                    if(Imm16[15]==1)
						Imm32 = {16'b1111_1111_1111_1111,Imm16[15:0]};
					else 
                        Imm32 = {16'b0000_0000_0000_0000,Imm16[15:0]};
                end
            2'b10:
                begin
                    Imm32 = {Imm16[15:0],16'b0000_0000_0000_0000};
                end
            default:
                begin
                    Imm32 = 32'b0;
                end
        endcase
    end
endmodule