
module regBank (
    input clk,
    input [4:0] rd1,
    input [4:0] rd2,
    input [4:0] wr,
    input [31:0] data_in,
    input we,
    input re1,
    input re2,
    output [31:0] data_out1,
    output [31:0] data_out2,
    input [1:0] incdec
    );
    
    reg [31:0] regi [0:16];
    reg [31:0] temp;
    
    initial begin
        regi[5'd0] <= 32'd0;
        regi[5'd16] <= 32'd900;
        temp <= 32'bz;
    end

    always @(posedge clk) begin
        if(we) begin
            if(wr != 5'd0) regi[wr] <= data_in;
        end
        if(incdec == 2'b01) begin
            regi[5'd16] <= regi[5'd16] + 32'd4;
        end
        else if(incdec == 2'b10) begin
            regi[5'd16] <= regi[5'd16] - 32'd4;
        end
      
      
    end

    assign data_out1 = re1 ? regi[rd1] : temp;
    assign data_out2 = re2 ? regi[rd2] : temp;
    
    initial begin
        $dumpfile("regBank.vcd");
        $dumpvars(0, regBank);
    end
    
endmodule

module CheckReg (
    input clk,
    input re,
    input we,
    input [31:0] data_in,
    output [31:0] data_out
);
    reg [31:0] data;
    reg [31:0] temp;
    initial begin
        data <= 32'b0;
        temp <= 32'bz;
    end
    always @(posedge clk) begin
        if(we) data <= data_in;
    end
    assign data_out = re ? data : temp;
endmodule


module regdecoder (
    input [31:0] ir,
    output [4:0] rd1,
    output [4:0] rd2,
    output [4:0] wr
);
    assign rd1 = (ir[31:28] == 4'b0101 || ir[31:28] == 4'b0111)?5'b10000:ir[27:23];
    assign rd2 = (ir[31:28] == 4'b0110)?5'd16:(ir[31:28] == 4'b0101)?ir[27:23]:ir[22:18];
    assign wr = (ir[31:28] == 0) ? ir[17:13] : (ir[31:28] == 4'b0101)?ir[27:23]:ir[22:18];
endmodule
