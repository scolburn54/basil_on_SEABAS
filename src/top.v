
module top(

CLK_50M, // IN
//SW_RSTn, // IN  // REMOVED THIS SIGNAL BECAUSE NOT IN SEABAS

REFCLK_0p, // OUT
REFCLK_0n, // OUT
CMDDCI_0p, // OUT
CMDDCI_0n, // OUT
DOBOUT_0p, // IN
DOBOUT_0n, // IN

REFCLK_1p, // OUT
REFCLK_1n, // OUT
CMDDCI_1p, // OUT
CMDDCI_1n, // OUT
DOBOUT_1p, // IN
DOBOUT_1n, // IN

REFCLK_2p, // OUT
REFCLK_2n, // OUT
CMDDCI_2p, // OUT
CMDDCI_2n, // OUT
DOBOUT_2p, // IN
DOBOUT_2n, // IN

REFCLK_3p, // OUT
REFCLK_3n, // OUT
CMDDCI_3p, // OUT
CMDDCI_3n, // OUT
DOBOUT_3p, // IN
DOBOUT_3n, // IN

NIM_OUT, //OUT

LED, // OUT
// User I/F
USR_CLK,    // out    : Clock
USR_ACTIVE,    // in    : TCP established
USR_CLOSE_REQ,    // in    : Request to close a TCP Connection
USR_CLOSE_ACK,    // out    : Acknowledge for USR_CLOSE_REQ
// TCP Tx
USR_TX_AFULL,    // in    : Almost full flag of a TCP Tx FIFO
USR_TX_WE,    // out    : TCP Tx Data write enable
USR_TX_WD,    // out    : TCP Tx Data[7:0]
// TCP Rx
USR_RX_EMPTY,    // in    : Empty flag of a TCP RX flag
USR_RX_RE,    // out    : TCP Rx Data Read enable
USR_RX_RV,    // in    : TCP Rx data valid
USR_RX_RD,    // in    : TCP Rx data[7:0]

// Register Access
REG_CLK,    // in    : Clock
REG_ACT,    // in    : Access Active
REG_DI,    // out    : Serial Data Output
REG_DO    // in    : Serial Data Input
);


input CLK_50M;
//input SW_RSTn; // MADE SIGNAL NOT AN INPUT TO MATCH SEABAS

output REFCLK_0p;
output REFCLK_0n;
output CMDDCI_0p;
output CMDDCI_0n;
input DOBOUT_0p;
input DOBOUT_0n;

output REFCLK_1p;
output REFCLK_1n;
output CMDDCI_1p;
output CMDDCI_1n;
input DOBOUT_1p;
input DOBOUT_1n;

output REFCLK_2p;
output REFCLK_2n;
output CMDDCI_2p;
output CMDDCI_2n;
input DOBOUT_2p;
input DOBOUT_2n;

output REFCLK_3p;
output REFCLK_3n;
output CMDDCI_3p;
output CMDDCI_3n;
input DOBOUT_3p;
input DOBOUT_3n;

output [1:0] NIM_OUT;

output   USR_CLK;
input    USR_ACTIVE;
input    USR_CLOSE_REQ;
output   USR_CLOSE_ACK;
input    USR_TX_AFULL;
output   USR_TX_WE;
output   [7:0] USR_TX_WD;
input    USR_RX_EMPTY;
output   USR_RX_RE;
input    USR_RX_RV;
input    [7:0]    USR_RX_RD;
input    REG_CLK;
input    REG_ACT;
output   REG_DI;
input    REG_DO;

output [7:0] LED; 

//=================================================================
//    Input/Output Buffer for LVDS signal
//=================================================================
wire [3:0] DOBOUT;

wire CMD_CLK0;
wire CMD_CLK1;
wire CMD_CLK2;
wire CMD_CLK3;

wire CMD_DATA0;
wire CMD_DATA1;
wire CMD_DATA2;
wire CMD_DATA3;

wire dobout_0_s;
wire dobout_1_s;
wire dobout_2_s;
wire dobout_3_s;

assign DOBOUT[0] = dobout_0_s;
assign DOBOUT[1] = dobout_1_s;
assign DOBOUT[2] = dobout_2_s;
assign DOBOUT[3] = dobout_3_s;

/*
wire CMD_CLK_BUF_OUT;

// CMD_CLK buffer instance
BUFIO BUFIO_inst_cmdClk(
	.O(CMD_CLK_BUF_OUT),
	.I(CMD_CLK)
);

*/

// Input Buffer
IBUFDS #(
    .DIFF_TERM("TRUE")    ,
    .IOSTANDARD("LVDS_25")
) IBUFDS_inst_dobout_0(
    .I(DOBOUT_0p)        , 
    .IB(DOBOUT_0n)    , 
    .O(dobout_0_s)
);

// Output Buffer
OBUFDS #(
    .IOSTANDARD("LVDS_25")
) OBUFDS_inst_refclock_0(
    .I(CMD_CLK0)    , 
    .O(REFCLK_0p)        ,
    .OB(REFCLK_0n)
);

OBUFDS #(
    .IOSTANDARD("LVDS_25")
) OBUFDS_inst_cmd_0(
    .I(CMD_DATA0)    , 
    .O(CMDDCI_0p)    , 
    .OB(CMDDCI_0n)
);



// Input Buffer
IBUFDS #(
    .DIFF_TERM("TRUE")    ,
    .IOSTANDARD("LVDS_25")
) IBUFDS_inst_dobout_1(
    .I(DOBOUT_1p)        , 
    .IB(DOBOUT_1n)    , 
    .O(dobout_1_s)
);



// Output Buffer
OBUFDS #(
    .IOSTANDARD("LVDS_25")
) OBUFDS_inst_refclock_1(
    .I(CMD_CLK1)    , 
    .O(REFCLK_1p)        ,
    .OB(REFCLK_1n)
);

OBUFDS #(
    .IOSTANDARD("LVDS_25")
) OBUFDS_inst_cmd_1(
    .I(CMD_DATA1)    , 
    .O(CMDDCI_1p)    , 
    .OB(CMDDCI_1n)
);



// Input Buffer
IBUFDS #(
    .DIFF_TERM("TRUE")    ,
    .IOSTANDARD("LVDS_25")
) IBUFDS_inst_dobout_2(
    .I(DOBOUT_2p)        , 
    .IB(DOBOUT_2n)    , 
    .O(dobout_2_s)
);



// Output Buffer
OBUFDS #(
    .IOSTANDARD("LVDS_25")
) OBUFDS_inst_refclock_2(
    .I(CMD_CLK2)    , 
    .O(REFCLK_2p)        ,
    .OB(REFCLK_2n)
);

OBUFDS #(
    .IOSTANDARD("LVDS_25")
) OBUFDS_inst_cmd_2(
    .I(CMD_DATA2)    , 
    .O(CMDDCI_2p)    , 
    .OB(CMDDCI_2n)
);



// Input Buffer
IBUFDS #(
    .DIFF_TERM("TRUE")    ,
    .IOSTANDARD("LVDS_25")
) IBUFDS_inst_dobout_3(
    .I(DOBOUT_3p)        , 
    .IB(DOBOUT_3n)    , 
    .O(dobout_3_s)
);



// Output Buffer
OBUFDS #(
    .IOSTANDARD("LVDS_25")
) OBUFDS_inst_refclock_3(
    .I(CMD_CLK3)    , 
    .O(REFCLK_3p)        ,
    .OB(REFCLK_3n)
);

OBUFDS #(
    .IOSTANDARD("LVDS_25")
) OBUFDS_inst_cmd_3(
    .I(CMD_DATA3)    , 
    .O(CMDDCI_3p)    , 
    .OB(CMDDCI_3n)
);



//----------
// DLL
//----------
wire RST_DLL, SW_RSTn;
assign SW_RSTn = 1'b1;
assign RST_DLL = ~SW_RSTn;

wire CLKIN_IBUFG;

IBUFG  CLKIN_IBUFG_INST (.I(CLK_50M), .O(CLKIN_IBUFG));
wire CLK0_OUT, CLKFX_BUF, LOCKED1, CLKFB_IN;

DCM_ADV #(
  .CLKDV_DIVIDE(2.0), // Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5
                      //   7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
                      
  .CLKFX_DIVIDE(5),   // Can be any integer from 1 to 32
  .CLKFX_MULTIPLY(16), // Can be any integer from 2 to 32
  
  .CLKIN_DIVIDE_BY_2("FALSE"), // TRUE/FALSE to enable CLKIN divide by two feature
  .CLKIN_PERIOD(20.0), // Specify period of input clock in ns from 1.25 to 1000.00
  .CLKOUT_PHASE_SHIFT("NONE"), // Specify phase shift mode of NONE, FIXED, 
                               // VARIABLE_POSITIVE, VARIABLE_CENTER or DIRECT
  .CLK_FEEDBACK("1X"),  // Specify clock feedback of NONE, 1X or 2X
  .DCM_PERFORMANCE_MODE("MAX_SPEED"), // Can be MAX_SPEED or MAX_RANGE
  .DESKEW_ADJUST("SYSTEM_SYNCHRONOUS"), // SOURCE_SYNCHRONOUS, SYSTEM_SYNCHRONOUS or
                                        //   an integer from 0 to 15
  .DFS_FREQUENCY_MODE("LOW"), // HIGH or LOW frequency mode for frequency synthesis
  .DLL_FREQUENCY_MODE("LOW"), // LOW, HIGH, or HIGH_SER frequency mode for DLL
  .DUTY_CYCLE_CORRECTION("TRUE"), // Duty cycle correction, "TRUE"/"FALSE" 
  .FACTORY_JF(16'hf0f0), // FACTORY JF value suggested to be set to 16'hf0f0
  .PHASE_SHIFT(0), // Amount of fixed phase shift from -255 to 1023
  .SIM_DEVICE("VIRTEX5"), // Set target device, "VIRTEX4" or "VIRTEX5" 
  .STARTUP_WAIT("FALSE")  // Delay configuration DONE until DCM LOCK, "TRUE"/"FALSE" 
) DCM_ADV_0 (

  .CLKIN(CLKIN_IBUFG),     // Clock input (from IBUFG, BUFG or DCM)

  .CLK0(CLK0_OUT),         // 0 degree DCM CLK output
  .CLK180(),     // 180 degree DCM CLK output
  .CLK270(),     // 270 degree DCM CLK output
  .CLK2X(),       // 2X DCM CLK output
  .CLK2X180(), // 2X, 180 degree DCM CLK out
  .CLK90(),       // 90 degree DCM CLK output
  .CLKDV(),       // Divided DCM CLK out (CLKDV_DIVIDE)
  .CLKFX(CLKFX_BUF),       // DCM CLK synthesis out (M/D)
  .CLKFX180(), // 180 degree CLK synthesis out
  .DO(),             // 16-bit data output for Dynamic Reconfiguration Port (DRP)
  .DRDY(),         // Ready output signal from the DRP
  .LOCKED(LOCKED1),     // DCM LOCK status output
  .PSDONE(),     // Dynamic phase adjust done output
  .CLKFB(CLKFB_IN),       // DCM clock feedback
  
  .DADDR(7'b0),       // 7-bit address for the DRP
  .DCLK(1'b0),         // Clock for the DRP
  .DEN(1'b0),           // Enable input for the DRP
  .DI(16'b0),             // 16-bit data input for the DRP
  .DWE(1'b0),           // Active high allows for writing configuration memory
  .PSCLK(1'b0),       // Dynamic phase adjust clock input
  .PSEN(1'b0),         // Dynamic phase adjust enable input
  .PSINCDEC(1'b0), // Dynamic phase adjust increment/decrement
  .RST(RST_DLL)            // DCM asynchronous reset input
);

wire CLKFX_OUT_160;
BUFG  CLKFX_BUFG_INST (.I(CLKFX_BUF), .O(CLKFX_OUT_160));
assign CLKFB_IN = CLK0_OUT;
                         
wire CLK0_OUT2, CLK2X_OUT2, CLKDV_OUT2, CLKFX_OUT2, LOCKED2, CLKFB_IN2;

DCM_ADV #(
  .CLKDV_DIVIDE(10), // Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5
                      //   7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
                      
  .CLKFX_DIVIDE(8),   // Can be any integer from 1 to 32
  .CLKFX_MULTIPLY(2), // Can be any integer from 2 to 32
  
  .CLKIN_DIVIDE_BY_2("FALSE"), // TRUE/FALSE to enable CLKIN divide by two feature
  .CLKIN_PERIOD(6.25), // Specify period of input clock in ns from 1.25 to 1000.00
  .CLKOUT_PHASE_SHIFT("NONE"), // Specify phase shift mode of NONE, FIXED, 
                               // VARIABLE_POSITIVE, VARIABLE_CENTER or DIRECT
  .CLK_FEEDBACK("1X"),  // Specify clock feedback of NONE, 1X or 2X
  .DCM_PERFORMANCE_MODE("MAX_RANGE"), // Can be MAX_SPEED or MAX_RANGE
  .DESKEW_ADJUST("SYSTEM_SYNCHRONOUS"), // SOURCE_SYNCHRONOUS, SYSTEM_SYNCHRONOUS or
                                        //   an integer from 0 to 15
  .DFS_FREQUENCY_MODE("HIGH"), // HIGH or LOW frequency mode for frequency synthesis
  .DLL_FREQUENCY_MODE("HIGH"), // LOW, HIGH, or HIGH_SER frequency mode for DLL
  .DUTY_CYCLE_CORRECTION("TRUE"), // Duty cycle correction, "TRUE"/"FALSE" 
  .FACTORY_JF(16'hf0f0), // FACTORY JF value suggested to be set to 16'hf0f0
  .PHASE_SHIFT(0), // Amount of fixed phase shift from -255 to 1023
  .SIM_DEVICE("VIRTEX5"), // Set target device, "VIRTEX4" or "VIRTEX5" 
  .STARTUP_WAIT("FALSE")  // Delay configuration DONE until DCM LOCK, "TRUE"/"FALSE" 
) DCM_ADV_1 (

  .CLKIN(CLKFX_OUT_160),     // Clock input (from IBUFG, BUFG or DCM)

  .CLK0(CLK0_OUT2),         // 0 degree DCM CLK output
  .CLK180(),     // 180 degree DCM CLK output
  .CLK270(),     // 270 degree DCM CLK output
  .CLK2X(CLK2X_OUT2),       // 2X DCM CLK output
  .CLK2X180(), // 2X, 180 degree DCM CLK out
  .CLK90(),       // 90 degree DCM CLK output
  .CLKDV(CLKDV_OUT2),       // Divided DCM CLK out (CLKDV_DIVIDE)
  .CLKFX(CLKFX_OUT2),       // DCM CLK synthesis out (M/D)
  .CLKFX180(), // 180 degree CLK synthesis out
  .DO(),             // 16-bit data output for Dynamic Reconfiguration Port (DRP)
  .DRDY(),         // Ready output signal from the DRP
  .LOCKED(LOCKED2),     // DCM LOCK status output
  .PSDONE(),     // Dynamic phase adjust done output
  .CLKFB(CLKFB_IN2),       // DCM clock feedback
  
  .DADDR(7'b0),       // 7-bit address for the DRP
  .DCLK(1'b0),         // Clock for the DRP
  .DEN(1'b0),           // Enable input for the DRP
  .DI(16'b0),             // 16-bit data input for the DRP
  .DWE(1'b0),           // Active high allows for writing configuration memory
  .PSCLK(1'b0),       // Dynamic phase adjust clock input
  .PSEN(1'b0),         // Dynamic phase adjust enable input
  .PSINCDEC(1'b0), // Dynamic phase adjust increment/decrement
  .RST(!LOCKED1)            // DCM asynchronous reset input
);


assign CLKFB_IN2 = CLK0_OUT2;                  

(* KEEP = "{TRUE}" *) wire BUS_CLK;
(* KEEP = "{TRUE}" *) wire CLK160;
(* KEEP = "{TRUE}" *) wire CLK320;
(* KEEP = "{TRUE}" *) wire CLK40;
(* KEEP = "{TRUE}" *) wire CLK16;

IBUFG   CLK_REG_BUFG_INST (.I(REG_CLK), .O(BUS_CLK));
//BUFG  CLK_BUFG_INST_160 (.I(CLK0_OUT2), .O(CLK160));
assign CLK160 = CLK0_OUT2;
BUFG  CLK_BUFG_INST_320 (.I(CLK2X_OUT2), .O(CLK320));
BUFG  CLK_BUFG_INST_40 (.I(CLKFX_OUT2), .O(CLK40));
BUFG  CLK_BUFG_INST_16 (.I(CLKDV_OUT2), .O(CLK16));

wire BUS_RST;
assign BUS_RST = !LOCKED2 | !LOCKED1 | RST_DLL;
assign USR_CLK = BUS_CLK; //This can be worked out to change 


//-------------------------------
//    UDP register Access
//-------------------------------
wire RBCP_WE, RBCP_RE;
wire [7:0] RBCP_WD, RBCP_RD;
wire [31:0] RBCP_ADDR;
wire RBCP_ACK;
    
slave slave(
.RSTn(~BUS_RST),    // in    : System reset
.FILL_ADDR(32'h0),    // in    : Filled address for narow address-width
// Serial I/F
.SCK(BUS_CLK),    // in    : Clock
.SCS(REG_ACT),    // in    : Active
.SI(REG_DI),    // out    : Data input
.SO(REG_DO),    // in    : Data output
// Register I/F
.REG_ADDR(RBCP_ADDR[31:0]),  
.REG_WD(RBCP_WD[7:0]), 
.REG_WE(RBCP_WE), 
.REG_RE(RBCP_RE), 
.REG_ACK(RBCP_ACK), 
.REG_RV(RBCP_ACK), 
.REG_RD(RBCP_RD[7:0])
);

wire BUS_WR, BUS_RD;
wire [31:0] BUS_ADD;
wire [7:0] BUS_DATA;

rbcp_to_bus irbcp_to_bus(

    .BUS_RST(BUS_RST),
    .BUS_CLK(BUS_CLK),

    .RBCP_ACT(1'b1),
    .RBCP_ADDR(RBCP_ADDR),
    .RBCP_WD(RBCP_WD),
    .RBCP_WE(RBCP_WE),
    .RBCP_RE(RBCP_RE),
    .RBCP_ACK(RBCP_ACK),
    .RBCP_RD(RBCP_RD),

    .BUS_WR(BUS_WR),
    .BUS_RD(BUS_RD),
    .BUS_ADD(BUS_ADD),
    .BUS_DATA(BUS_DATA)
);


// -------  MODULE ADREESSES  ------- //
localparam CMD_BASEADDR = 32'h0000;
localparam CMD_HIGHADDR = 32'h1000-1;

localparam FIFO_BASEADDR = 32'h8100;
localparam FIFO_HIGHADDR = 32'h8200-1;

localparam RX4_BASEADDR = 32'h8300;
localparam RX4_HIGHADDR = 32'h8400-1;

localparam RX3_BASEADDR = 32'h8400;
localparam RX3_HIGHADDR = 32'h8500-1;

localparam RX2_BASEADDR = 32'h8500;
localparam RX2_HIGHADDR = 32'h8600-1;

localparam RX1_BASEADDR = 32'h8600;
localparam RX1_HIGHADDR = 32'h8700-1;

localparam FIFO_BASEADDR_DATA = 32'h8000_0000;
localparam FIFO_HIGHADDR_DATA = 32'h9000_0000;

localparam ABUSWIDTH = 32;



cmd_seq 
#( 
    .BASEADDR(CMD_BASEADDR),
    .HIGHADDR(CMD_HIGHADDR),
    .ABUSWIDTH(ABUSWIDTH)
) icmd (
    .BUS_CLK(BUS_CLK),
    .BUS_RST(BUS_RST),
    .BUS_ADD(BUS_ADD),
    .BUS_DATA(BUS_DATA[7:0]),
    .BUS_RD(BUS_RD),
    .BUS_WR(BUS_WR),
    
    .CMD_CLK_OUT0(CMD_CLK0),
	 .CMD_CLK_OUT1(CMD_CLK1),
	 .CMD_CLK_OUT2(CMD_CLK2),
	 .CMD_CLK_OUT3(CMD_CLK3),
    .CMD_CLK_IN(CLK40),
    
    .CMD_EXT_START_FLAG(1'b0),
    .CMD_EXT_START_ENABLE(),
    .CMD_DATA0(CMD_DATA0),
	 .CMD_DATA1(CMD_DATA1),
	 .CMD_DATA2(CMD_DATA2),
	 .CMD_DATA3(CMD_DATA3),
    .CMD_READY(),
    .CMD_START_FLAG()
    
);


parameter DSIZE = 10;
wire [3:0] FE_FIFO_READ, FE_FIFO_EMPTY;
wire [31:0] FE_FIFO_DATA [3:0];

wire [3:0] RX_READY;

genvar i;
generate
  for (i = 0; i < 4; i = i + 1) begin: rx_gen
    fei4_rx 
    #(
        .BASEADDR(RX1_BASEADDR-32'h0100*i),
        .HIGHADDR(RX1_HIGHADDR-32'h0100*i),
        .DSIZE(DSIZE),
        .DATA_IDENTIFIER(i+1),
        .ABUSWIDTH(ABUSWIDTH)
    ) i_fei4_rx (
        .RX_CLK(CLK160),
        .RX_CLK2X(CLK320),
        .DATA_CLK(CLK16),
        
        .RX_DATA(DOBOUT[i]),
        
        .RX_READY(RX_READY[i]),
        .RX_8B10B_DECODER_ERR(),
        .RX_FIFO_OVERFLOW_ERR(),
         
        .FIFO_READ(FE_FIFO_READ[i]),
        .FIFO_EMPTY(FE_FIFO_EMPTY[i]),
        .FIFO_DATA(FE_FIFO_DATA[i]),
        
        .RX_FIFO_FULL(),
         
        .BUS_CLK(BUS_CLK),
        .BUS_RST(BUS_RST),
        .BUS_ADD(BUS_ADD),
        .BUS_DATA(BUS_DATA[7:0]),
        .BUS_RD(BUS_RD),
        .BUS_WR(BUS_WR)
    ); 
  end
endgenerate

//more modules possible
wire TDC_FIFO_READ, TDC_FIFO_EMPTY;
wire [31:0] TDC_FIFO_DATA;
assign TDC_FIFO_EMPTY = 1;

wire ARB_READY_OUT, ARB_WRITE_OUT;
wire [31:0] ARB_DATA_OUT;

rrp_arbiter 
#( 
    .WIDTH(5) // changed from 2
) i_rrp_arbiter
(
    .RST(BUS_RST),
    .CLK(BUS_CLK),

    .WRITE_REQ({~FE_FIFO_EMPTY, ~TDC_FIFO_EMPTY}),
    .HOLD_REQ({5'b0}), // changed from 2 bit to 5 bit
    .DATA_IN({FE_FIFO_DATA[3],FE_FIFO_DATA[2],FE_FIFO_DATA[1], FE_FIFO_DATA[0], TDC_FIFO_DATA}),
    .READ_GRANT({FE_FIFO_READ[3], FE_FIFO_READ[2], FE_FIFO_READ[1], FE_FIFO_READ[0], TDC_FIFO_READ}),

    .READY_OUT(ARB_READY_OUT),
    .WRITE_OUT(ARB_WRITE_OUT),
    .DATA_OUT(ARB_DATA_OUT)
);
 
//!
//! DIFFRENT CLOCS 
//!

wire FIFO_EMPTY, FIFO_FULL;
fifo_32_to_8 #(.DEPTH(4*1024)) i_data_fifo (
    .RST(BUS_RST),
    .CLK(BUS_CLK),
    
    .WRITE(ARB_WRITE_OUT),
    .READ(USR_TX_WE),
    .DATA_IN(ARB_DATA_OUT),
    .FULL(FIFO_FULL),
    .EMPTY(FIFO_EMPTY),
    .DATA_OUT(USR_TX_WD)
);
assign ARB_READY_OUT = !FIFO_FULL;
assign USR_TX_WE = !USR_TX_AFULL && !FIFO_EMPTY;

assign NIM_OUT = 0; //what is this
assign USR_CLOSE_ACK = 1'b1;
assign USR_RX_RE = 1'b1;

assign LED[0] = RX_READY[0];
assign LED[1] = FIFO_EMPTY;
assign LED[2] = FIFO_FULL;
assign LED[7:3] = 5'b10101;

endmodule 