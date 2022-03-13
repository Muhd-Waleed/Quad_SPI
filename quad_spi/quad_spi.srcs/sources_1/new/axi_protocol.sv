`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2022 04:04:42 PM
// Design Name: 
// Module Name: axi_protocol
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module axi_protocol(
    inout logic spi_io0_i,
    inout logic spi_io1_i,
    inout logic spi_io2_i,
    inout logic spi_io3_i,
    output logic spi_ss_o,
    output logic spi_clk_o,

    input logic read,
    input logic write,
    // output logic compare,
    output logic led,
    input clk,
    input rst_n
);
    
    localparam control_register_address = 24'h60;
    localparam control_register_value = 32'h00000001;
    
    localparam DataTransmit_register_address = 24'h68 ;
    localparam DataTransmit_register_value = 32'h57;
    
    localparam read_register_address = 24'h6c;
    

    logic [31:0]read_register;
    
    logic [31:0] axi_araddr;
    logic        axi_arready;
    logic        axi_arvalid;
    logic [31:0] axi_awaddr;
    logic        axi_awready;
    logic        axi_awvalid;
    logic [1:0]  axi_bresp;
    logic        axi_bready;
    logic        axi_bvalid;
    logic [31:0] axi_rdata;
    logic        axi_rready;
    logic [1:0]  axi_rresp;
    logic        axi_rvalid;
    logic [31:0] axi_wdata;
    logic [3:0]  axi_wstrb;
    logic        axi_wready;
    logic        axi_wvalid;  
    
    logic aclk;
        
    typedef enum logic [2:0] {idle , cntrl_register , data_transmit_register , data_recieve_register} state_t ;

    state_t current_state, next_state;
        
    clk_wiz_1 clk_wiz_inst (
      // Clock out ports
      .clk_out1(aclk),
      // Status and control signals
      .resetn(rst_n),
     // Clock in ports
      .clk_in1(clk)
    );
    
    qspi_wrapper u_qspi(
        .AXI_FULL_0_araddr(0),
        .AXI_FULL_0_arburst(0),
        .AXI_FULL_0_arcache(0),
        .AXI_FULL_0_arlen(0),
        .AXI_FULL_0_arlock(0),
        .AXI_FULL_0_arprot(0),
        .AXI_FULL_0_arready(),
        .AXI_FULL_0_arsize(0),
        .AXI_FULL_0_arvalid(0),
        .AXI_FULL_0_awaddr(0),
        .AXI_FULL_0_awburst(0),
        .AXI_FULL_0_awcache(0),
        .AXI_FULL_0_awlen(0),
        .AXI_FULL_0_awlock(0),
        .AXI_FULL_0_awprot(0),
        .AXI_FULL_0_awready(),
        .AXI_FULL_0_awsize(0),
        .AXI_FULL_0_awvalid(0),
        .AXI_FULL_0_bready(0),
        .AXI_FULL_0_bresp(),
        .AXI_FULL_0_bvalid(),
        .AXI_FULL_0_rdata(),
        .AXI_FULL_0_rlast(),
        .AXI_FULL_0_rready(0),
        .AXI_FULL_0_rresp(),
        .AXI_FULL_0_rvalid(),
        .AXI_FULL_0_wdata(0),
        .AXI_FULL_0_wlast(0),
        .AXI_FULL_0_wready(),
        .AXI_FULL_0_wstrb(0),
        .AXI_FULL_0_wvalid(0),
        .AXI_LITE_0_araddr(axi_araddr),
        .AXI_LITE_0_arready(axi_arready),
        .AXI_LITE_0_arvalid(axi_arvalid),
        .AXI_LITE_0_awaddr(axi_awaddr),
        .AXI_LITE_0_awready(axi_awready),
        .AXI_LITE_0_awvalid(axi_awvalid),
        .AXI_LITE_0_bready(axi_bready),
        .AXI_LITE_0_bresp(axi_bresp),
        .AXI_LITE_0_bvalid(axi_bvalid),
        .AXI_LITE_0_rdata(axi_rdata),
        .AXI_LITE_0_rready(axi_rready),
        .AXI_LITE_0_rresp(axi_rresp),
        .AXI_LITE_0_rvalid(axi_rvalid),
        .AXI_LITE_0_wdata(axi_wdata),
        .AXI_LITE_0_wready(axi_wready),
        .AXI_LITE_0_wstrb(axi_wstrb),
        .AXI_LITE_0_wvalid(axi_wvalid),
        .SPI_0_0_io0_io(spi_io0_i),
        .SPI_0_0_io1_io(spi_io1_i),
        .SPI_0_0_io2_io(spi_io2_i),
        .SPI_0_0_io3_io(spi_io3_i),
        .SPI_0_0_sck_io(spi_clk_o),
        .SPI_0_0_ss_io(spi_ss_o),
        .ext_spi_clk_0(0),
        .ip2intc_irpt_0(),
        .s_axi4_aclk_0(0),
        .s_axi4_aresetn_0(0),
        .s_axi_aclk_0(aclk),
        .s_axi_aresetn_0(rst_n)    
    );
    
    always @(posedge aclk) begin
        if(!rst_n) begin
            current_state <= idle;
            axi_araddr <= '0;
            axi_arvalid <= '0;
          //  axi_awaddr <= 1'b0;
          //  axi_awvalid <= 1'b0;
           // axi_bready <= 1'b0;
           // axi_rready <= 1'b0;
            //axi_wdata <= 1'b0;
            axi_wstrb <= '0;
           // axi_wvalid <= 1'b0;
           current_state <= idle;
            
            
        end else begin
            current_state <= next_state;
   
        end
        

    end
    
    always_comb begin
        led = 1'b0;
        unique case(current_state)
    
            idle :begin 
                if(write == 1'b1) 
                    next_state = cntrl_register;
                else if(read == 1'b1) 
                    next_state = data_recieve_register;
                else
                    next_state = next_state; 
            end

            cntrl_register :begin 
                axi_awaddr  = control_register_address;
                axi_awvalid = 1'b1;
                axi_wdata   = control_register_value;
                axi_wvalid  = 1'b1;
                axi_bready  = 1'b1;

                if (axi_awvalid == 1'b1) begin
                    axi_awready = 1'b0;
                end

                if (axi_wvalid == 1'b1) begin
                    axi_wready = 1'b0;
                end

                if (axi_awvalid == 1'b0 && axi_wready == 1'b0) begin
                    next_state = data_transmit_register;
                end
            end

            data_transmit_register : begin
                axi_awaddr  = DataTransmit_register_address;
                axi_awvalid = 1'b1;
                axi_wdata   = DataTransmit_register_value;
                axi_wvalid  = 1'b1;
                axi_bready  = 1'b1;

                if (axi_awvalid == 1'b1) begin
                    axi_awready = 1'b0;
                end
                if (axi_wvalid == 1'b1) begin 
                    axi_wready = 1'b0;
                end
                if (axi_awvalid == 1'b0 && axi_wready == 1'b0) begin
                    next_state = data_recieve_register;
                end
            end

            data_recieve_register: begin
                axi_awaddr    = read_register_address;
                axi_awvalid   = 1'b1;
                read_register = axi_rdata;

                if( read_register == 32'h00000001) begin
                    led = 1'b1;
                end

                axi_rready = 1'b1;
                axi_bready = 1'b1;

                if (axi_awvalid == 1'b1) begin
                    axi_awready = 1'b0;
                end

                if (axi_rready == 1'b1) begin
                    axi_rvalid = 1'b0;
                end

                if (axi_wvalid == 1'b0 && axi_rready == 1'b0) begin
                    next_state = idle;
                end
            end

            default: next_state = idle;
        endcase
    end 
endmodule
