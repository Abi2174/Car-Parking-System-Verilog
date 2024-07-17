module CarParkingSystem_TB;

  // Inputs
  reg entrance1;
  reg entrance2;
  reg exit;
  reg clock;
  reg reset;
  reg [3:0] password_input;

  // Outputs
  wire gate;

  CarParkingSystem uut (
    .entrance1(entrance1),
    .entrance2(entrance2),
    .exit(exit),
    .clock(clock),
    .reset(reset),
    .password_input(password_input),
    .gate(gate)
  );

  always begin
    #5 clock = ~clock;
  end

  initial begin
    $dumpfile("CarParkingSystem.vcd");
    $dumpvars(0, CarParkingSystem_TB);
    entrance1 = 0;
    entrance2 = 0;
    exit = 0;
    clock = 0;
    reset = 0;
    password_input = 4'b0000;

    //s0
    #10 entrance1 = 1;//s1
    #10 entrance1 = 0;//s0
    #10 entrance1 = 1;//s1
    
    #10 password_input = 4'b1110; // incorrect password s1
    #10 password_input = 4'b1010; // correct password s1
    #10 entrance2 = 1; //s2, gate=1
    #10 entrance2 = 0; exit = 1; //s3
    #10 exit = 0; //s0, gate=0
    //second car waiting s1
    #10 password_input = 4'b1000; //incorrect password s1
    #10 password_input = 4'b1010; entrance2=1; //correct password s2, gate=1
    #10 reset=1;//s0, gate=0

    $monitor("time=%0d, reset=%b, entrance1=%b, entrance2=%b, exit=%b, password_input=%b, gate=%b", $time, reset, entrance1, entrance2, exit, password_input, gate);

    #200 $finish;
    
  end

endmodule
