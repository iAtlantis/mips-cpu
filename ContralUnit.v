/*
    多周期控制器
    定义状cpu周期：
        S0:Fetch    取指令
        S1:DCR/RF   读操作数
        S2:EXE      计算地址
        S3:MR       读存储器
        S4:MemWB    回写
*/
`timescale 1ns / 1ns
module ContralUnit
        (
            input clk,                  //时钟信号
            input rst，                 //复位信号
            input [5:0]op,              //指令格式中的OPCODE域
            input [5:0]funct,           //指令格式中的FUNCT域
            input zero,                 //ALU输出信号 0:ALU两操作数不相等，1:ALU两操作数相等

            output reg B_sel,           //ALU第二操作数的片选信号 0:RT域对应的数据 1:16位立即数通过EXT模块扩张后的数据
            output reg [1:0]RFin_sel,  //RF的写入数据的片选信号
            output reg RFWr,            //RF的写使能信号
            output reg DMWr,            //DM的写使能信号
            output reg [1:0]npcop,      //NPC的模式选择信号
            output reg [1:0]extop,      //EXT的模式选择信号
            output reg [3:0]aluop,      //ALU的运算控制信号
            output reg PCWr,            //PC写使能信号 0:禁止写 1:允许写
            output reg IRWr,            //IR写使能信号 0:禁止写 1:允许写
            output reg [1:0]RFout_sel   //RF的写回寄存器的地址片选信号
        );
        
        //状态周期
        parameter [2:0]Fetch    =3'b000,
                  [2:0]RF       =3'b001,
                  [2:0]EXE      =3'b010,
                  [2:0]MR       =3'b011,
                  [2:0]MemWB    =3'b100;

        //状态数据类型
        parameter [3:0]s0=4'b0000,//读取指令，计算下条指令地址
                  [3:0]s1=4'b0001,//读取操作数，两个操作数存入A B
                  [3:0]s2=4'b0010,//A与EXT运算，结果存入ALUout
                  [3:0]s3=4'b0011,//读取DM，数据存入DR
                  [3:0]s4=4'b0100,//DR写入rt寄存器
                  [3:0]s5=4'b0101,//rt写入DM
                  [3:0]s6=4'b0110,//A与B运算，结果写入ALUout      
                  [3:0]s7=4'b0111,//ALUout结果写回到寄存器
                  [3:0]s8=4'b1000,//比较ALU的A B，npc计算后的地址传入PC
                  [3:0]s9=4'b1001;//PC存入$31，NPC计算后存入PC

        reg [3:0]state,
            [3:0]next_state;

        parameter [5:0]addu_op  =6'b000000,
                  [5:0]subu_op  =6'b000000,
                  [5:0]ori_op   =6'b001101,
                  [5:0]lw_op    =6'b100011,
                  [5:0]sw_op    =6'b101011,
                  [5:0]beq_op   =6'b000100,
                  [5:0]jal_op   =6'b000011;

        parameter   [3:0]_add   =4'b0101//	加	C  A + B
                    [3:0]_sub   =4'b0110//	减	C  A – B
                    [3:0]_and   =4'b0001//	与	C  A & B
                    [3:0]_or    =4'b0010//	或	C  A | B
                    [3:0]_xor   =4'b0100//	异或	C  A ^ B
                    [3:0]_not   =4'b0011//	取反	C   not  A
                    [3:0]_add1  =4'b0111//	加一	C   A+1
                    [3:0]_sub1  =4'b1000//	减一	C   A-1
                    [3:0]_zero  =4'b1001;//输出清零	C    0
        
        parameter [5:0]addu_func=6'b100001,
                  [5:0]subu_func=6'b100011;

        initial begin
            B_sel           =0;             //第二操作数
            RFin_sel        =2'b00;         //片选信号0
            RFWr            =0;             //寄存器写使能
            DMWr            =0；            //数据存储器写使能
            npcop           =2'b11;         //NPC顺序地址
            extop           =2'b11;         //EXT零拓展
            aluop           =4'b1111;       //加法运算
            PCWr            =0;             //PC写使能
            IRWr            =0;             //IR写使能
            RFout_sel       =2'b00;         //片选信号0
        end

        //当前状态转移
        always @(posedge clk) begin
            state <= next_state;
        end

        //下一状态转移
        always@(state or op or funct)
        begin
            case(state)
                S0:
                    begin
                        PCWr=1;
                        IRWr=1;
                        RFWr=0;
                        DMWr=0;
                        npcop=2'b00;
                        next_state=s1;
                    end
                S1:
                    begin
                        PCWr=0;
                        IRWr=0;
                        RFWr=0;
                        DMWr=0;
                        case(op)
                            addu_op:
                                next_state=s6;
                            ori_op:
                            begin
                                extop=2'b00;
                                next_state=s6;
                            end
                            lw_op:
                            begin
                                extop=2'b01;
                                next_state=s2;
                            end
                            sw_op:
                            begin
                                extop=2'b01;
                                next_state=s2;
                            end
                            beq_op:
                                next_state=s8;
                            jal_op:
                                next_state=s9;
                            default:
                                next_state=s0;
                        endcase
                    end
                S2:
                    begin
                        B_sel=1;
                        RFWr=0;
                        aluop=4'b0101;
                        PCWr=0;
                        IRWr=0;
                        DMWr=0;
                        case(op)
                        lw_op:
                            next_state=s3;
                        sw_op:
                            next_state=s5;
                        default:
                            next_state=s0;
                    end
                S3:
                    begin
                        RFWr=0;
                        PCWr=0;
                        IRWr=0;
                        DMWr=0;
                        case(op)
                            lw_op:
                                next_state=s4;
                            default:
                                next_state=s0;
                    end
                S4:
                    begin
                        RFin_sel=2'b01;
                        RFout_sel=2'b01;
                        PCWr=0;
                        IRWr=0;
                        DMWr=0;
                        RFWr=1;
                        next_state=s0;
                    end
                S5:
                    begin
                        RFWr=0;
                        PCWr=0;
                        IRWr=0;
                        DMWr=1;
                        next_state=s0;
                    end
                S6:
                    begin
                        RFWr=0;
                        PCWr=0;
                        IRWr=0;
                        DMWr=0;
                        case(op)
                            addu_op:
                            begin
                                B_sel=0;
                                case(funct)
                                    addu_func:
                                        aluop=_add;
                                    subu_func:
                                        aluop=_sub;
                                endcase
                                next_state=s7;
                            end
                            ori_op:
                            begin
                                B_sel=1;
                                aluop=4'b0001;
                                next_state=s7;
                            end
                            default:
                                next_state=s0;
                        endcase
                    end
                S7:
                    begin
                        RFWr=1;
                        PCWr=0;
                        IRWr=0;
                        DMWr=0;
                        RFin_sel=2'b10;
                        case(op)
                            addu_op:
                                RFout_sel=2'b00;
                            ori_op:
                                RFout_sel=2'b01;
                        endcase
                        next_state=s0;
                    end
                S8:
                    begin
                        RFWr=0;
                        IRWr=0;
                        DMWr=0;
                        PCWr=zero;
                        B_sel=0;
                        npcop=2'b01;
                        aluop=4'b0110;
                        next_state=s0;
                    end
                S9:
                    begin
                        RFWr=1;
                        PCWr=1;
                        IRWr=0;
                        DMWr=0;
                        RFin_sel=2'b00;
                        npcop=2'b10;
                        RFout_sel=2'b10;
                        next_state=s0;
                    end
                default:
                    next_state=s0;
            endcase
        end

        

        

endmodule