
module sevenseg
(
	input              clk1,
	input       [3:0]  digit0,
	input       [3:0]  digit1,
	input       [3:0]  digit2,
	input       [3:0]  digit3,
	input       [1:0]  decplace,
	output reg  [6:0]  seg1,
	output reg  [3:0]  an1
);

reg   [1:0]  cnt;
reg   [3:0]   digit;
initial begin
  cnt = 2'b0;  //anoda na 0
end
// Anode
always @(cnt[16:15]) begin	//switch za prikazivanje sekundi i minuta
	case (cnt[1:0])
		2'b11:   an1 <= 4'b1110;
		2'b10:   an1 <= 4'b1101;
		2'b01:   an1 <= 4'b1011;
		default: an1 <= 4'b0111;
	endcase
end
// Cathode
always @(cnt[1:0] or digit0 or digit1 or digit2 or digit3) begin //swich digit na preko anode pri promeni cnt
	case (cnt[1:0])
		2'b00:   digit <= digit0;
		2'b01:   digit <= digit1;
		2'b10:   digit <= digit2;
		default: digit <= digit3;
	endcase

	case (digit)
		4'h0:    seg1 <= 7'b1000000;
		4'h1:    seg1 <= 7'b1111001;
		4'h2:    seg1 <= 7'b0100100;
		4'h3:    seg1 <= 7'b0110000;
		4'h4:    seg1 <= 7'b0011001;
		4'h5:    seg1 <= 7'b0010010;
		4'h6:    seg1 <= 7'b0000010;
		4'h7:    seg1 <= 7'b1111000;
		4'h8:    seg1 <= 7'b0000000;
		4'h9:    seg1 <= 7'b0010000;
		default: seg1 <= 7'b1111111; //na pocetku svi ugaseni
	endcase
end


always @(posedge clk1) begin
	if(cnt[1:0] == 2'b11)	//if overflow resetuj ga
		cnt[1:0]<=2'b00;
	else
		cnt <= cnt + 1;
end

endmodule