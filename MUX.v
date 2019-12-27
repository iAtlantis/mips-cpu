/*
    mux主要功能是多路选择器。mux包含二选一、四选一多路选择器。
    信号名	方向	描述
    d0、d1、d2...	I	供选择数据（d0、d1）
    s	I	片选信号
    y	O	片选后的数据
*/
`timescale 1ns / 1ns
module MUX_2
        (
            input [31:0]d0,
				input [31:0]d1,
            input s,            //片选信号
            output reg [31:0]dout       //片选后的数据
        );

        always @(s)begin
				dout = s ? d1 : d0;
		  end

endmodule


module MUX_3
        (
            input [31:0]d0,
				input [31:0]d1,
            input [31:0]d2,
            input [1:0] s,      			//片选信号
            output reg [31:0]dout       //片选后的数据
        );

        always @(s) begin
            case(s)
                2'b00:
                begin
                    dout = d0;
                end
                2'b01:
                begin
                    dout = d1;
                end
                2'b10:
                begin
                    dout = d2;
                end
                default:
                    dout = 1'bz;
            endcase
            
        end

endmodule


module MUX_4
        (
            input [31:0]d0,input [31:0]d1,
            input [31:0]d2,input [31:0]d3,
            input [1:0] s,      //片选信号
            output reg [31:0]dout      //片选后的数据
        );

        always @(s) begin
            case(s)
                2'b00:
                begin
                    dout = d0;
                end
                2'b01:
                begin
                    dout = d1;
                end
                2'b10:
                begin
                    dout = d2;
                end
                2'b11:
                begin
                    dout = d3;
                end
                default:
                    dout = 1'bz;
            endcase
            
        end

endmodule

