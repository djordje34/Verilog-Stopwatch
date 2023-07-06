
module Stopwatch (
  input         clk,
  input         btn,
  output [6:0]  seg,
  output [3:0]  an
);

  reg  [27:0]  counter;	//gl. brojac
  reg  [3:0]   sec0;
  reg  [3:0]   sec1;
  reg  [3:0]   min0;
  reg  [3:0]   min1;
  reg          counting;	//bool 

  initial begin	//init vals za registre
    counter = 0;
    sec0 = 0;
    sec1 = 0;
    min0 = 0;
    min1 = 0;
    counting = 0;
  end

  sevenseg sevenseg0 (
    .clk1      (clk),
    .digit0    (min1),
    .digit1    (min0),
    .digit2    (sec1),
    .digit3    (sec0),
    .seg1      (seg),
    .an1       (an)
  );


  always @(posedge btn) begin
    counting <= ~counting;	//flip za ctr
  end

  always @(posedge clk) begin	//svaki posedge ctr+=1 -> time+=1 na svakih 100
    if (counting == 1'b1) begin
      counter <= counter + 1;
      if (counter == 100) begin	//clk period 10 -> ctr update  na 1000ps (1ns) sec+=1
        counter <= 1;
        sec0 <= sec0 + 1;
      end

      if (sec0 == 4'hA) begin
        sec1 <= sec1 + 1;
        sec0 <= 0;
      end

      if (sec1 == 4'h6) begin
        min0 <= min0 + 1;
        sec1 <= 0;
      end

      if (min0 == 4'hA) begin
        min1 <= min1 + 1;
        min0 <= 0;
      end

      if (min1 == 4'h6) min1 <= 0;
    end
  end

endmodule
/*
Umesto sekundi koristi se nanosekunda zbog testbencha i ogranicenja.
*/
module Stopwatch_Testbench;
  reg clk;
  reg btn;
  wire [6:0] seg;
  reg [27:0] counter;
  reg  [3:0]   seco0;
  reg  [3:0]   seco1;
  reg  [3:0]   mino0;
  reg  [3:0]   mino1;
  reg  [1:0]  ctro;
reg[3:0] an1o;
  Stopwatch dut (
    .clk (clk),
    .btn (btn),
    .seg (seg)
  );

  always begin
    #5 clk = ~clk; //10ps period clk
  end

  initial begin
    clk = 0;
    btn = 0;
    #10 btn = 1;
    #50 btn = 0;
    #121000;	//runtime 61ns (int32 ne dozvoljava >2147483647) dovoljno da prikaze rad sec0 sec1 min0 (i min1)
    $finish;
  end

  always @(posedge clk) begin	//output check vrednosti
    counter <= dut.counter;
    seco0<=dut.sec0;
    seco1<=dut.sec1;
    mino0<=dut.min0;
    mino1<=dut.min1;
    ctro <=dut.sevenseg0.cnt;
    an1o <=dut.sevenseg0.an1;
  end

endmodule