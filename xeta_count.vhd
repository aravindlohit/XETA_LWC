module xeta_count(
    input  wire clk,
    input  wire load,
    input  wire en,
    input  wire [2:0] D,
    output reg  jm1
);

reg [2:0] count;

always @(posedge clk) begin
    if (load)
        count <= 3'b000;
    else if (en)
        count <= count + 1;
end

always @(*) begin
    jm1 = (count == 3'b010) ? 1'b1 : 1'b0;
end

endmodule
