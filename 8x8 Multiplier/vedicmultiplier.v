// 2x2 Vedic Multiplier
module vedic2x2 (
    input [1:0] a, b,
    output [3:0] p
);
    wire [3:0] temp;
    
    assign temp[0] = a[0] & b[0];
    assign temp[1] = (a[1] & b[0]) ^ (a[0] & b[1]);
    assign temp[2] = (a[1] & b[0] & a[0] & b[1]) ^ (a[1] & b[1]);
    assign temp[3] = (a[1] & b[0] & a[0] & b[1]) & (a[1] & b[1]);
    
    assign p = temp;
endmodule

// 4x4 Vedic Multiplier
module vedic4x4 (
    input [3:0] a, b,
    output [7:0] p
);
    wire [7:0] q0, q1, q2, q3;
    wire [7:0] temp1, temp2, temp3;

    wire [1:0] aL = a[1:0], aH = a[3:2];
    wire [1:0] bL = b[1:0], bH = b[3:2];

    wire [3:0] m0, m1, m2, m3;

    vedic2x2 v0(aL, bL, m0);
    vedic2x2 v1(aH, bL, m1);
    vedic2x2 v2(aL, bH, m2);
    vedic2x2 v3(aH, bH, m3);

    assign q0 = {4'b0, m0};
    assign q1 = {2'b0, m1, 2'b0};
    assign q2 = {2'b0, m2, 2'b0};
    assign q3 = {m3, 4'b0};

    assign p = q0 + q1 + q2 + q3;
endmodule

// 8x8 Vedic Multiplier
module vedic8x8 (
    input [7:0] a, b,
    output [15:0] p
);
    wire [7:0] m0, m1, m2, m3;
    wire [15:0] q0, q1, q2, q3;

    wire [3:0] aL = a[3:0], aH = a[7:4];
    wire [3:0] bL = b[3:0], bH = b[7:4];

    vedic4x4 v0(aL, bL, m0);
    vedic4x4 v1(aH, bL, m1);
    vedic4x4 v2(aL, bH, m2);
    vedic4x4 v3(aH, bH, m3);

    assign q0 = {8'b0, m0};
    assign q1 = {4'b0, m1, 4'b0};
    assign q2 = {4'b0, m2, 4'b0};
    assign q3 = {m3, 8'b0};

    assign p = q0 + q1 + q2 + q3;
endmodule

module tb_vedic8x8;
    reg [7:0] a, b;
    wire [15:0] p;

    vedic8x8 uut (.a(a), .b(b), .p(p));

    initial begin
        $monitor("a=%b , b=%b  | Product=%b ", a, b, p);

        a = 8'b00001111; b = 8'b00001010; #10;  // 15 * 10 = 150
        a = 8'b00011001; b = 8'b00001100; #10;  // 25 * 12 = 300
        a = 8'b00110010; b = 8'b00110010; #10;  // 50 * 50 = 2500
        a = 8'b01100100; b = 8'b00010100; #10;  // 100 * 20 = 2000
        a = 8'b11111111; b = 8'b11111111; #10;  // 255 * 255 = 65025

        $finish;
    end
endmodule
