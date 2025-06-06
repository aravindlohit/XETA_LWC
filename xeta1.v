module xeta_1 #(
    parameter w = 16
)(
    input  wire [w-1:0] K_i, M1, M2,
    input  wire ldj, enj, write_Ki, write_M, cycle_num,
    input  wire reset1, clock, enV0, enV1, en_sum, en_c,
    input  wire [1:0] i,
    output reg  zj,
    output reg  [2*w-1:0] C
);

// Internal signals
reg  [w-1:0] MU1, MU2, M11, M22, sum21;
reg  [w-1:0] V0, V1, W1, W2, W3, WX, Wadd, Wf1, V011, V022;
reg  [w-1:0] sum, sum1a, sumadd, sumr, Wf2;
reg  [w-1:0] zero = 0;
reg  [1:0] sum11, sum22;
reg  [31:0] C_1;
reg  [1:0] a1, a2;

// RAM instance
wire [w-1:0] ram_dout;
reg  [1:0] ram_addr;
reg        ram_we;
reg  [w-1:0] ram_din;

ram_xeta ram_inst (
    .clk(clock),
    .we(ram_we),
    .addr(ram_addr),
    .Din(ram_din),
    .dout(ram_dout)
);

// a1, a2 selection
always @(*) begin
    a1 = (cycle_num == 1'b0) ? sum11 : sum22;
    a2 = (write_Ki == 1'b0) ? a1 : i;
end

assign M11 = M1;
assign M22 = M2;

// Registers
always @(posedge clock) begin
    if (enV0)
        V0 <= MU1;
end

always @(posedge clock) begin
    if (enV1)
        V1 <= MU2;
end

always @(*) begin
    W1 = (cycle_num == 1'b0) ? V1 : V0;
    W2 = W1 << 4;
    W3 = W1 >> 5;
    WX = W2 ^ W3;
end

always @(*) begin
    if (write_M == 1'b1)
        sum = zero;
end

always @(posedge clock) begin
    if (en_sum)
        sum1a <= sum;
end

always @(*) begin
    sum21 = sum1a + ram_dout;
    sum11 = sum1a[1:0];
    sum22 = sum1a[w-1:w-2];
    Wf1 = W1 + WX;
    Wf2 = (cycle_num == 1'b0) ? V0 : V1;
    V011 = sum21 ^ Wf1;
    V022 = V011 + Wf2;
    MU1 = (write_M == 1'b0) ? M1 : V011;
    MU2 = (write_M == 1'b0) ? M2 : V011;
    C_1 = {V0, V022};
end

always @(posedge clock or posedge reset1) begin
    if (reset1)
        C <= 0;
    else if (en_c)
        C <= C_1;
end

// xeta_count instance
xeta_count xeta_count_inst (
    .clk(clock),
    .load(ldj),
    .en(enj),
    .D(3'b000),
    .jm1(zj)
);

endmodule
