set ::env(SCL_POWER_PINS) "vdd"
set ::env(SCL_GROUND_PINS) "vss"

set ::env(CELL_LIBS) "* \"$::env(PDK_ROOT)/$::env(PDK)/lib/gt3_rvt_tt_0p7v25c.lib\""
set ::env(CELL_LEFS) "$::env(PDK_ROOT)/$::env(PDK)/lef/gt3_std_cell_rvt.lef"
set ::env(CELL_GDS) "$::env(PDK_ROOT)/$::env(PDK)/gds/$::env(STD_CELL_LIBRARY)_std_cell_rvt.gds"

set ::env(SYNTH_EXCLUDED_CELL_FILE) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/librelane/$::env(STD_CELL_LIBRARY)/synth_exclude.txt"
set ::env(PNR_EXCLUDED_CELL_FILE) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/librelane/$::env(STD_CELL_LIBRARY)/pnr_exclude.txt"


set ::env(DPL_CELL_PADDING) {2}
set ::env(GPL_CELL_PADDING) {2}

# cells
set ::env(SYNTH_TIEHI_CELL) {gt3_6t_tie_hi_silimate/HI}
set ::env(SYNTH_TIELO_CELL) {gt3_6t_tie_lo_silimate/LO}

# just not the smallest buffer
set ::env(SYNTH_BUFFER_CELL) "gt3_6t_buf_x2_rvt/A/Y"
# no symmetrical buffers
set ::env(CTS_ROOT_BUFFER) "gt3_6t_buf_x8_rvt"
set ::env(CTS_CLK_BUFFERS) "gt3_6t_buf*"
# yes, there's only one
set ::env(FILL_CELLS) "gt3_6t_filler_x1"
# no decaps
set ::env(DECAP_CELLS) "gt3_6t_filler_x1"

# vibes-based values
set ::env(MAX_FANOUT_CONSTRAINT) {10}
set ::env(OUTPUT_CAP_LOAD) {2}
set ::env(CLOCK_UNCERTAINTY_CONSTRAINT) {2}
set ::env(CLOCK_TRANSITION_CONSTRAINT) {2}
set ::env(TIME_DERATING_CONSTRAINT) {10}
set ::env(IO_DELAY_CONSTRAINT) {10}
set ::env(SYNTH_DRIVING_CELL) {gt3_6t_inv_x4_rvt/Y}
set ::env(PLACE_SITE) {gt3v1}
set ::env(CELL_PAD_EXCLUDE) {}
