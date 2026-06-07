#!/usr/bin/env python3
"""
audit_tag.py — Stamp RECONSTRUCTED files in viceroy_source/ with a clear
header banner so anyone reading them sees the verification status before
trusting any value or formula.

Run: python audit_tag.py
"""
from __future__ import annotations
import os
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "viceroy_source"

# --- Files explicitly RECONSTRUCTED (need byte-verification work) ----------
RECONSTRUCTED_C = [
    "data/terrain_yield.c",
    "data/unit_classes.c",
    "data/building_costs.c",
    "data/ff_effects.c",
    "data/kings_demands.c",
    "data/scenario_starts.c",
    "data/commodity_prices.c",
    "data/tribe_data.c",
    "src/render/terrain.c",
    "src/render/units.c",
    "src/render/hud.c",
    "src/render/tile_chain.c",
    "src/combat/resolve.c",
    "src/combat/modifiers.c",
    "src/combat/demotion.c",
    "src/market/pricing.c",
    "src/market/boycott.c",
    "src/king/demands.c",
    "src/king/ref.c",
    "src/native/settlement.c",
    "src/native/raid.c",
    "src/native/mission.c",
    "src/founding_fathers/recruit.c",
    "src/founding_fathers/effects.c",
    "src/random_events/lcr.c",
    "src/random_events/weather.c",
    "src/random_events/disease.c",
    "src/scoring/compute.c",
    "src/scoring/endgame.c",
    "src/ai/driver.c",
    "src/ai/unit_orders.c",
    "src/ai/colony_orders.c",
    "src/diplomacy/treaty.c",
    "src/diplomacy/relations.c",
    "src/mapgen/generator.c",
    "src/mapgen/climate.c",
    "src/mapgen/rivers.c",
    "src/mapgen/settlements.c",
    "src/save/save_serializer.c",
    "src/save/load_deserializer.c",
    "src/audio/audio_device.c",
    "src/audio/sound_dispatch.c",
    "src/asset/asset_loader.c",
    "src/ui/title_screen.c",
    "src/ui/colony_screen.c",
    "src/ui/europe_screen.c",
    "src/ui/dialog.c",
    "src/ui/hall_of_fame.c",
    "src/ui/main_loop.c",
]

RECONSTRUCTED_HEADERS = [
    "include/power.h",
    "include/ai_personality.h",
    "include/native.h",
    "include/ff.h",
    "include/market.h",
    "include/save.h",
    "include/building.h",
]

RECONSTRUCTED_DOCS = [
    "docs/DATA_MODEL.md",
    "docs/MAP_SYSTEM.md",
    "docs/COLONY_SYSTEM.md",
    "docs/UNIT_SYSTEM.md",
    "docs/COMBAT.md",
    "docs/AI_SYSTEM.md",
    "docs/NATIVE_RELATIONS.md",
    "docs/EUROPEAN_DIPLOMACY.md",
    "docs/KING_TAX.md",
    "docs/REVOLUTION.md",
    "docs/FOUNDING_FATHERS.md",
    "docs/RANDOM_EVENTS.md",
    "docs/MAP_GENERATION.md",
    "docs/SCORING.md",
    "docs/RENDER_CHAIN.md",
    "docs/ASSET_ROLES.md",
    "docs/RTLINK_OVERLAYS.md",
    "docs/ENGINE.md",
]

C_BANNER = """\
/* ============================================================================
 *                  >>> RECONSTRUCTED — NOT BYTE-VERIFIED <<<
 * ----------------------------------------------------------------------------
 * The values, formulas, and offsets in this file are reconstructed from
 * accumulated playthrough knowledge and the project's prior reverse-engineering
 * work. They have NOT been confirmed by reading bytes from VICEROY.EXE or by
 * hand-decompiling the relevant overlay function.
 *
 * DO NOT TRUST any specific number, table value, or formula in this file
 * for gameplay decisions. To upgrade an entry to BYTE_VERIFIED, follow the
 * methodology in viceroy_source/VERIFICATION_LEDGER.md.
 *
 * Status of every claim in this file: RECONSTRUCTED (until proven otherwise).
 * ============================================================================ */

"""

MD_BANNER = """\
> **>>> RECONSTRUCTED — NOT BYTE-VERIFIED <<<**
>
> The formulas, tables, and specific numbers in this document are reconstructed
> from accumulated playthrough knowledge and prior reverse-engineering notes.
> They have **not** been confirmed by reading bytes from VICEROY.EXE.
>
> Treat every numerical claim as RECONSTRUCTED until cross-referenced to a
> hand-decompiled function in `code/VICEROY/decompiled.md` or to bytes
> documented in `viceroy_source/VERIFICATION_LEDGER.md`.

"""

H_BANNER = C_BANNER  # same C-comment style works for headers

MARKER = ">>> RECONSTRUCTED — NOT BYTE-VERIFIED <<<"


def stamp(path: Path, banner: str) -> bool:
    if not path.exists():
        print(f"MISSING: {path}", file=sys.stderr)
        return False
    text = path.read_text(encoding="utf-8")
    if MARKER in text:
        return False  # already stamped
    path.write_text(banner + text, encoding="utf-8")
    return True


def main() -> int:
    stamped = 0
    for rel in RECONSTRUCTED_C:
        if stamp(ROOT / rel, C_BANNER):
            stamped += 1
    for rel in RECONSTRUCTED_HEADERS:
        if stamp(ROOT / rel, H_BANNER):
            stamped += 1
    for rel in RECONSTRUCTED_DOCS:
        if stamp(ROOT / rel, MD_BANNER):
            stamped += 1
    print(f"Stamped {stamped} files with RECONSTRUCTED banner")
    return 0


if __name__ == "__main__":
    sys.exit(main())
