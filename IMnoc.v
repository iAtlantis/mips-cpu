/*
    IMnoc是指令存储器，主要功能是根据读控制信号DMWr，读写对应addr地址的32位数据
    
    1	读指令存储器	输出地址所对应的指令，q imem[address]
*/
`timescale 1ns /  1ns
module IMnoc
        (
            input dmwr,             //读控制信号
            input [11:2] address,   //访问地址
            output reg [31:0] dout     //读出的指令
        );
        
        //输出地址所对应的指令，q <- imem[address]
        reg [31:0] imem [1023:0];
        initial begin
            dout = 32'h00000000;
            $readmemb("/Download/Computer/mips/test.txt",imem);//打开文件
        end

        always@(address or dmwr)
            begin
                if(dmwr == 1)begin
                    dout = imem[address];
                end
            end

endmodule