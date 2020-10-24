library verilog;
use verilog.vl_types.all;
entity DAC_Input is
    port(
        CLK             : in     vl_logic;
        RST_BTN         : in     vl_logic;
        XMT             : out    vl_logic;
        FMT             : out    vl_logic;
        LCK             : out    vl_logic;
        DIN             : out    vl_logic;
        BCK             : out    vl_logic;
        SCL             : out    vl_logic;
        DMP             : out    vl_logic;
        FLT             : out    vl_logic
    );
end DAC_Input;
