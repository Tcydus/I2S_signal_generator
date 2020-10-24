library verilog;
use verilog.vl_types.all;
entity DAC_Input_vlg_check_tst is
    port(
        BCK             : in     vl_logic;
        DIN             : in     vl_logic;
        DMP             : in     vl_logic;
        FLT             : in     vl_logic;
        FMT             : in     vl_logic;
        LCK             : in     vl_logic;
        SCL             : in     vl_logic;
        XMT             : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end DAC_Input_vlg_check_tst;
