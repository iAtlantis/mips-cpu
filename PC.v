/* 
    PC是指令计数器，主要功能是完成输出当前指令地址并 保存下一条指令地址。
    复位后，PC 指向 0x0000_3000，此处为第一条指令的 地址。
*/
`timescale 1ns / 1ns
module PC(	
			input [31:0] npc,		//NextPC计算单元
            input pcwr,             //PC写使能信号
			input clk,				//时钟信号
			input rst,			    //复位信号
			output reg [31:0] pc	//输出下一条指令的地址
		);
		
	initial
		begin
			pc <= 32'h00003000;		//PC初值为0x0000_3000
		end
		
	always@(posedge clk, posedge reset, negedge pcwr)//任何一个变动都可以触发
		begin
			if(pcwr==1'b1)          //1：允许NPC写入PC内部寄存器
				begin
					if(rst) pc <= 32'h00003000;//PC复位后初值为0x0000_3000
					else pc <= npc;
					//$display($time,,"(PC)NextPcAddr%b",pc);
				end
		end
endmodule