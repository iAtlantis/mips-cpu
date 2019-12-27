/*
    DR、A、B、ALUOut由Datalate模块实例化，主要功能是数据缓冲，由带复位的D触发器构成。
    1	数据复位	if rst=1, q0
    2	数据缓冲	if rst=0, qd
*/
`timescale 1ns / 1ns
module DL
        (
            input [31:0] din,         //输入数据
            input rst,              //复位信号
            input clk,              //时钟信号
            output reg [31:0] dout    //输出数据
        );


        always@(posedge clk,posedge rst)
            begin
                if(rst == 0)
                    dout = din;
                else
                    dout = 32'h00000000;
            end

endmodule