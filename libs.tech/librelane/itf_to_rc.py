# Adapted from OpenROAD-flow-scripts
#
# https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts/blob/64939f3717ad7c694199ba04cb98924b98022868/flow/platforms/gt2n/itf_to_rc.py
#
from librelane.steps import TclStep

"""Derive per-length R and C (metals) and per-via R (vias) from GT2.itf.

Outputs Tcl set_layer_rc commands matching the existing setRC.tcl format.
Units: R in ohm/um for metals (ohm/via for vias), C in pf/um, matching the
gt2n libs (pulling_resistance_unit=1ohm, capacitive_load_unit=1pf).

Input: GT2N/nxtgrd/GT2.itf -- the StarRC interconnect tech file shipped with
the GT2N PDK (not in this repo). __main__ hardcodes a local path to it; point
that at your PDK copy. The matching NXTGRD/QRC files (GT2N/nxtgrd/GT2.nxtgrd,
GT2N/qrc/{GT2.ict, GT2_qrc.tch}) carry the full data a calibrated extractor
needs; this script is only the analytical approximation behind setRC.tcl.
(See the gt2n platform README for additional GT2N information.)

Model:
  R/um  = RPSQ / WMIN
  C/um  = (Ca + Cb)*FRINGE_FACTOR + 2*Cc
    Ca = eps0 * eps_above * W / d_above   parallel-plate to layer above
    Cb = eps0 * eps_below * W / d_below   parallel-plate to layer below
    Cc = eps0 * eps_side  * T / SMIN      between sidewalls of min-spaced neighbors
"""

import re
import sys

EPS0 = 8.854e-3
FRINGE_FACTOR = 1.5
PF_PER_FF = 1.0e-3

ROUTING = {
    "M0",
    "M1",
    "M2",
    "M3",
    "M4",
    "M5",
    "M6",
    "M7",
    "M8",
    "M9",
    "M10",
    "M11",
    "M12",
    "M13",
    "RDL",
}

# dielectrics to ignore when looking up neighbors (file-end placeholder)
IGNORE_DIELS = {"dummy_diel"}


def parse_itf(path):
    text = re.sub(r"\$[^\n]*\n", "\n", open(path).read())
    entries = []
    for m in re.finditer(r"(DIELECTRIC|CONDUCTOR|VIA)\s+(\w+)\s*\{([^}]*)\}", text):
        kind, name, body = m.group(1), m.group(2), m.group(3)
        params = {k: float(v) for k, v in re.findall(r"(\w+)\s*=\s*([\d.]+)", body)}
        # also accept upper/lower text fields like FROM/TO for VIA
        for k, v in re.findall(r"(\w+)\s*=\s*([A-Za-z]\w*)", body):
            params.setdefault(k, v)
        entries.append((kind, name, params))
    return entries


def metal_rc(entries, idx):
    cond = entries[idx][2]
    # dielectric above (closest, ignoring placeholders)
    above = None
    for j in range(idx - 1, -1, -1):
        if entries[j][0] == "DIELECTRIC" and entries[j][1] not in IGNORE_DIELS:
            above = entries[j][2]
            break
    # dielectric below (closest, stop at next conductor)
    below = None
    for j in range(idx + 1, len(entries)):
        if entries[j][0] == "CONDUCTOR":
            break
        if entries[j][0] == "DIELECTRIC" and entries[j][1] not in IGNORE_DIELS:
            below = entries[j][2]
            break
    W, S, T = cond["WMIN"], cond["SMIN"], cond["THICKNESS"]
    R = cond["RPSQ"] / W

    def pp(d):
        return EPS0 * d["ER"] * W / d["THICKNESS"] if d else 0.0

    Ca, Cb = pp(above), pp(below)
    eps_side = (above or below)["ER"] if (above or below) else 1.0
    Cc = EPS0 * eps_side * T / S
    C_fF = (Ca + Cb) * FRINGE_FACTOR + 2 * Cc
    return R, C_fF * PF_PER_FF


if __name__ == "__main__":
    # python3 libs.tech/librelane/itf_to_rc.py nxtgrd/GT3.itf > libs.tech/librelane/rc_generated.tcl
    entries = parse_itf(sys.argv[1])
    print("# Per-length metal R and C, derived analytically from GT3.itf.")
    print("# R/um = RPSQ / WMIN.")
    print(
        "# C/um = parallel-plate-to-neighbor + sidewall-coupling, fringe-scaled 1.5x."
    )
    print(
        "# pulling_resistance_unit=1ohm -> ohm/um ; capacitive_load_unit(1, pf) -> pf/um."
    )
    print()
    layers_info = {}
    for i, (kind, name, _) in enumerate(entries):
        if kind == "CONDUCTOR" and name in ROUTING:
            R, C = metal_rc(entries, i)
            layers_info[name] = {"res": R, "cap": C}
    print("set ::env(LAYERS_RC) {")
    print(TclStep.value_to_tcl({"*": layers_info}))
    print("}")
    print("# Via resistance (single via). Derived from ITF VIA RPV values.")
    print()
    vias_info = {}
    for kind, name, p in entries:
        if kind == "VIA" and name.startswith(("V", "BV")) and "RPV" in p:
            vias_info[name] = { "res": p["RPV"] }
    print("set ::env(VIAS_R) {")
    print(TclStep.value_to_tcl({"*": vias_info}))
    print("}")
