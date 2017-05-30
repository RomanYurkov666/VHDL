##**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3

#**************************************************************
# Create Clock
#**************************************************************

create_clock -period 50MHz -name {SYSTEM_CLK} [get_ports {SYSTEM_CLK}]
create_clock -period 200MHz -name {AD9480_CLKO} [get_ports {AD9480_CLKO}]

#**************************************************************
# Create Generated Clock
#**************************************************************

derive_pll_clocks

#**************************************************************
# Set Clock Groups
#**************************************************************


#set_false_path -from [get_clocks [list $CLK_100_MHz]] -to [get_clocks [list $PHY_TX_CLK]]
#set_clock_groups -exclusive -group [list $CLK_25_MHz $CLK_100_MHz] -group [list $PHY_TX_CLK $PHY_RX_CLK]
#set_clock_groups -exclusive -group [list $CLK_25_MHz $CLK_100_MHz] -group {SWIR_CLK}
#set_clock_groups -exclusive -group [list $CLK_25_MHz $CLK_100_MHz] -group {LWIR_CLK}
#set_clock_groups -exclusive -group [list $CLK_25_MHz $CLK_100_MHz] -group {TV_APTINA_PIXCLK}

#set_clock_groups -exclusive -group [list {$CLK_25_MHz $CLK_100_MHz $CPU_CLK_100_MHz SYSTEM_CLK}]
#set_clock_groups -exclusive -group [list {$SGMII_REF_CLK MGT_CLKP}]
#set_clock_groups -exclusive -group {SWIR_CLK}
#set_clock_groups -exclusive -group {PHY_TX_CLK}

#**************************************************************
# Set Clock Uncertainty
#**************************************************************

derive_clock_uncertainty