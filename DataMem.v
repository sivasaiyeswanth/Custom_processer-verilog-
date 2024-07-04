`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2023 08:31:41 PM
// Design Name: 
// Module Name: DataMem
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

module dataMem(input [31:0] addr,input [31:0] dat_in,input we,output [31:0] dat_out,input swap);
    reg [7:0] mem [0:1073741824];
    initial begin
        //$readmemh("dataMem.txt",mem);
    end
    always @(addr or dat_in or we) begin
        if(we) begin 
            if(swap == 1'b1) begin
                mem[dat_in] <= addr[31:24];
                mem[dat_in+1] <= addr[23:16];
                mem[dat_in+2] <= addr[15:8];
                mem[dat_in+3] <= addr[7:0];
               
            end
            else begin
                mem[addr] <= dat_in[31:24];
                mem[addr+1] <= dat_in[23:16];
                mem[addr+2] <= dat_in[15:8];
                mem[addr+3] <= dat_in[7:0];
            end
        end
    end
    assign dat_out = {{mem[addr],mem[addr+1]},{mem[addr+2],mem[addr+3]}};
endmodule

