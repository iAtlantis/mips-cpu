/*
    DR、A、B、ALUOut由flopr模块实例化，主要功能是数据缓冲，由带复位的D触发器构成。
    1	数据复位	if rst=0, qd
    2	数据缓冲	if rst=1, q0
*/
`timescale 1ns / 1ns
module FLOPR
        (
            input [31:0] d;         //输入数据
            input rst;              //复位信号
            input clk;              //时钟信号
            output reg [31:0] q;    //输出数据
        )


        always@(posedge clk,posedge rst)
            begin
                if(rst==1'b0)
                    q=d;
                else
                    q=32'h00000000;
            end