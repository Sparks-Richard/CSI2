
`timescale 1ns / 1ps

module iic_reg_init(
	input 	      				clk_i, 
	input						rst_n,
	
	output reg 					wr_rd_flag,	//0 wr -- 1 rd
	output reg 					start_en,
	
	output   	[ 7:0] 			i2c_device_addr,
	output reg	[15:0] 			register,
	output reg  [ 7:0]			data_byte,
	

	input	 					busy,
	input	 					err,
	input						IIC_START,
	output reg					IIC_config_busy
    );
												//register // data_byte

localparam	IIC_REG_COUNT 	= 16'd171;
localparam	I2C_DEVICE_ADDR = 8'b0111_1010;
localparam	I2C_length 		= IIC_REG_COUNT*24 - 4'd1;												
																					
reg [I2C_length :0]	IIC_REG_DATA = {
16'h3014,  8'h05,
16'h3014,  8'h05,
16'h3015,  8'h91,
16'h3016,  8'h50,
16'h3018,  8'h20,
16'h3019,  8'h02,
16'h301B,  8'h1D,
16'h303C,  8'h02,
16'h30D0,  8'h28,
16'h30D1,  8'h0B,
16'h30D2,  8'h28,
16'h30D3,  8'h0B,
16'h30D4,  8'hA8,
16'h30D5,  8'h0B,
16'h30D6,  8'h00,
16'h30D8,  8'h1E,
16'h30D9,  8'h03,
16'h30DC,  8'h01,
16'h30E0,  8'h08,
16'h30E1,  8'h08,
16'h30E2,  8'h04,
16'h30E3,  8'h14,
16'h30E6,  8'h08,
16'h3200,  8'h24,
16'h321C,  8'h40,
16'h321E,  8'hE0,
16'h321F,  8'h00,
16'h3220,  8'h40,
16'h3222,  8'hE0,
16'h3223,  8'h00,
16'h3224,  8'h40,
16'h3226,  8'h80,
16'h3227,  8'hA0,
16'h322B,  8'h06,
16'h3233,  8'h50,
16'h3240,  8'h70,//SHS LSB
16'h3241,  8'h0f,
16'h3242,  8'h00,//SHS MSB
16'h3430,  8'h02,
16'h3444,  8'h01,
16'h3502,  8'h08,
16'h3514,  8'h00,
16'h3515,  8'h00,
16'h3521,  8'h41,
16'h3535,  8'h00,
16'h3542,  8'h27,
16'h3546,  8'h10,
16'h354A,  8'h20,
16'h359C,  8'h0F,
16'h359D,  8'h01,
16'h35A4,  8'h08,
16'h35A5,  8'h12,
16'h35A8,  8'h08,
16'h35A9,  8'h52,
16'h35AC,  8'h42,
16'h35B4,  8'h0F,
16'h35CE,  8'h0E,
16'h35EC,  8'h08,
16'h35ED,  8'h12,
16'h35F0,  8'hFB,
16'h35F1,  8'h0B,
16'h35F2,  8'hFB,
16'h35F3,  8'h0B,
16'h366A,  8'h1B,
16'h3670,  8'hC3,
16'h3672,  8'h05,
16'h3674,  8'hB6,
16'h3675,  8'h01,
16'h3676,  8'h05,
16'h36E8,  8'h1B,
16'h36F5,  8'h0F,
16'h3797,  8'h00,
16'h3904,  8'h00,
16'h3e2E,  8'h07,
16'h3e30,  8'h4E,
16'h3e6E,  8'h07,
16'h3e70,  8'h35,
16'h3e96,  8'h01,
16'h3e9E,  8'h38,
16'h3eA0,  8'h4C,
16'h3f3A,  8'h04,
16'h4056,  8'h23,
16'h4096,  8'h23,
16'h4182,  8'h00,
16'h41A2,  8'h03,
16'h4232,  8'h3C,
16'h4235,  8'h22,
16'h4306,  8'h00,
16'h4307,  8'h00,
16'h4308,  8'h00,
16'h4309,  8'h00,
16'h4310,  8'h04,
16'h4311,  8'h04,
16'h4312,  8'h04,
16'h4313,  8'h04,
16'h433C,  8'h8A,
16'h433D,  8'h02,
16'h433E,  8'hE8,
16'h433F,  8'h05,
16'h4340,  8'h9E,
16'h4341,  8'h0C,
16'h4460,  8'h6C,
16'h4467,  8'h83,
16'h446A,  8'h4C,
16'h446E,  8'h51,
16'h4472,  8'h57,
16'h4476,  8'h79,
16'h448A,  8'h4C,
16'h448E,  8'h51,
16'h4492,  8'h57,
16'h4496,  8'h79,
16'h44EC,  8'h3F,
16'h44F0,  8'h44,
16'h44F4,  8'h4A,
16'h4510,  8'h3F,
16'h4514,  8'h44,
16'h4518,  8'h4A,
16'h4576,  8'hBE,
16'h457A,  8'hB1,
16'h4580,  8'hBC,
16'h4584,  8'hAF,
16'h472E,  8'h06,
16'h472F,  8'h06,
16'h4730,  8'h06,
16'h4731,  8'h06,
16'h473C,  8'h06,
16'h473D,  8'h06,
16'h473E,  8'h06,
16'h473F,  8'h06,
16'h4749,  8'h9F,
16'h474A,  8'h99,
16'h474B,  8'h09,
16'h4753,  8'h90,
16'h4754,  8'h99,
16'h4755,  8'h09,
16'h4788,  8'h04,
16'h4864,  8'hDC,
16'h4868,  8'hDC,
16'h486C,  8'hDC,
16'h4874,  8'hDC,
16'h4878,  8'hDC,
16'h487C,  8'hDC,
16'h48A4,  8'hF4,
16'h48A8,  8'hF4,
16'h48AC,  8'hF4,
16'h48B4,  8'hF4,
16'h48B8,  8'hF4,
16'h48BC,  8'hF4,
16'h4900,  8'h44,
16'h4901,  8'h0A,
16'h4902,  8'h01,
16'h4908,  8'h6E,
16'h4916,  8'h00,
16'h4917,  8'h00,
16'h4918,  8'hFF,
16'h4919,  8'h0F,
16'h491E,  8'hFF,
16'h491F,  8'h0F,
16'h4920,  8'h00,
16'h4921,  8'h00,
16'h4926,  8'hFF,
16'h4927,  8'h0F,
16'h4928,  8'h00,
16'h4929,  8'h00,
16'h4a34,  8'h0A,
16'h3000,  8'h00,
16'h3000,  8'h00,
16'h3000,  8'h00,
16'h3010,  8'h00, //XMASTA
16'h3010,  8'h00, //XMASTA
16'h3010,  8'h00 //XMASTA
// 16'hFFFE,  8'hFF
						};
						
reg [  7:0]	nstate;
reg [  7:0]	cstate;	
reg [I2C_length :0] IIC_REG_DATA_r;



localparam  idle        	=  8'b1111_1110; //fe
localparam  ele_delay  	    =  8'b1111_1101; //fd
localparam  reg_sent	   	=  8'b1111_1011; //fb
localparam  delay	     	=  8'b1111_0111; //f7
localparam  delay_cnt    	=  8'b1110_1111; //ef
//localparam  rd_data_byte  =  8'b1101_1111; //df
//localparam  i2c_over		=  8'b1011_1111; //bf
//localparam  i2c_ack    		=  8'b0111_1111;  //7f
reg [ 15:0] iic_count ;//= IIC_REG_COUNT - 1'b1;
reg			State_turn;
reg [ 15:0] Rec_count;
assign i2c_device_addr = I2C_DEVICE_ADDR;					
always @(*) begin
    case (cstate)
		ele_delay:		nstate <=	(State_turn)				? idle 			: ele_delay;
		idle:			nstate <=	(!busy && iic_count != 0 )	? reg_sent		: idle;
		reg_sent:		nstate <=	delay;
		delay:			nstate <=	(busy)						? delay_cnt		: delay;
		delay_cnt:		nstate <=	(State_turn)				? idle			: delay_cnt;	
	endcase
end	
//	iic_count
always @(posedge clk_i or negedge rst_n) begin
	if(!rst_n) begin
		iic_count = 16'd0;// - 1'b1;
		start_en		<= 1'b0;
		wr_rd_flag		<= 1'b0;
	end
	else if (IIC_START)begin
		iic_count <= IIC_REG_COUNT;
	end
	else begin
		case (nstate)
			reg_sent:	begin
				iic_count <= iic_count - 1'b1;
				start_en		<= 1'b1;
				wr_rd_flag		<= 1'b0;
			end
			ele_delay,idle,delay,delay_cnt:begin
				iic_count <= iic_count;
				start_en		<= 1'b0;
				wr_rd_flag		<= 1'b0;
			end
			idle:begin
				iic_count <= iic_count;	
				start_en		<= 1'b0;
				wr_rd_flag		<= 1'b0;
			end
		endcase 
	end
	//busy state

end
always @(posedge clk_i or negedge rst_n) begin
	if(!rst_n) begin
		IIC_REG_DATA_r <= IIC_REG_DATA;
		register 	<= 16'hffff;
		data_byte   <=  8'hff;
	end
	else begin
		case (nstate)
			reg_sent:	begin
				register 	<= IIC_REG_DATA_r[I2C_length 		 :I2C_length - 8'd15];
				data_byte 	<= IIC_REG_DATA_r[I2C_length - 8'd16 :I2C_length - 8'd23];
				IIC_REG_DATA_r<= { IIC_REG_DATA_r[I2C_length - 8'd24 : 0],IIC_REG_DATA_r[I2C_length : I2C_length - 8'd23]};
			end
			ele_delay,idle,delay,delay_cnt:begin
				IIC_REG_DATA_r <= IIC_REG_DATA_r;
			end
		endcase 
	end
end
always @(posedge clk_i or negedge rst_n) begin
	if(!rst_n) begin
		Rec_count	<= 32'd1000;
		State_turn  <=  1'b0;
	end
	else begin
		case (nstate)
			ele_delay:begin
				if (Rec_count == 32'd1000 - 1'b1) begin
					Rec_count  	<= 32'd0;
					State_turn  <=  1'b1;
				end
				else 							begin
					Rec_count  	<= Rec_count + 1'b1;
					State_turn  <= 1'b0;
				end	
			end
			delay_cnt:begin
				if (Rec_count == 32'd1000 - 1'b1) begin
					Rec_count  	<= 32'd0;
					State_turn  <=  1'b1;
				end
				else 							begin
					Rec_count  	<= Rec_count + 1'b1;
					State_turn  <= 1'b0;
				end	
			end
			idle,delay,reg_sent:begin
				Rec_count	<= 16'd0;
				State_turn 	<=  1'b0;
			end
		endcase
	end
end
always @(posedge clk_i ) begin
	if(iic_count == 16'd0)	begin
		IIC_config_busy<= 1'b0;
	end
	else begin
		IIC_config_busy<= 1'b1; //BUSY
	end
end
always @(posedge clk_i or negedge rst_n) begin
    if(!rst_n)
        cstate <= idle;
    else begin
        cstate <= nstate;
    end
end			
						
	
endmodule
