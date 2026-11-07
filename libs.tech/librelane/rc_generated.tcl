# Per-length metal R and C, derived analytically from GT3.itf.
# R/um = RPSQ / WMIN.
# C/um = parallel-plate-to-neighbor + sidewall-coupling, fringe-scaled 1.5x.
# pulling_resistance_unit=1ohm -> ohm/um ; capacitive_load_unit(1, pf) -> pf/um.

set ::env(LAYERS_RC) {
"*" "RDL \"res 0.0062499999999999995 cap 0.0002509950892857143\" M13 \"res 0.2777777777777778 cap 0.00012049521031746032\" M12 \"res 0.2777777777777778 cap 0.00012049521031746032\" M11 \"res 16.42857142857143 cap 0.00010514125\" M10 \"res 16.42857142857143 cap 0.00010907312500000002\" M9 \"res 26.552631578947366 cap 0.00010514125\" M8 \"res 26.552631578947366 cap 0.00010514125\" M7 \"res 26.552631578947366 cap 0.00010514125\" M6 \"res 26.552631578947366 cap 0.00011186080357142859\" M5 \"res 166.95238095238093 cap 0.00010514125\" M4 \"res 166.95238095238093 cap 0.000108793525\" M3 \"res 437.5 cap 0.0001022637\" M2 \"res 621.75 cap 9.979722857142857e-05\" M1 \"res 437.5 cap 0.0001022637\" M0 \"res 621.75 cap 0.00011999094782608697\""
}
# Via resistance (single via). Derived from ITF VIA RPV values.

set ::env(VIAS_R) {
"*" "VBPR \"res 32.0\" VG \"res 31.94\" VSD \"res 36.86\" V0 \"res 54.99\" V1 \"res 54.99\" V2 \"res 54.99\" V3 \"res 45.78\" V4 \"res 27.8\" V5 \"res 14.89\" V6 \"res 13.26\" V7 \"res 13.26\" V8 \"res 13.26\" V9 \"res 7.65\" V10 \"res 6.08\" V11 \"res 6.08\" V12 \"res 6.08\" V13 \"res 6.08\""
}
