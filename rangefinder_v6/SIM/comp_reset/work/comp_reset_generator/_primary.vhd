library verilog;
use verilog.vl_types.all;
entity comp_reset_generator is
    generic(
        PULSE_LEN       : integer := 4;
        PULSE_DELAY     : integer := 20
    );
    port(
        reset           : in     vl_logic;
        ref_clk         : in     vl_logic;
        comp_out        : in     vl_logic;
        rst_driver      : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of PULSE_LEN : constant is 1;
    attribute mti_svvh_generic_type of PULSE_DELAY : constant is 1;
end comp_reset_generator;
