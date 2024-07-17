module CarParkingSystem (
  input entrance1,
  input entrance2,
  input exit,
  input clock,
  input reset,
  input [3:0] password_input,
  output reg gate
);

parameter s0 = 2'b00, s1 = 2'b01, s2 = 2'b10, s3 = 2'b11;

reg [1:0] current_state, next_state;

parameter [3:0] correct_password = 4'b1010;

always @(posedge clock or posedge reset) begin
  if (reset) begin
    current_state <= s0;
    gate <= 0;
  end 
  
  else begin
  current_state <= next_state;
  end
end
  
always@(*) begin  
    case (current_state)
      
      s0: begin
        if (entrance1==1 && entrance2==0 && exit==0) 
        	next_state = s1;
        else
        	next_state = s0;
      end
      
      s1: begin
        if (entrance1==1 && password_input==correct_password && entrance2==0 && exit==0) 
        	next_state = s1;
        else if (entrance1==0 && entrance2==0 && exit==0) 
        	next_state = s0;
        else if (password_input==correct_password && entrance2==1 && exit==0) 
		      next_state = s2;
      end
      
      s2: begin
        if (password_input==correct_password && entrance2==0 && exit==1) 
         next_state = s3;
      end
      
      s3: begin
        if (password_input==correct_password && entrance2==0 && exit==0)
        	next_state = s0;
      end
     
      default: 
      	next_state = s0;
    endcase
  end
  
always@(next_state) begin
    case(next_state)
      s2: gate = 1;
      s3: gate = 1;
      default: gate = 0;
    endcase
  end
endmodule