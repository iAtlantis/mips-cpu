/*
    IMnoc是指令存储器，主要功能是根据读控制信号DMWr，读写对应addr地址的32位数据
    
    1	读指令存储器	输出地址所对应的指令，q imem[address]
*/
`timescale 1ns /  1ns
module IMnoc
        (
            input [11:2] address,   //访问地址
            output reg [31:0] q     //读出的指令
        );
        
        //输出地址所对应的指令，q <- imem[address]
        
endmodule