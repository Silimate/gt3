set ::env(STD_CELL_LIBRARY) "gt3_6t"
set ::env(VDD_PIN) "vdd"
set ::env(GND_PIN) "vss"
set ::env(TECH_LEFS) "* $::env(PDK_ROOT)/$::env(PDK)/techlef/gt3_tech.lef"
set ::env(PRIMARY_GDSII_STREAMOUT_TOOL) "klayout"
set ::env(DEFAULT_CORNER) "tt_0p7v25c"
set ::env(STA_CORNERS) "tt_0p7v25c"
set ::env(TIMING_VIOLATION_CORNERS) ""
# if people need the upper layers badly, they can specify them themselves,
# they're super sparse and break a lot of flow assumptions
set ::env(RT_MIN_LAYER) "M1"
set ::env(RT_MAX_LAYER) "M10"
set ::env(IO_PIN_H_LAYER) "M10"
set ::env(IO_PIN_V_LAYER) "M9"
set ::env(GRT_LAYER_ADJUSTMENTS) "0,0,0,0,0,0,0,0,0,0,0,0,0"

source "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/librelane/rc_generated.tcl"
