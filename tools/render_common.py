#!/usr/bin/env python3
"""render_common.py — what the seven render_*_compare oracles share.

Every render oracle draws one scene twice — the C screen through
`smoke --render<kind>`, the JS canvas through `sim_trace.py render<kind>` —
and diffs them pixel by pixel over 320x200.  A differing pixel is one of
two things:

  STRUCTURAL   the engines drew different things.  Fails the run, always.
  ACCEPTED     the same palette INDEX resolved through different palettes.
               The JS bakes each sheet's art through that sheet's own
               embedded palette (an atlas); the C is a single-DAC model and
               resolves every index through whichever palette is loaded.
               Where those disagree the RGB differs while the structure —
               the index plane — is identical, so the pixel is accepted
               when the C index, re-resolved through the master VICEROY.PAL
               or a palette a sheet on this screen authored, equals the JS.

That acceptance is a permanent model difference, not a bug, but it is also
exactly what a wrong RUNTIME palette produces — same index, different RGB —
and that is how the sandy sea lane sat green for weeks (REMAINING_WORK.md
G2).  So the count is CEILINGED: PALETTE_CEILING freezes today's measured
acceptance count for every default scene, and a run that exceeds its
ceiling FAILS even at 0 structural.  Lowering a ceiling is free and
expected (do it the day a fix drops the count); raising one is a ledger
event — say which palette-model delta grew and why.

A scene the table does not know is reported as UNFROZEN and not bounded;
freeze it here the moment it becomes a standing oracle.
"""
from __future__ import annotations

import base64
import io
import sys
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
SCRATCH = ROOT / "cport" / "pak"
W, H = 320, 200

# scene key -> frozen ceiling on palette-model acceptances.
#
# The key is the oracle's name followed by its arguments EXACTLY as the tool
# resolves them (defaults filled in; an empty speaker is "-"), so a
# non-default invocation is simply unfrozen and says so.  Measured
# 2026-09-02 on the committed fixtures, all seven at 0 structural.
PALETTE_CEILING = {
    "boot title 0": 0,
    "map sav1653 20 30 0 -1 0": 37,
    "colony sav1653 0 -1 0 0 1": 141,
    "europe sav1653 0 0 0 -1": 0,
    "report sav1653 F5": 0,
    "event RAIDSTORES 0 0 - sav1653": 31,
    "woodcut sav1653 1": 21438,
}


def master_palette() -> bytes:
    """VICEROY.PAL widened 6->8 bit the way the engine's DAC upload does."""
    pal6 = (ROOT / "raw/COLONIZE/VICEROY.PAL").read_bytes()[:768]
    return bytes(((v << 2) | (v >> 4)) & 0xFF for v in pal6)


def sheet_palette(name: str) -> bytes | None:
    """The palette embedded in raw/COLONIZE/<name>, or None if absent."""
    f = ROOT / "raw/COLONIZE" / name
    if not f.exists():
        return None
    sys.path.insert(0, str(ROOT / "tools"))
    import ssdec
    return bytes(ssdec.load_sheet(str(f))["pal"])


def js_frame(data_url: str) -> Image.Image:
    """sim_trace's render output (a PNG data: URL) as an RGB image."""
    png = base64.b64decode(data_url.split(",", 1)[1])
    return Image.open(io.BytesIO(png)).convert("RGB")


def c_frame(out: Path) -> tuple[Image.Image, bytes]:
    """smoke's --render output: the RGB frame and its 320x240 index plane."""
    cim = Image.open(out).convert("RGB")
    idx = Path(str(out) + ".idx").read_bytes()[:320 * 240]
    return cim, idx


def _accepted(jp, cp, idx, accept, x, y) -> bool:
    i = idx[y * 320 + x]
    return any(jp[x, y] == tuple(p8[i * 3:i * 3 + 3]) for p8 in accept)


def diff_frames(js, cim, idx, accept):
    """-> (structural, accepted, first).  `accept` is the list of palettes
    a C index may legitimately resolve through (master first)."""
    jp, cp = js.load(), cim.load()
    structural = accepted = 0
    first = None
    for y in range(H):
        for x in range(W):
            if jp[x, y] == cp[x, y]:
                continue
            # SCOPE-REASON: structural -- the JS atlas model vs the C
            # single-DAC model resolve one index through different
            # palettes; a permanent difference, BOUNDED by PALETTE_CEILING
            # in verdict() so a runtime-palette fault cannot hide in it (G2).
            if _accepted(jp, cp, idx, accept, x, y):
                accepted += 1
                continue
            structural += 1
            if first is None:
                first = (x, y, jp[x, y], cp[x, y], idx[y * 320 + x])
    return structural, accepted, first


def diff_image(js, cim, idx, accept) -> Image.Image:
    """The C frame with every STRUCTURAL pixel painted magenta."""
    jp, cp = js.load(), cim.load()
    d = Image.new("RGB", (W, H))
    dp = d.load()
    for y in range(H):
        for x in range(W):
            hit = jp[x, y] != cp[x, y] and not _accepted(jp, cp, idx, accept, x, y)
            dp[x, y] = (255, 0, 255) if hit else cp[x, y]
    return d


def verdict(scene: str, structural: int, accepted: int) -> int:
    """Exit status for a run: 1 on any structural pixel (the standing
    gate), 3 when the palette-model acceptances exceed the scene's frozen
    ceiling, else 0.  Prints the ceiling verdict either way."""
    ceiling = PALETTE_CEILING.get(scene)
    if ceiling is None:
        print("  palette-model acceptances %d: UNFROZEN scene %r -- no "
              "ceiling applies; freeze it in tools/render_common.py "
              "PALETTE_CEILING if this is a standing oracle" % (accepted, scene))
    elif accepted > ceiling:
        print("PALETTE CEILING EXCEEDED for %s: %d accepted > %d frozen.\n"
              "  Same index, different RGB is what a wrong runtime palette "
              "looks like (REMAINING_WORK.md G2).  Find the palette that "
              "changed; raise the ceiling in tools/render_common.py only "
              "with a ledger note saying why." % (scene, accepted, ceiling))
    elif accepted < ceiling:
        print("  palette-model acceptances %d <= ceiling %d for %s -- below "
              "it; lower the ceiling to %d to keep the gate tight"
              % (accepted, ceiling, scene, accepted))
    else:
        print("  palette-model acceptances %d == ceiling for %s"
              % (accepted, scene))
    if structural:
        return 1
    if ceiling is not None and accepted > ceiling:
        return 3
    return 0
