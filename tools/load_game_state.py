#!/usr/bin/env python3
"""
load_game_state.py — Extract a complete game-state snapshot from a
DOSBox memory dump for use by renderer scripts.

This is the byte-cited replacement for SAMPLE_STATE in the various
render_*.py modules. Every field returned has a verified DGROUP /
PowerRecord / ColonyRecord offset documented in
`docs/DATA_MODEL.md`.

Usage:
    state = load_state('session_1777952458/mem/1310196718000000.zst')
    # state is a dict with all known game fields

The returned dict is consumable by the render_*.py modules — they
should replace their internal SAMPLE_STATE = {...} with a call to
this function.
"""
from __future__ import annotations

import json
import struct
import sys
from pathlib import Path

try:
    import zstandard as zstd
except ImportError:
    print("zstandard not installed: pip install zstandard", file=sys.stderr)
    sys.exit(1)

# ---------------------------------------------------------------------
# Constants from NAMES.TXT and verified runtime extraction
# ---------------------------------------------------------------------

NATION_NAMES = ["English", "French", "Spanish", "Dutch"]
TRIBE_NAMES = ["Inca", "Aztec", "Arawak", "Iroquois",
               "Cherokee", "Apache", "Sioux", "Tupi"]

# NAMES.TXT @CARGO order (16 commodities)
GOODS = ["Food", "Sugar", "Tobacco", "Cotton", "Furs", "Lumber", "Ore",
         "Silver", "Horses", "Rum", "Cigars", "Cloth", "Coats",
         "Trade Goods", "Tools", "Muskets"]

# NAMES.TXT @JOB order (28 colonist skills)
JOBS = ["Farmer", "Sugar Planter", "Tobacco Planter", "Cotton Planter",
        "Fur Trapper", "Lumberjack", "Ore Miner", "Silver Miner",
        "Fisherman", "Distiller", "Tobacconist", "Weaver", "Fur Trader",
        "Carpenter", "Blacksmith", "Gunsmith", "Preacher", "Statesman",
        "Teacher", "Colonist", "Pioneer", "Soldier", "Scout", "Dragoon",
        "Missionary", "Ind. Servant", "Criminal", "Convert"]

# NAMES.TXT @UNIT order (24 unit types)
UNITS = ["Colonists", "Soldiers", "Pioneers", "Missionaries", "Dragoons",
         "Scouts", "Regulars", "Cont. Cav.", "Cavalry", "Cont. Army",
         "Treasure", "Artillery", "Wagon Train", "Caravel", "Merchantman",
         "Galleon", "Privateer", "Frigate", "Man-O-War", "Braves",
         "Armed Braves", "Mtd. Braves", "Mtd. Warriors"]

# NAMES.TXT @FATHERS order (25 founding fathers)
FATHERS = ["Adam Smith", "Jakob Fugger", "Peter Minuit",
           "Peter Stuyvesant", "Jan de Witt", "Ferdinand Magellan",
           "Francisco Coronado", "Hernando de Soto", "Henry Hudson",
           "Sieur De La Salle", "Hernan Cortes", "George Washington",
           "Paul Revere", "Francis Drake", "John Paul Jones",
           "Thomas Jefferson", "Pocahontas", "Thomas Paine",
           "Simon Bolivar", "Benjamin Franklin", "William Brewster",
           "William Penn", "Jean de Brebeuf", "Juan de Sepulveda",
           "Bartolome de las Casas"]

# Tile-worker assignment order (per +0x70..+0x77)
TILE_DIRS = ["NW", "N", "NE", "W", "E", "SW", "S", "SE"]


# ---------------------------------------------------------------------
# DGROUP locator
# ---------------------------------------------------------------------

def find_dgroup(data: bytes) -> int:
    """Locate VICEROY's runtime DGROUP base in a DOSBox memory dump."""
    start = 0
    while True:
        p = data.find(b"WOODPANL", start)
        if p < 0:
            raise ValueError("WOODPANL anchor not found")
        cand = p - 0x2189
        if cand < 0:
            start = p + 1
            continue
        rect = struct.unpack_from("<HH", data, cand + 0x839E)
        if rect == (200, 320):
            return cand
        start = p + 1


# ---------------------------------------------------------------------
# Field extractors
# ---------------------------------------------------------------------

def read_ai_personality(data: bytes, dg: int) -> list:
    """Read AIPersonality records for the 4 European powers."""
    out = []
    for p in range(4):
        base = dg + 0x540E + p * 0x34
        rec = data[base:base + 0x34]
        leader = rec[0:0x18].split(b'\x00', 1)[0].decode('latin1', errors='replace')
        country = rec[0x18:0x30].split(b'\x00', 1)[0].decode('latin1', errors='replace')
        out.append({
            "power_idx": p,
            "leader_name": leader.strip(),
            "country_name": country.strip(),
            "is_active": rec[0x31],
        })
    return out


def read_globals(data: bytes, dg: int) -> dict:
    """Read DGROUP scalar globals."""
    return {
        # Game state
        "year":         struct.unpack_from("<H", data, dg + 0x538A)[0],
        "turn":         struct.unpack_from("<H", data, dg + 0x538E)[0],
        "active_power": struct.unpack_from("<H", data, dg + 0x5398)[0],
        "self_power":   struct.unpack_from("<H", data, dg + 0x53D2)[0],
        "score":        struct.unpack_from("<H", data, dg + 0x0372)[0],
        "game_flags":   data[dg + 0x5382],
        "king_anger":   data[dg + 0x53A7],
        "rng_seed":     struct.unpack_from("<I", data, dg + 0x28EE)[0],

        # Map dimensions
        "map_width":    struct.unpack_from("<H", data, dg + 0x853A)[0],
        "map_height":   struct.unpack_from("<H", data, dg + 0x853C)[0],

        # REF (Royal Expeditionary Force) at DGROUP:0x53DA
        "ref_regulars":  struct.unpack_from("<H", data, dg + 0x53DA)[0],
        "ref_cavalry":   struct.unpack_from("<H", data, dg + 0x53DC)[0],
        "ref_man_o_war": struct.unpack_from("<H", data, dg + 0x53DE)[0],
        "ref_artillery": struct.unpack_from("<H", data, dg + 0x53E0)[0],

        # Active record pointers
        "active_power_ptr":  struct.unpack_from("<H", data, dg + 0x84FC)[0],
        "active_colony_ptr": struct.unpack_from("<H", data, dg + 0x8542)[0],
    }


def read_power_record(data: bytes, dg: int, power_idx: int) -> dict:
    """Read a 316-byte PowerRecord for a European power (0..3)."""
    base = dg + 0x8808 + power_idx * 0x13C
    rec = data[base:base + 0x13C]

    # FF acquired bitmask at +0x07
    ff_bitmask = struct.unpack_from("<I", rec, 0x07)[0]
    ff_acquired = [FATHERS[i] for i in range(25) if ff_bitmask & (1 << i)]

    # Boycott bitfield at +0x20
    boycott = struct.unpack_from("<H", rec, 0x20)[0]
    goods_boycotted = [GOODS[i] for i in range(16) if boycott & (1 << i)]

    return {
        "power_idx":         power_idx,
        "nation":            NATION_NAMES[power_idx],
        "tax_pct":           rec[0x01],
        "rebel_sentiment":   rec[0x02],
        "tory_sentiment":    100 - rec[0x02],
        "ff_acquired_bitmask": ff_bitmask,
        "ff_acquired":       ff_acquired,
        "bells_toward_next_ff": struct.unpack_from("<H", rec, 0x0C)[0],
        "bells_per_turn":    struct.unpack_from("<H", rec, 0x0E)[0],
        "crosses_per_turn":  struct.unpack_from("<H", rec, 0x10)[0],
        "ff_count":          struct.unpack_from("<H", rec, 0x14)[0],
        "boycott_bitfield":  boycott,
        "goods_boycotted":   goods_boycotted,
        # royal_money — King's REF expansion budget (verified via
        # pavelbel/smcol_saves_utility schema cross-ref 2026-05-07)
        "royal_money":       struct.unpack_from("<i", rec, 0x22)[0],
        "gold":              struct.unpack_from("<I", rec, 0x2A)[0],
        "recruit_cost":      struct.unpack_from("<H", rec, 0x30)[0],
        "ref_strength":      struct.unpack_from("<H", rec, 0x32)[0],
        # Per-good market pool at +0x5C..+0x7B (16 × s16)
        "market_pool":       [struct.unpack_from("<h", rec, 0x5C + i*2)[0]
                              for i in range(16)],
        # Per-good price/sensitivity at +0x4C..+0x5B
        "market_price":      [rec[0x4C + i] for i in range(16)],
    }


def read_colony_record(data: bytes, dg: int, colony_ptr: int) -> dict:
    """Read a 202-byte ColonyRecord at DGROUP+colony_ptr."""
    base = dg + colony_ptr
    rec = data[base:base + 202]

    # Name
    name = rec[2:0x1A].split(b'\x00', 1)[0].decode('latin1', errors='replace').strip()

    # Colonist job-skills (length = +0x1F size; cap at remaining record bytes)
    size = rec[0x1F]
    safe_size = min(size, 0x70 - 0x40)  # don't read past job-skill region
    job_skills = [rec[0x40 + i] for i in range(safe_size)]
    job_names = [JOBS[j] if 0 <= j < len(JOBS) else f"job_{j}" for j in job_skills]

    # Tile worker assignment (8 bytes, NW/N/NE/W/E/SW/S/SE)
    tile_workers = []
    for i, direction in enumerate(TILE_DIRS):
        worker_idx = rec[0x70 + i]
        if worker_idx == 0xFF:
            tile_workers.append({"dir": direction, "worker": None})
        else:
            skill = None
            if worker_idx < size:
                job_id = job_skills[worker_idx]
                if 0 <= job_id < len(JOBS):
                    skill = JOBS[job_id]
                else:
                    skill = f"job_{job_id}"
            tile_workers.append({
                "dir": direction,
                "worker": worker_idx,
                "skill": skill,
            })

    # Stockpile (16 × u16 at +0x9A)
    stockpile = {GOODS[i]: struct.unpack_from("<H", rec, 0x9A + i*2)[0]
                 for i in range(16)}

    # Buildings constructed bitmask at +0x60..+0x65 (u48 LE)
    buildings_lo = struct.unpack_from("<I", rec, 0x60)[0]
    buildings_hi = struct.unpack_from("<H", rec, 0x64)[0]
    buildings_bitmask = buildings_lo | (buildings_hi << 32)
    buildings_built_indices = [i for i in range(48)
                                if buildings_bitmask & (1 << i)]

    return {
        "ptr":           colony_ptr,
        "map_x":         rec[0x00],
        "map_y":         rec[0x01],
        "name":          name,
        "owner_idx":     rec[0x1A],
        "owner":         NATION_NAMES[rec[0x1A]] if rec[0x1A] < 4 else f"power_{rec[0x1A]}",
        "size":          size,
        "colony_state":  struct.unpack_from("<H", rec, 0x22)[0],
        "job_skills":    job_skills,
        "job_names":     job_names,
        "tile_workers":  tile_workers,
        "stockpile":     stockpile,
        "buildings_bitmask": buildings_bitmask,
        "buildings_built_indices": buildings_built_indices,
        "buildings_count": len(buildings_built_indices),
        # rebel_dividend / rebel_divisor — Sons of Liberty fraction
        # (verified via pavelbel/smcol_saves_utility schema cross-ref 2026-05-07)
        "rebel_dividend": struct.unpack_from("<i", rec, 0xC2)[0],
        "rebel_divisor":  struct.unpack_from("<i", rec, 0xC6)[0],
        "sol_pct":        (100 * struct.unpack_from("<i", rec, 0xC2)[0]
                           // max(struct.unpack_from("<i", rec, 0xC6)[0], 1)),
    }


def read_native_settlements(data: bytes, dg: int) -> list:
    """Read NativeSettlement table (max 60 entries, stride 18)."""
    out = []
    for k in range(60):
        off = 0x54EC + k * 18
        rec = data[dg + off:dg + off + 18]
        x, y = rec[0], rec[1]
        if x == 0 and y == 0:
            continue
        owner_idx = rec[2]
        # Tribe name from owner power_idx (4..11 = tribes)
        if owner_idx >= 4:
            tribe = TRIBE_NAMES[owner_idx - 4] if owner_idx < 12 else f"power_{owner_idx}"
        else:
            tribe = f"power_{owner_idx}"

        flags = rec[3]
        mission = rec[5]
        mission_owner = (mission & 0x0F) if (mission & 0x10) else None
        mission_owner_name = (NATION_NAMES[mission_owner]
                              if mission_owner is not None and mission_owner < 4
                              else None)

        out.append({
            "idx":         k,
            "map_x":       x,
            "map_y":       y,
            "owner_idx":   owner_idx,
            "tribe":       tribe,
            "is_capital":  bool(flags & 0x04),
            "is_visited":  bool(flags & 0x08),
            "population":  rec[4],
            "mission_owner": mission_owner_name,
            "raid_state":  rec[6],
        })
    return out


def read_units(data: bytes, dg: int) -> list:
    """Read UnitRecord table (max 256 entries, stride 28)."""
    out = []
    for k in range(256):
        off = 0x3146 + k * 28
        if off + 28 > 0x10000:
            break
        rec = data[dg + off:dg + off + 28]
        if rec[0] == 0xFF:
            continue
        unit_type = rec[0]
        power_byte = rec[1]
        power_idx = power_byte & 0x0F
        flags = power_byte >> 4
        x = rec[7]
        y = rec[8]

        if unit_type < len(UNITS):
            type_name = UNITS[unit_type]
        else:
            type_name = f"unit_type_{unit_type}"

        if power_idx < 4:
            owner = NATION_NAMES[power_idx]
        elif power_idx >= 4 and power_idx < 12:
            owner = TRIBE_NAMES[power_idx - 4]
        else:
            owner = f"power_{power_idx}"

        out.append({
            "idx":       k,
            "type_idx":  unit_type,
            "type":      type_name,
            "power_idx": power_idx,
            "owner":     owner,
            "flags":     flags,
            "map_x":     x,
            "map_y":     y,
        })
    return out


# ---------------------------------------------------------------------
# Main loader
# ---------------------------------------------------------------------

def load_state(snap_path: str | Path) -> dict:
    """Load a complete game-state snapshot from a .zst memory dump."""
    snap_path = Path(snap_path)
    raw = snap_path.read_bytes()
    if snap_path.suffix == ".zst":
        data = zstd.decompress(raw)
    else:
        data = raw

    dg = find_dgroup(data)

    # Merge AI personality (leader + country names) into power records
    ai = read_ai_personality(data, dg)
    powers = [read_power_record(data, dg, p) for p in range(4)]
    for p, a in zip(powers, ai):
        p["leader_name"] = a["leader_name"]
        p["country_name"] = a["country_name"]
        p["ai_is_active"] = a["is_active"]

    state = {
        "snap_file":   str(snap_path),
        "dgroup_base": dg,
        "globals":     read_globals(data, dg),
        "powers":      powers,
        "colonies":    [],
        "settlements": read_native_settlements(data, dg),
        "units":       read_units(data, dg),
    }

    # Walk colonies — each at known stride 202 bytes from active or known offsets
    # Try to find all colony records by walking from DGROUP:0x5D46 (Jamestown)
    # (alternatively, derive from active_colony_ptr via stride)
    colony_offsets = [0x5D46, 0x5E10, 0x5EDA, 0x5FA4, 0x606E, 0x6138, 0x6202]
    for off in colony_offsets:
        # Verify it's a valid colony (name byte not 0)
        if data[dg + off + 2] != 0:
            state["colonies"].append(read_colony_record(data, dg, off))

    return state


def main() -> int:
    import argparse
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("snap", help="Path to .zst memory snapshot")
    ap.add_argument("--json", action="store_true",
                    help="Output as JSON (default: pretty-print summary)")
    args = ap.parse_args()

    state = load_state(args.snap)

    if args.json:
        print(json.dumps(state, indent=2, default=str))
        return 0

    # Pretty-print summary
    g = state["globals"]
    print(f"=== Game State ({state['snap_file']}) ===")
    print(f"Turn {g['turn']}, Year {g['year']}, Score {g['score']}")
    print(f"Active power: {NATION_NAMES[g['active_power']]}")
    print(f"REF: Reg={g['ref_regulars']}, Cav={g['ref_cavalry']}, "
          f"MoW={g['ref_man_o_war']}, Art={g['ref_artillery']}, "
          f"King anger={g['king_anger']}")
    print(f"\n=== Powers ===")
    for p in state["powers"]:
        leader = p.get('leader_name', '?')
        country = p.get('country_name', '?')
        print(f"  {p['nation']:>8} ({leader} of {country}): tax={p['tax_pct']}% gold={p['gold']:>6}  "
              f"royal_money={p['royal_money']:>5} "
              f"rebel={p['rebel_sentiment']}% bells/turn={p['bells_per_turn']}  "
              f"FF={p['ff_count']} ({', '.join(p['ff_acquired'][:3])})  "
              f"boycotts={p['goods_boycotted']}")
    print(f"\n=== Colonies ({len(state['colonies'])}) ===")
    for c in state["colonies"]:
        stockpile_pop = ", ".join(f"{g}={v}" for g, v in c['stockpile'].items() if v > 0)
        print(f"  {c['name']:>15} ({c['map_x']:>2},{c['map_y']:>2}) {c['owner']:>7} "
              f"size={c['size']} buildings={c['buildings_count']} "
              f"SoL={c['sol_pct']}% ({c['rebel_dividend']}/{c['rebel_divisor']}) "
              f"stock=[{stockpile_pop}]")
    print(f"\n=== Native Settlements ({len(state['settlements'])}) ===")
    by_tribe = {}
    for s in state["settlements"]:
        by_tribe.setdefault(s['tribe'], []).append(s)
    for tribe, lst in by_tribe.items():
        caps = sum(1 for s in lst if s['is_capital'])
        missions = [s for s in lst if s['mission_owner']]
        print(f"  {tribe:>10}: {len(lst)} settlements, {caps} capitals", end="")
        if missions:
            print(f", missions: {[s['mission_owner']+'@'+str((s['map_x'],s['map_y'])) for s in missions]}")
        else:
            print()
    print(f"\n=== Units ({len(state['units'])}) ===")
    from collections import Counter
    type_counts = Counter(u['type'] for u in state['units'])
    for t, n in type_counts.most_common():
        print(f"  {t:>15}: {n}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
