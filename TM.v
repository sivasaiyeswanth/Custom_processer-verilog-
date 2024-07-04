`timescale 1ns / 1ps
module signextend1 (
    input [13:0] imm1,
    input en,
    output [31:0] extout
);
    assign extout = imm1[13] ? {18'b111111111111111111,imm1} : {18'd0,imm1};
endmodule

module signextend2 (
    input [27:0] imm2,
    input en,
    output [31:0] extout
);
    assign extout = imm2[27] ? {{2'b11,imm2},{2'b00}} : {{2'd0,imm2},2'b00}; 
endmodule

module signextend3 (
    input [8:0] shamt,
    input en,
    output [31:0] extout
);
    assign extout = shamt[8] ? {23'b11111111111111111111111,shamt} : {23'd0,shamt};
endmodule

module signextend4 (
    input [18:0] shamt1,
    input en,
    output [31:0] extout
);
    assign extout = shamt1[18] ? {11'b11111111111,shamt1,2'd0} : {11'd0,shamt1,2'd0};
endmodule

module pcselect (
    input [31:0] lmdo,npco,
    input select,
    output [31:0] pco
);
    assign pco = (select == 1'b1) ? lmdo : npco;
endmodule



module Mux2_1 (
    input [31:0] in1,
    input [31:0] in2,
    input sel,
    output [31:0] out
);
    assign out = sel ? in2 : in1;
endmodule

module Mux4_1 (
    input [31:0] in1,
    input [31:0] in2,
    input [31:0] in3,
    input [31:0] in4,
    input [1:0] sel,
    output [31:0] out
);
    assign out = (sel == 2'b00) ? in1 : (sel == 2'b01) ? in2 : (sel == 2'b10) ? in3 : in4;
    
endmodule
`timescale 1ns / 1ps
module incr (
    input [31:0] in,
    output [31:0] out
);
    assign out = in + 4;
endmodule


module conditionb (
    input [31:0] val,
    input [2:0] cond,
    output flag
);
    assign flag = (cond == 3'b000) ? 1'b0 : (cond == 3'b001) ? (val[31] ) ? 1'b1 : 1'b0 : (cond == 3'b010) ? (val[31] == 0) ? 1'b1 : 1'b0 : (cond == 3'b011) ? (val == 0 ) ? 1'b1 : 1'b0 : 1'b1;
endmodule

`timescale 1ns / 1ps
module controlunit (
    input clk,
    input en,
    input reset,
    input [31:0] ir,
    output reg pcre,pcwe,npcre,npcwe,regbwe,regbre1,regbre2,sgen,alumux1sel,alumux2sel,aluoutre,aluoutwe,Are,Awe,Bre,Bwe,dmemwe,lmdre,lmdwe,reginmuxsel,irwe,
    output reg [1:0] immmuxsel,
    output reg [3:0] alusel,
    output reg [2:0] cond,
    output reg [1:0] incdec,
    output reg swap,select
);
    reg [3:0] mainstate;
    reg [3:0] substate;
    reg [31:0] irst;
    initial begin
        mainstate = 4'b0000;
        substate = 4'b0000;
    end
    initial begin
        $dumpfile("controlunit.vcd");
        $dumpvars(0, controlunit);
    end
    always @(posedge clk) begin
        if(reset) mainstate <= 4'd0;
        else begin
        case (mainstate)
            4'd0: begin
                if(en) begin
                pcre <= 1;
                npcwe <= 1;
                irwe <= 1;
                mainstate <= 4'd1;
                end
            end 
            4'd1: begin
                pcre <= 1;
                npcwe <= 0;
                irwe <= 0;
                mainstate <= 4'd2;
                select <= 1'd0;
            end
            4'd2: begin
                irst <= ir;
                if(ir[31:28] == 4'b1000) mainstate <= 4'd4;
                else mainstate <= ir[31:28] + 3;
                pcre <= 0;
            end
            4'd3: begin
                case (substate)
                    4'd0: begin
                        regbwe <= 0;
                        regbre1 <= 1;
                        regbre2 <= 1;
                        substate <= 4'd1;
                        sgen <= 1'b1;
                        Awe <= 1;
                        Bwe <= 1;
                        immmuxsel <= 2'b10;
                    end 
                    4'd1: begin
                        regbre1 <= 0;
                        regbre2 <= 0;
                        substate <= 4'd2;
                        Awe <= 0;
                        Bwe <= 0;
                        Are <= 1;
                        Bre <= 1;
                        alumux1sel <= 0;
                        alumux2sel <= 0;
                        alusel <= irst[3:0];
                    end
                    4'd2: begin
                        substate <= 4'd3;
                        aluoutwe <= 1;
                    end
                    4'd3: begin
                        substate <= 4'd4;
                        aluoutwe <= 0;
                        aluoutre <= 1;
                        reginmuxsel <= 1;
                        cond <= 3'b000;
                        npcre <= 1;
                        pcwe <= 1;
                        regbwe <= 1;
                    end
                    4'd4: begin
                        substate <= 4'd0;
                        mainstate <= 4'd0;
                        aluoutre <= 0;
                        reginmuxsel <= 0;
                        cond <= 3'b000;
                        npcre <= 0;
                        pcwe <= 0;
                        regbwe <= 0;
                    end
                    default: 
                    substate <= 4'd0;
                endcase
            end
            4'd4: begin
                case (substate)
                    4'd0: begin
                        regbwe <= 0;
                        regbre1 <= 1;
                        regbre2 <= 0;
                        substate <= 4'd1;
                        sgen <= 1'b1;
                        Awe <= 1;
                        Bwe <= 0;
                        immmuxsel <= 2'b00;
                    end
                    4'd1: begin
                        regbre1 <= 0;
                        substate <= 4'd2;
                        Awe <= 0;
                        Are <= 1;
                        alumux1sel <= 0;
                        alumux2sel <= 1;
                        alusel <= irst[3:0];
                    end
                    4'd2: begin
                        substate <= 4'd3;
                        aluoutwe <= 1;
                    end
                    4'd3: begin
                        substate <= 4'd4;
                        aluoutwe <= 0;
                        aluoutre <= 1;
                        reginmuxsel <= 1;
                        cond <= 3'b000;
                        npcre <= 1;
                        pcwe <= 1;
                        regbwe <= 1;
                    end
                    4'd4: begin
                        substate <= 4'd0;
                        mainstate <= 4'd0;
                        aluoutre <= 0;
                        reginmuxsel <= 0;
                        cond <= 3'b000;
                        npcre <= 0;
                        pcwe <= 0;
                        regbwe <= 0;
                    end
                    default:
                    substate <= 4'd0;
                endcase
            end 
            4'd5 : begin
                case (substate)
                    4'd0: begin
                        regbwe <= 0;
                        regbre1 <= 1;
                        regbre2 <= 1;
                        substate <= 4'd1;
                        sgen <= 1'b1;
                        Awe <= 1;
                        Bwe <= 1;
                        immmuxsel <= 2'b00;
                    end
                    4'd1: begin
                        regbre1 <= 0;
                        regbre2 <= 0;
                        substate <= 4'd2;
                        Awe <= 0;
                        Are <= 1;
                        Bwe <= 0;
                        Bre <= 1;
                        alumux1sel <= 0;
                        alumux2sel <= 1;
                        alusel <= 4'd0;
                    end
                    4'd2: begin
                        substate <= 4'd3;
                        aluoutwe <= 1;
                    end
                    4'd3: begin
                        aluoutwe <= 0;
                        aluoutre <= 1;
                        cond <= 3'b000;
                        npcre <= 1;
                        pcwe <= 1;
                        if(irst[0]==0) begin
                            substate <= 4'd4;
                            lmdwe <= 1'b1;
                            lmdre <= 1'b1;
                            reginmuxsel <= 1'b0;
                        end
                        else begin
                            substate <= 4'd5;
                            dmemwe <= 1'b1;
                        end
                    end
                    4'd4: begin
                        lmdwe <= 1'b0;
                        regbwe <= 1'b1;
                        substate <= 4'd6;
                    end
                    4'd5: begin
                        dmemwe <= 1'b0;
                        regbwe <= 1'b0;
                        substate <= 4'd6;
                    end
                    4'd6: begin
                        substate <= 4'd0;
                        mainstate <= 4'd0;
                        aluoutre <= 0;
                        cond <= 3'b000;
                        npcre <= 0;
                        pcwe <= 0;
                        regbwe <= 0;
                    end
                    default:
                    substate <= 4'd0;
                endcase
            end
            4'd6 : begin
                case (substate)
                    4'd0: begin
                        sgen <= 1'b1;
                        regbwe <= 0;
                        immmuxsel <= 2'b01;
                        substate <= 4'd1;
                        npcre <= 1'b1;
                        alumux1sel <= 1'b1;
                        alumux2sel <= 1'b1;
                        alusel <= 4'd0;
                        aluoutwe <= 1'b1;
                    end 
                    4'd1: begin
                        substate <= 4'd2;
                        aluoutwe <= 0;
                        aluoutre <= 1'b1;
                        cond <= 3'b100;
                        pcwe <= 1'b1;
                        regbwe <= 1'b0;
                    end
                    4'd2: begin
                        substate <= 4'd0;
                        aluoutre <= 0;
                        cond <= 3'b000;
                        npcre <= 0;
                        pcwe <= 0;
                        regbwe <= 0;
                        mainstate <= 4'd0;
                    end
                    default: 
                    substate <= 4'd0;
                endcase
            end
            4'd7: begin
                case (substate)
                    4'd0: begin
                        regbwe <= 0;
                        regbre1 <= 1;
                        regbre2 <= 0;
                        substate <= 4'd1;
                        sgen <= 1'b1;
                        Awe <= 1;
                        Bwe <= 0;
                        immmuxsel <= 2'b11;
                    end
                    4'd1: begin
                        regbre1 <= 0;
                        substate <= 4'd2;
                        npcre <= 1'b1;
                        Awe <= 0;
                        Are <= 1;
                        alumux1sel <= 1;
                        alumux2sel <= 1;
                        alusel <= 4'd0;
                        aluoutwe <= 1'b1;
                        cond <= irst[2:0] + 1;
                    end
                    4'd2: begin
                        substate <= 4'd3;
                        aluoutwe <= 0;
                        aluoutre <= 1'b1;
                        pcwe <= 1'b1;
                        regbwe <= 1'b0;
                    end
                    4'd3: begin
                        substate <= 4'd0;
                        aluoutre <= 0;
                        cond <= 3'b000;
                        npcre <= 0;
                        pcwe <= 0;
                        regbwe <= 0;
                        mainstate <= 4'd0;
                    end
                    default: 
                    substate <= 4'd0;
                endcase
            end
            4'd8: begin
                case (substate)
                    4'd0: begin
                        regbwe <= 0;
                        regbre1 <= 0;
                        regbre2 <= 1;
                        Awe <= 0;
                        Bwe <= 1;
                        if(irst[0] == 1'b0) begin
                        incdec <= 2'b10;
                        substate <= 4'd1;
                        end
                        else begin
                        incdec <= 2'b01;
                        substate <= 4'd2;
                        end
                    end
                    4'd1: begin
                        regbre2 <= 0;
                        substate <= 4'd3;
                        Are <= 1;
                        aluoutwe <= 1'b0;
                        regbre1 <= 1'b1;
                        Awe <= 1'b1;
                        alumux1sel <= 1'b0;
                        alusel <= 4'b1001;
                        incdec <= 2'b00;
                        Bwe <= 1'b0;
                    end
                    4'd3: begin
                        regbre2 <= 0;
                        substate <= 4'd4;
                        Are <= 1;
                        aluoutwe <= 1'b1;
                        regbre1 <= 1'b0;
                        Awe <= 1'b0;
                    end
                    4'd4: begin
                        substate <= 4'd5;
                        aluoutre <= 1'b1;
                        Bre <= 1;
                        dmemwe <= 1'b1;
                        npcre <= 1'b1;
                        pcwe <= 1'b1;
                        cond <= 3'b000;
                    end
                    4'd5: begin
                        substate <= 4'd0;
                        mainstate <= 4'd0;
                        aluoutre <= 0;
                        dmemwe <= 1'b0;
                        npcre <= 0;
                        pcwe <= 0;
                        cond <= 3'b000;
                    end
                    4'd2: begin
                        regbre2 <= 0;
                        substate <= 4'd6;
                        Are <= 1;
                        aluoutwe <= 1'b0;
                        regbre1 <= 1'b1;
                        Awe <= 1'b1;
                        alumux1sel <= 1'b0;
                        alusel <= 4'b1011;
                        incdec <= 2'b00;
                    end
                    4'd6: begin
                        regbre2 <= 0;
                        substate <= 4'd7;
                        Are <= 1;
                        aluoutwe <= 1'b1;
                        regbre1 <= 1'b0;
                        Awe <= 1'b0;
                    end
                    4'd7: begin
                        substate <= 4'd8;
                        aluoutre <= 1'b1;
                        Bre <= 0;
                        //dmemre <= 1'b1;
                        npcre <= 1'b1;
                        pcwe <= 1'b1;
                        cond <= 3'b000;
                        lmdwe <= 1'b1;
                    end
                    4'd8: begin
                        substate <= 4'd9;
                        aluoutre <= 0;
                        //dmemre <= 1'b0;
                        npcre <= 0;
                        pcwe <= 0;
                        cond <= 3'b000;
                        lmdwe <= 1'b0;
                        lmdre <= 1'b1;
                        reginmuxsel <= 1'b0;
                        regbwe <= 1'b1;
                    end
                    4'd9: begin
                        substate <= 4'd0;
                        mainstate <= 4'd0;
                        lmdre <= 1'b0;
                        reginmuxsel <= 1'b0;
                        regbwe <= 1'b0;
                        cond <= 3'b000;
                        npcre <= 0;
                        pcwe <= 0;
                        Bwe <= 0;
                    end
                    default: 
                    substate <= 4'd0;
                endcase
            end
            4'd9: begin
                case (substate)
                    4'd0: begin
                        incdec <= 2'b00;
                        regbwe <= 0;
                        substate <= 4'd1;
                        sgen <= 1'b1;
                        npcre <= 1'b1;
                    end 
                    4'd1: begin
                        substate <= 4'd2;
                        regbre2 <= 1'b1;
                        Awe <= 1;
                        Bwe <= 1;
                        alumux1sel <= 1'b1;
                        alusel <= 4'b1011;
                        Are <= 1'b1;
                        Bre <= 1'b1;
                        incdec <= 2'b00;
                    end
                    4'd2: begin
                        substate <= 4'd3;
                        aluoutwe <= 1'b1;
                        aluoutre <= 1'b1;
                        regbre1 <= 1'b0;
                        Awe <= 1'b0;
                        Bwe <= 1'b0;
                    end
                    4'd3: begin
                        substate <= 4'd4;
                        aluoutwe <= 1'b0;
                        aluoutre <= 1'b1;
                        swap <= 1'b1;
                        dmemwe <= 1'b1;
                    end
                    4'd4: begin
                        substate <= 4'd5;
                        aluoutre <= 1;
                        dmemwe <= 1'b1;
                        swap <= 1'b1;
                        npcre <= 1'b1;
                        pcwe <= 1'b0;
                        cond <= 3'b000;
                    end
                    4'd5: begin
                        swap <= 0;
                        dmemwe <= 0;
                        substate <= 4'd6;
                        npcre <= 1'b1;
                        cond <= 3'b000;
                        sgen <= 1'b1;
                        immmuxsel <= 2'b01;
                        alumux1sel <= 1'b1;
                        alumux2sel <= 1'b1;
                        alusel <= 4'b0000;
                        aluoutwe <= 1'b1;
                        aluoutre <= 1'b1;
                        incdec <= 2'b10;
                    end
                    4'd6: begin
                        substate <= 4'd7;
                        aluoutwe <= 1'b0;
                        aluoutre <= 1'b1;
                        Awe <= 1'b0;
                        Bwe <= 1'b0;
                        cond <= 3'b100;
                        regbwe <= 1'b0;
                        pcwe <= 1'b1;
                        incdec <= 2'b00;
                    end
                    4'd7: begin
                        substate <= 4'd0;
                        aluoutre <= 0;
                        cond <= 3'b000;
                        npcre <= 0;
                        pcwe <= 0;
                        regbwe <= 0;
                        mainstate <= 4'd0;
                    end
                    default:
                    substate <= 4'd0; 
                endcase
            end
            4'd10: begin
                case (substate)
                    4'd0: begin
                        substate <= 4'd1;
                        regbre1 <= 1'b1;
                        Awe <= 1'b1;
                        Are <= 1'b1;
                        alumux1sel <= 1'b0;
                        alusel <= 4'b1001;
                        incdec <= 2'b00;
                    end
                    4'd1: begin
                        substate <= 4'd2;
                        aluoutwe <= 1'b1;
                        aluoutre <= 1'b1;
                        regbre1 <= 1'b0;
                        Awe <= 1'b0;
                        incdec <= 2'b01;
                    end
                    4'd2: begin
                        substate <= 4'd3;
                        aluoutwe <= 1'b0;
                        aluoutre <= 1'b1;
                        regbre2 <= 1'b0;
                        Bwe <= 1'b0;
                        Bre <= 1'b0;
                        incdec <= 2'b00;
                        lmdwe <= 1'b1;
                    end
                    4'd3: begin
                        substate <= 4'd4;
                        aluoutre <= 0;
                        lmdwe <= 1'b0;
                        lmdre <= 1'b1;
                        reginmuxsel <= 1'b0;
                        regbwe <= 1'b0;
                        select <= 1'b1;
                        cond <= 3'b000;
                        npcre <= 1'b1;
                        pcwe <= 1'b1;
                    end
                    4'd4: begin
                        substate <= 4'd0;
                        mainstate <= 4'd0;
                        lmdre <= 1'b0;
                        select <= 1'b0;
                        pcwe <= 0;
                    end
                    default: 
                    substate <= 4'd0;
                endcase
            end
            4'd12: begin
                mainstate <= mainstate;
            end
            4'd13: begin
                case (substate)
                    4'd0: begin
                        cond <= 3'b000;
                        npcre <= 1'b1;
                        pcwe <= 1'b1;
                        substate <= 4'd1;
                    end 
                    4'd1: begin
                        substate <= 0;
                        mainstate <= 0;
                        npcre <= 0;
                        pcwe <= 0;
                    end
                    default: 
                    substate <= 4'd0;
                endcase
            end
        endcase
    end
    end
endmodule
`timescale 1ns / 1ps
module topmodule (
    input clk,
    input en,reset,
    output [31:0] dpout
);
    wire pcre,pcwe,npcre,npcwe,regbwe,regbre1,regbre2,sgen,alumux1sel,alumux2sel,aluoutre,aluoutwe,Are,Awe,Bre,Bwe,dmemwe,lmdre,lmdwe,reginmuxsel,swap,select;
    wire [1:0] immmuxsel,incdec;
    wire [3:0] alusel;
    wire [2:0] cond;
    wire [31:0] ir;
    controlunit cu(clk,en,reset,ir,pcre,pcwe,npcre,npcwe,regbwe,regbre1,regbre2,sgen,alumux1sel,alumux2sel,aluoutre,aluoutwe,Are,Awe,Bre,Bwe,dmemwe,lmdre,lmdwe,reginmuxsel,irwe,immmuxsel,alusel,cond,incdec,swap,select);
    datapath dp(clk,pcre,pcwe,npcre,npcwe,regbwe,regbre1,regbre2,sgen,alumux1sel,alumux2sel,aluoutre,aluoutwe,Are,Awe,Bre,Bwe,dmemwe,lmdre,lmdwe,reginmuxsel,irwe,immmuxsel,cond,alusel,ir,incdec,swap,select);
    assign dpout = ir;
    initial begin
        $dumpfile("topmodule.vcd");
        $dumpvars(0, topmodule);
    end
endmodule
