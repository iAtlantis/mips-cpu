/*
    DM是数据存储器，主要功能是根据读写控制信号DMWr，读写对应addr地址的32位数据
    序号	功能名称	功能描述
    1	读存储	clk上升沿时
    输出地址所对应的数据，dout dmem[addr]
    2	写存储	当写使能有效时，将待写数据写入对应地址
    clk上升沿时
    if DMWr then 
        dmem[addr]  din
*/
`timescale 1ns / 1ns
module DM
        (
            input clk,              //时钟信号
            input [31:0] data,      //需要写回的数据
            input wren,             //读写操作的写使能端
            input [11:2] address,   //访问地址
            output reg [31:0] q     //读出的数据
        );

        always@(posedge clk,negedge wren)
        begin
            if(wren==1'b0)
            begin
                //输出地址所对应的数据, dout <- dmen[addr]
                
            end
            else
            begin
                //将待写数据写入对应地址， dmem[addr] <- din

            end
        end

endmodule