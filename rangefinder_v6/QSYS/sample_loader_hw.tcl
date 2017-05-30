# TCL File Generated by Component Editor 14.0
# Thu Jun 02 12:05:38 GMT+03:00 2016
# DO NOT MODIFY


# 
# sample_loader "sample_loader" v1.0
#  2016.06.02.12:05:38
# 
# 

# 
# request TCL package from ACDS 14.0
# 
package require -exact qsys 14.0


# 
# module sample_loader
# 
set_module_property DESCRIPTION ""
set_module_property NAME sample_loader
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME sample_loader
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL sample_loader
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file sample_loader.v VERILOG PATH ../HDL/sample_loader.v TOP_LEVEL_FILE
add_fileset_file mem_master.v VERILOG PATH ../HDL/mem_master.v
add_fileset_file pulse_cross_domain.v VERILOG PATH ../HDL/pulse_cross_domain.v


# 
# parameters
# 


# 
# display items
# 


# 
# connection point avalon_slave_0
# 
add_interface avalon_slave_0 avalon end
set_interface_property avalon_slave_0 addressUnits WORDS
set_interface_property avalon_slave_0 associatedClock clock_sink
set_interface_property avalon_slave_0 associatedReset reset_sink
set_interface_property avalon_slave_0 bitsPerSymbol 8
set_interface_property avalon_slave_0 burstOnBurstBoundariesOnly false
set_interface_property avalon_slave_0 burstcountUnits WORDS
set_interface_property avalon_slave_0 explicitAddressSpan 0
set_interface_property avalon_slave_0 holdTime 0
set_interface_property avalon_slave_0 linewrapBursts false
set_interface_property avalon_slave_0 maximumPendingReadTransactions 0
set_interface_property avalon_slave_0 maximumPendingWriteTransactions 0
set_interface_property avalon_slave_0 readLatency 0
set_interface_property avalon_slave_0 readWaitTime 1
set_interface_property avalon_slave_0 setupTime 0
set_interface_property avalon_slave_0 timingUnits Cycles
set_interface_property avalon_slave_0 writeWaitTime 0
set_interface_property avalon_slave_0 ENABLED true
set_interface_property avalon_slave_0 EXPORT_OF ""
set_interface_property avalon_slave_0 PORT_NAME_MAP ""
set_interface_property avalon_slave_0 CMSIS_SVD_VARIABLES ""
set_interface_property avalon_slave_0 SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave_0 avs_cs chipselect Input 1
add_interface_port avalon_slave_0 avs_addr address Input 4
add_interface_port avalon_slave_0 avs_write write Input 1
add_interface_port avalon_slave_0 avs_writedata writedata Input 32
add_interface_port avalon_slave_0 avs_read read Input 1
add_interface_port avalon_slave_0 avs_readdata readdata Output 32
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point reset_sink
# 
add_interface reset_sink reset end
set_interface_property reset_sink associatedClock clock_sink
set_interface_property reset_sink synchronousEdges DEASSERT
set_interface_property reset_sink ENABLED true
set_interface_property reset_sink EXPORT_OF ""
set_interface_property reset_sink PORT_NAME_MAP ""
set_interface_property reset_sink CMSIS_SVD_VARIABLES ""
set_interface_property reset_sink SVD_ADDRESS_GROUP ""

add_interface_port reset_sink avs_reset reset Input 1


# 
# connection point clock_sink
# 
add_interface clock_sink clock end
set_interface_property clock_sink clockRate 0
set_interface_property clock_sink ENABLED true
set_interface_property clock_sink EXPORT_OF ""
set_interface_property clock_sink PORT_NAME_MAP ""
set_interface_property clock_sink CMSIS_SVD_VARIABLES ""
set_interface_property clock_sink SVD_ADDRESS_GROUP ""

add_interface_port clock_sink avs_clk clk Input 1


# 
# connection point ext
# 
add_interface ext conduit end
set_interface_property ext associatedClock ""
set_interface_property ext associatedReset ""
set_interface_property ext ENABLED true
set_interface_property ext EXPORT_OF ""
set_interface_property ext PORT_NAME_MAP ""
set_interface_property ext CMSIS_SVD_VARIABLES ""
set_interface_property ext SVD_ADDRESS_GROUP ""

add_interface_port ext reset reset Input 1
add_interface_port ext adc_clk adc_clk Input 1
add_interface_port ext adc_sample adc_sample Input 8
add_interface_port ext direct_comp direct_comp Input 1
add_interface_port ext adaptive_comp adaptive_comp Input 1
add_interface_port ext tdc_strobe tdc_strobe Output 1


# 
# connection point master
# 
add_interface master conduit end
set_interface_property master associatedClock ""
set_interface_property master associatedReset ""
set_interface_property master ENABLED true
set_interface_property master EXPORT_OF ""
set_interface_property master PORT_NAME_MAP ""
set_interface_property master CMSIS_SVD_VARIABLES ""
set_interface_property master SVD_ADDRESS_GROUP ""

add_interface_port master avm_clk clk Output 1
add_interface_port master avm_reset reset Output 1
add_interface_port master avm_writedata writedata Output 8
add_interface_port master avm_cs chipselect Output 6
add_interface_port master avm_write write Output 6
add_interface_port master avm0_addr addr_0 Output 8
add_interface_port master avm1_addr addr_1 Output 8
add_interface_port master avm2_addr addr_2 Output 8
add_interface_port master avm3_addr addr_3 Output 8
add_interface_port master avm4_addr addr_4 Output 8
add_interface_port master avm5_addr addr_5 Output 8
