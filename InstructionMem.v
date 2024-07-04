`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2023 08:29:18 PM
// Design Name: 
// Module Name: InstructionMem
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


module instrMem(input [31:0] addr,output [31:0] dat_out);
    reg [7:0] mem [0:1500];
    initial begin
        //$readmemh("instrMem.txt",mem);
        mem[0] = 8'b00010000;
        mem[1] = 8'b00000100;
        mem[2] = 8'b00000000;
        mem[3] = 8'b00010000;
        mem[4] = 8'b00000000;
        mem[5] = 8'b10000100;
        mem[6] = 8'b01000000;
        mem[7] = 8'b00000000;
        mem[8] = 8'b00100000;
        mem[9] = 8'b10001000;
        mem[10] = 8'b00000000;
        mem[11] = 8'b01100001;
        mem[12] = 8'b00100000;
        mem[13] = 8'b10001100;
        mem[14] = 8'b00000000;
        mem[15] = 8'b01100000;
        mem[16] = 8'b01100000;
        mem[17] = 8'b00000000;
        mem[18] = 8'b00000000;
        mem[19] = 8'b00000001;
        mem[20] = 8'b00110000;
        mem[21] = 8'b00000000;
        mem[22] = 8'b00000000;
        mem[23] = 8'b00000100;
        mem[24] = 8'b10000001;
        mem[25] = 8'b00010000;
        mem[26] = 8'b00000000;
        mem[27] = 8'b00000000;
        mem[28] = 8'b01010010;
        mem[29] = 8'b00000000;
        mem[30] = 8'b00000000;
        mem[31] = 8'b00000000;
        mem[32] = 8'b01010010;
        mem[33] = 8'b10000000;
        mem[34] = 8'b00000000;
        mem[35] = 8'b00000001;
        mem[36] = 8'b01110000;
        mem[37] = 8'b00000000;
        mem[38] = 8'b00000000;
        mem[39] = 8'b00000000;
        mem[40] = 8'b10100001;
        mem[41] = 8'b00011000;
        mem[42] = 8'b00000000;
        mem[43] = 8'b00000000;
        mem[44] = 8'b10000001;
        mem[45] = 8'b00011000;
        mem[46] = 8'b00000000;
        mem[47] = 8'b00000000;
    end
    assign dat_out = {mem[addr],mem[addr+1],mem[addr+2],mem[addr+3]};
endmodule
