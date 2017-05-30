library verilog;
use verilog.vl_types.all;
entity pulse_cross_domain is
    port(
        pulse_in        : in     vl_logic;
        clk_out         : in     vl_logic;
        pulse_out       : out    vl_logic
    );
end pulse_cross_domain;
