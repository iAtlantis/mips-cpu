/* 
    PC是指令计数器，主要功能是完成输出当前指令地址并 保存下一条指令地址。
    复位后，PC 指向 0x0000_3000，此处为第一条指令的 地址。
*/
`timescale 1ns / 1ns
module PC(	
			input [31:0] npc,		//NextPC计算单元
         input pcwr,             //PC写使能信号
			input clk,				//时钟信号; now EMPTY WIRE
			input rst,			    //复位信号
			output reg [31:0] pc	//输出下一条指令的地址
		);
		
    parameter base_address = 32'h0000_3000;
	initial
		begin
			pc <= base_address-1;		//PC初值为0x0000_3000
		end
		
//	always@(posedge clk)
//	begin
//        if (pcwr)          //1：允许NPC写入PC内部寄存器
//        begin
//            if (rst) 
//                pc <= base_address;//PC复位后初值为0x0000_3000
//				else if (clk)
//                pc <= npc;
//        end
//	end

	always@(posedge pcwr)
	begin
            if (rst) 
                pc <= base_address;//PC复位后初值为0x0000_3000
				else
                pc <= npc;
	end
	
endmodule