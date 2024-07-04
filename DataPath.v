`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2023 08:35:12 PM
// Design Name: 
// Module Name: DataPath
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module datapath (
    input clk,
    input pcre,pcwe,npcre,npcwe,regbwe,regbre1,regbre2,sgen,alumux1sel,alumux2sel,aluoutre,aluoutwe,Are,Awe,Bre,Bwe,dmemwe,lmdre,lmdwe,reginmuxsel,irwe,
    input [1:0] immmuxsel,
    input[2:0] cond,
    input [3:0] alusel,
    output [31:0] dpout,
    input [1:0] incdec,
    input swap,select
);
    wire [4:0] rd1,rd2,wr;
    wire flag;
    wire [31:0] pcdatout,npcout,pcplus4,irout,inst,regbdata_out1,regbdata_out2,sg1out,sg2out,sg3out,sg4out,siexval,alumux1out,alumux2out,aluresult,aluoutout,Aout,Bout,dmemout,pcdatin,lmdout,regbdata_in,pcin;
    CheckReg pc(clk,pcre,pcwe,pcdatin,pcdatout);
    incr pcp4(pcdatout,pcplus4);
    CheckReg npc(clk,npcre,npcwe,pcplus4,npcout);
    instrMem imem(pcdatout,inst);
    assign dpout = inst;
    CheckReg ir(clk,1'b1,irwe,inst,irout);
    regdecoder rd(irout,rd1,rd2,wr);
    regBank regb(clk,rd1,rd2,wr,regbdata_in,regbwe,regbre1,regbre2,regbdata_out1,regbdata_out2,incdec);
    CheckReg A(clk,Are,Awe,regbdata_out1,Aout);
    CheckReg B(clk,Bre,Bwe,regbdata_out2,Bout);
    signextend1 sg1(irout[17:4],sgen,sg1out);
    signextend2 sg2(irout[27:0],sgen,sg2out);
    signextend3 sg3(irout[12:4],sgen,sg3out);
    signextend4 sg4(irout[22:4],sgen,sg4out);
    Mux4_1 immmux(sg1out,sg2out,sg3out,sg4out,immmuxsel,siexval);
    Mux2_1 alumux1(Aout,npcout,alumux1sel,alumux1out);
    Mux2_1 alumux2(Bout,siexval,alumux2sel,alumux2out);
    ALU alu(alumux1out,alumux2out,alusel,1'b1,aluresult);
    CheckReg aluout(clk,aluoutre,aluoutwe,aluresult,aluoutout);
    dataMem dmem(aluoutout,Bout,dmemwe,dmemout,swap);
    CheckReg LMD(clk,lmdre,lmdwe,dmemout,lmdout);
    conditionb cdb(Aout,cond,flag);
    Mux2_1 pcmux(npcout,aluoutout,flag,pcin);
    pcselect selector(lmdout,pcin,select,pcdatin);
    Mux2_1 reginmux(lmdout,aluoutout,reginmuxsel,regbdata_in);
    initial begin
        $dumpfile("datapath.vcd");
        $dumpvars(0, datapath);
    end
endmodule
