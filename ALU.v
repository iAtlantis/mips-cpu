/*
    ALU主要功能是完成对输入数据的算数逻辑计算，包括加法、
    减法、按位或运算以及判断两个操作数是否相等
     ALUOp:
        0000	直接赋值	C A
        0101	加	C  A + B
        0110	减	C  A – B
        0001	与	C  A & B
        0010	或	C  A | B
        0100	异或	C  A ^ B
        0011	取反	C   not  A
        0111	加一	C   A+1
        1000	减一	C   A-1
        1001	输出清零	C    0
        1010	或非(扩展)	Zero   (A<B) ?  1  :  0
*/
`timescale 1ns / 1ns
module ALU//TODO
        (
            input [31:0] A,     //操作数A
            input [31:0] B,     //操作数B
            input [3:0] aluop,  //运算操作数
            output zero,    //两操作数是否相等
            output reg [31:0] C    //运算结果
        );

        integer overflow = 1'h0;

        always@(aluop)
        begin
            case(aluop)
                4'b0000://  直接赋值  C A
                    begin
                        C = ($signed(A)<$signed(B))?32'h00000000:32'h00000001;
                    end
                4'b0101://  加  C  A + B
                    begin
                        C = A + B;
                        //溢出判断
                        if ((A[31]==1'h0&&B[31]==1'h0&&C[31]==1'h1) || (A[31]==1'h1&&B[31]==1'h1&&C[31]==1'h0))
                            overflow=1'h1;
                        else 
                            overflow=1'h0;
                    end
                4'b0110://  减  C  A - B
                    begin
                        C = A - B;
                    end
                4'b0001://  与  C  A & B
                    begin
                        C = A & B;
                    end
                4'b0010://	或	C  A | B
                    begin
                        C = A | B;
                    end
                4'b0100://	异或	C  A ^ B
                    begin
                        C = A ^ B;
                    end
                4'b0011://	取反	C   not  A
                    begin
                        C = ~ A;
                    end
                4'b0111://	加一	C   A+1
                    begin
                        C = A + 1;
                        if(A[31]==1'h0&&C[31]==1'h1)
                            overflow = 1'h1;
                        else
                            overflow = 1'h0;
                    end
                4'b1000://	减一	C   A-1
                    begin
                        C = A - 1;
                        if(A[31]==1'h1&&C[31]==1'h0)
                            overflow = 1'h1;
                        else
                            overflow = 1'h0;
                    end
                4'b1001://	输出清零	C    0
                    begin
                        C = 32'h00000000;
                    end
//                4'b1010://	或非(扩展)	Zero   (A<B) ?  1  :  0
//                    begin
//                        zero = (A < B) ? 1'h1 : 1'h0;
//                    end
                default:
                    C = 32'h00000000;
            endcase
        end
		  
		  assign zero = (A==B) ? 1 : 0;


endmodule