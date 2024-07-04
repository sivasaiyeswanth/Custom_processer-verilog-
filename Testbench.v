`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:55:59 10/10/2018 
// Design Name: 
// Module Name:    ControlUnit 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
///////////////////////////////////////////////
module testbench;
    reg clk;
    reg enable,reset;
    wire [31:0] a;
    topmodule siva(clk,enable,reset,a);
    initial begin
        clk = 0;
        enable = 1;
        forever #5 clk <= ~clk;
    end
    initial begin
         #4 enable = 1;
         #2 enable = 0;
         #98 enable = 1;
         #3 enable = 0;
         #98 enable = 1;
         #3 enable = 0;
         #96 enable = 1;
         #3 enable = 0;
         #90 enable = 1;
         #3 enable = 0;
         #92 enable = 1;
         #3 enable = 0;
        #1100 $finish;
    end

endmodule