module ram_xeta #(
    parameter w = 16,
    parameter r = 2
)(
    input  wire              clk,
    input  wire              we,
    input  wire [w-1:0]      Din,
    input  wire [r-1:0]      addr,
    output wire [w-1:0]      dout
);

reg [w-1:0] RAM [0:(1<<r)-1];

always @(posedge clk) begin
    if (we)
        RAM[addr] <= Din;
end

assign dout = RAM[addr];

endmodule
