# TCL File Generated by Component Editor 14.0
# Mon May 29 17:03:44 GMT+03:00 2017
# DO NOT MODIFY


# 
# sample_recorder "sample_recorder" v1.0
#  2017.05.29.17:03:44
# 
# 

# 
# request TCL package from ACDS 14.0
# 
package require -exact qsys 14.0


# 
# module sample_recorder
# 
set_module_property DESCRIPTION ""
set_module_property NAME sample_recorder
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME sample_recorder
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL sample_recorder
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file cross_domain.v VERILOG PATH ../HDL/cross_domain.v
add_fileset_file pulse_cross_domain.v VERILOG PATH ../HDL/pulse_cross_domain.v
add_fileset_file rec_channel_switch.v VERILOG PATH ../HDL/rec_channel_switch.v
add_fileset_file record_buffer_selector.v VERILOG PATH ../HDL/record_buffer_selector.v
add_fileset_file recording_channel.v VERILOG PATH ../HDL/recording_channel.v
add_fileset_file sample_recorder.v VERILOG PATH ../HDL/sample_recorder.v TOP_LEVEL_FILE
add_fileset_file simple_dma.v VERILOG PATH ../HDL/simple_dma.v
add_fileset_file timestamp_cntr.v VERILOG PATH ../HDL/timestamp_cntr.v
add_fileset_file trigger_pulse_gen.v VERILOG PATH ../HDL/trigger_pulse_gen.v


# 
# parameters
# 


# 
# display items
# 


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

add_interface_port clock_sink mm_clk clk Input 1


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

add_interface_port reset_sink mm_reset reset Input 1


# 
# connection point avalon_slave
# 
add_interface avalon_slave avalon end
set_interface_property avalon_slave addressUnits WORDS
set_interface_property avalon_slave associatedClock clock_sink
set_interface_property avalon_slave associatedReset reset_sink
set_interface_property avalon_slave bitsPerSymbol 8
set_interface_property avalon_slave burstOnBurstBoundariesOnly false
set_interface_property avalon_slave burstcountUnits WORDS
set_interface_property avalon_slave explicitAddressSpan 0
set_interface_property avalon_slave holdTime 0
set_interface_property avalon_slave linewrapBursts false
set_interface_property avalon_slave maximumPendingReadTransactions 0
set_interface_property avalon_slave maximumPendingWriteTransactions 0
set_interface_property avalon_slave readLatency 0
set_interface_property avalon_slave readWaitTime 1
set_interface_property avalon_slave setupTime 0
set_interface_property avalon_slave timingUnits Cycles
set_interface_property avalon_slave writeWaitTime 0
set_interface_property avalon_slave ENABLED true
set_interface_property avalon_slave EXPORT_OF ""
set_interface_property avalon_slave PORT_NAME_MAP ""
set_interface_property avalon_slave CMSIS_SVD_VARIABLES ""
set_interface_property avalon_slave SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave avsc_cs chipselect Input 1
add_interface_port avalon_slave avsc_addr address Input 4
add_interface_port avalon_slave avsc_write write Input 1
add_interface_port avalon_slave avsc_writedata writedata Input 32
add_interface_port avalon_slave avsc_read read Input 1
add_interface_port avalon_slave avsc_readdata readdata Output 32
set_interface_assignment avalon_slave embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_slave embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave embeddedsw.configuration.isPrintableDevice 0


# 
# connection point avalon_slave_1
# 
add_interface avalon_slave_1 avalon end
set_interface_property avalon_slave_1 addressUnits WORDS
set_interface_property avalon_slave_1 associatedClock clock_sink
set_interface_property avalon_slave_1 associatedReset reset_sink
set_interface_property avalon_slave_1 bitsPerSymbol 8
set_interface_property avalon_slave_1 burstOnBurstBoundariesOnly false
set_interface_property avalon_slave_1 burstcountUnits WORDS
set_interface_property avalon_slave_1 explicitAddressSpan 0
set_interface_property avalon_slave_1 holdTime 0
set_interface_property avalon_slave_1 linewrapBursts false
set_interface_property avalon_slave_1 maximumPendingReadTransactions 0
set_interface_property avalon_slave_1 maximumPendingWriteTransactions 0
set_interface_property avalon_slave_1 readLatency 0
set_interface_property avalon_slave_1 readWaitStates 2
set_interface_property avalon_slave_1 readWaitTime 2
set_interface_property avalon_slave_1 setupTime 0
set_interface_property avalon_slave_1 timingUnits Cycles
set_interface_property avalon_slave_1 writeWaitTime 0
set_interface_property avalon_slave_1 ENABLED true
set_interface_property avalon_slave_1 EXPORT_OF ""
set_interface_property avalon_slave_1 PORT_NAME_MAP ""
set_interface_property avalon_slave_1 CMSIS_SVD_VARIABLES ""
set_interface_property avalon_slave_1 SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave_1 avsd_cs chipselect Input 1
add_interface_port avalon_slave_1 avsd_addr address Input 6
add_interface_port avalon_slave_1 avsd_read read Input 1
add_interface_port avalon_slave_1 avsd_readdata readdata Output 32
set_interface_assignment avalon_slave_1 embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave_1 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_slave_1 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave_1 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point clock_sink_1
# 
add_interface clock_sink_1 clock end
set_interface_property clock_sink_1 clockRate 0
set_interface_property clock_sink_1 ENABLED true
set_interface_property clock_sink_1 EXPORT_OF ""
set_interface_property clock_sink_1 PORT_NAME_MAP ""
set_interface_property clock_sink_1 CMSIS_SVD_VARIABLES ""
set_interface_property clock_sink_1 SVD_ADDRESS_GROUP ""

add_interface_port clock_sink_1 adc_clk clk Input 1


# 
# connection point conduit_end
# 
add_interface conduit_end conduit end
set_interface_property conduit_end associatedClock clock_sink_1
set_interface_property conduit_end associatedReset ""
set_interface_property conduit_end ENABLED true
set_interface_property conduit_end EXPORT_OF ""
set_interface_property conduit_end PORT_NAME_MAP ""
set_interface_property conduit_end CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end SVD_ADDRESS_GROUP ""

add_interface_port conduit_end adc_data adc_data Input 8
add_interface_port conduit_end comparator comparator Input 1
