`timescale 1ns / 1ps
module ADD (
    input [31:0] a,
    input [31:0] b,
    output [32:0] sum
);
    assign sum = a + b;
endmodule

module SUB (
    input [31:0] a,
    input [31:0] b,
    output [32:0] diff
);
    assign diff = a - b;
endmodule

module AND (
    input [31:0] a,
    input [31:0] b,
    output [31:0] res
);
    assign res = a & b;
endmodule

module OR (
    input [31:0] a,
    input [31:0] b,
    output [31:0] res
);
    assign res = a | b;
endmodule

module XOR (
    input [31:0] a,
    input [31:0] b,
    output [31:0] res
);
    assign res = a ^ b;
endmodule

module NOT (
    input [31:0] a,
    output [31:0] res
);
    assign res = ~a;
    
endmodule

module SLA (
    input [31:0] a,
    input  b,
    output [31:0] res
);
    assign res = a << b;
endmodule

module SRA (
    input [31:0] a,
    input  b,
    output [31:0] res
);
    wire [31:0] y,resu;
    assign y = a;
    assign resu = y >> b;
    assign res = {a[31],resu[30:0]};
endmodule

module SRL (
    input [31:0] a,
    input  b,
    output [31:0] res
);
    assign res = a >> b;
endmodule


module ALU (
    input [31:0] a,
    input [31:0] b,
    input [3:0] opcode,
    input en,
    output reg [31:0] res
);
    wire [31:0] ano,oro,xoo,noo,slao,srao,srlo;
    reg overflowFlag,zeroFlag;
    wire [32:0] ado,suo;
    ADD func1(a,b,ado);
    SUB func2(a,b,suo);
    AND func3(a,b,ano);
    OR func4(a,b,oro);
    XOR func5(a,b,xoo);
    NOT func6(a,noo);
    SLA func7(a,b[0],slao);
    SRA func8(a,b[0],srao);
    SRL func9(a,b[0],srlo);
    always @(*) begin
        if(en) begin
            overflowFlag = 1'b0;
        case(opcode)
            4'b0000: begin
                res <= ado[31:0];
                overflowFlag <= ado[32];
                if(!ado[31:0]) zeroFlag = 1'b1;
                else zeroFlag = 1'b0;
            end
            4'b0001: begin
                res <= suo;
                overflowFlag <= suo[32];
                if(!suo[31:0]) zeroFlag = 1'b1;
                else zeroFlag = 1'b0;
            end
            4'b0010: begin
                res <= ano;
                if(!ano) zeroFlag = 1'b1;
                else zeroFlag = 1'b0;
            end
            4'b0011: begin
                res <= oro;
                if(!oro) zeroFlag = 1'b1;
                else zeroFlag = 1'b0;
            end
            4'b0100: begin
                res <= xoo;
                if(!xoo) zeroFlag = 1'b1;
                else zeroFlag = 1'b0;
            end
            4'b0101: begin
                res <= noo;
                if(!noo) zeroFlag = 1'b1;
                else zeroFlag = 1'b0;
            end
            4'b0110: begin
                res <= slao;
                if(!slao) zeroFlag = 1'b1;
                else zeroFlag = 1'b0;
            end
            4'b0111: begin
                res <= srao;
                if(!srao) zeroFlag = 1'b1;
                else zeroFlag = 1'b0;
            end
            4'b1000: begin
                res <= srlo;
                if(!srlo) zeroFlag = 1'b1;
                else zeroFlag = 1'b0;
            end
            4'b1001: begin
                res <= a + 4;
            end
            4'b1010: begin
                res <= a - 4;
            end
            4'b1011: begin
                res <= a;
            end
            default: begin
                res <= 32'bx;
                zeroFlag <= 1'b0;
            end
        endcase
    end
    end
    
    initial begin
        $dumpfile("ALU.vcd");
        $dumpvars(0, ALU);
    end
endmodule


