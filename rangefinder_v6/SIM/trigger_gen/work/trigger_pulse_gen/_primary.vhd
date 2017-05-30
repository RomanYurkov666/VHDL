library verilog;
use verilog.vl_types.all;
entity trigger_pulse_gen is
    generic(
        DELAY           : integer := 10
    );
    port(
        clk             : in     vl_logic;
        sample          : in     vl_logic_vector(7 downto 0);
        threshold       : in     vl_logic_vector(7 downto 0);
        direction       : in     vl_logic;
        trigger         : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DELAY : constant is 1;
end trigger_pulse_gen;
