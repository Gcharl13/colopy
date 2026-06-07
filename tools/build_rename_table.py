#!/usr/bin/env python3
"""
build_rename_table.py — Build the FUN_/DAT_ substitution table from
FUNCTION_INVENTORY.md and DATA_MODEL.md.

Output: tools/rename_table.json with entries:
  {
    "FUN_": [
      {"original": "FUN_04a7ca", "rename_to": "native_village_raze", "source": "func_04A7CA"},
      ...
    ],
    "DAT_": [
      {"original": "DAT_2b5a_53a6", "rename_to": "g_difficulty", ...},
      ...
    ],
    "LCALL_helpers": [
      {"original": "LCALL 0x181F:0x04D4", "rename_to": "random_int(...)"},
      ...
    ]
  }

This table is the input to rename_pass.py which transforms a Ghidra
C export by applying these substitutions.

Each rename is documented (linked back to a BYTE_VERIFIED claim in
FUNCTION_INVENTORY.md or DATA_MODEL.md). Future-extensible: add new
entries by editing the source markdown.
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


# Hand-curated table sourced from FUNCTION_INVENTORY.md, DATA_MODEL.md,
# and the BYTE_VERIFIED entries across viceroy_source/.
# Each entry: (ghidra_symbol_pattern, replacement, brief_role)

FUN_RENAMES = [
    # C-runtime helpers (from sigmatch.json)
    ("FUN_103D4", "rand",                           "MSC 6.0 LCG"),
    ("FUN_103C2", "srand",                          "MSC 6.0 srand"),
    ("FUN_C322",  "random_int",                     "random_int(lo, hi)"),
    ("FUN_10530", "_aFlmul",                        "32x32 multiply"),
    ("FUN_10496", "_aFldiv",                        "signed long divide"),
    ("FUN_FDB4",  "strcpy_near",                    "MSC 6.0 strcpy"),
    ("FUN_FD74",  "strcat_near",                    "MSC 6.0 strcat"),
    # Game runtime
    ("FUN_BC10",  "power_attribute_bit",            "PowerRecord bitfield reader"),
    ("FUN_48CC",  "clamp_value_lo_hi",              "clamp(v, lo, hi)"),
    ("FUN_81C6",  "set_active_tribe",               "sets g_settlement_ptr_8D4E"),
    ("FUN_513C",  "output_flush_helper",            "conditional flush"),
    ("FUN_50BC",  "set_message_context",            "set_message_context(code)"),
    ("FUN_8110",  "get_power_name_word",            "EU vs native name lookup"),
    ("FUN_6E94",  "decrement_power_unit_count",     "destroy_unit primitive"),
    ("FUN_7F34",  "get_per_power_byte",             "EU/native universal accessor"),
    ("FUN_6204",  "terrain_normalize",              "auto-forest mapping"),
    # Game-system entry points (BYTE_VERIFIED)
    ("FUN_4A7CA", "native_village_raze_chiefkill",  "CHIEFKILL gold formula"),
    ("FUN_57F4E", "diplomacy_meeting_smite",        "diplomacy + SMITE"),
    ("FUN_5CA7E", "colony_burn_capture",            "colony burn / capture"),
    ("FUN_5BE84", "native_raid_outcome_dispatcher", "6 raid outcomes"),
    ("FUN_5C878", "treasure_transport_galleon",     "King's Galleon event"),
    ("FUN_34AE0", "king_attempt_tax_change",        "king tax raise/lower"),
    ("FUN_34318", "tea_party_apply_tax",            "tax cap = 75"),
    ("FUN_5B2C2", "combat_resolver",                "combat + demotion ladder"),
    ("FUN_2D658", "colony_production_handler",      "colony screen production"),
    ("FUN_2883E", "townhall_assembly_services",     "Liberty Bell production"),
    ("FUN_22542", "colony_founding_validity_check", "can colony be founded here"),
    ("FUN_36138", "king_actions_dispatcher",        "king events (turn>=30)"),
    ("FUN_4A426", "native_learning_trainer",        "colonist trains in village"),
    ("FUN_4AC00", "native_extortion",               "extort gold from natives"),
    ("FUN_4B036", "native_war_declaration",         "declare war on tribe"),
    ("FUN_4B308", "tribe_attitude_display",         "5-level attitude"),
    ("FUN_49600", "native_trade_haggling",          "BUY/SELL with natives"),
    ("FUN_4E2D6", "ai_action_dispatcher",           "11 AI actions"),
    ("FUN_6F0F4", "dialog_framework",               "the dialog layout engine"),
    ("FUN_6EEEC", "text_template_parser",           "$COUNTRY$ etc. substitution"),
    ("FUN_72090", "top_menu_bar_dispatcher",        "game/menu/orders/pedia/etc."),
    ("FUN_2F052", "king_events_refit",              "KINGTAX/REFIT"),
    ("FUN_3DE46", "independence_event",             "INDEPENDENCE event"),
    ("FUN_3E984", "declaration_guard",              "ALREADYREVOLUTION guard"),
    ("FUN_3ECF0", "diplomatic_actions_menu",        "right-click unit options"),
    ("FUN_3E844", "sons_of_liberty_display",        "REBELUP/DOWN message"),
    ("FUN_3D948", "intervention_event",             "French intervention"),
    ("FUN_3FDDE", "ship_combat_event",              "naval events"),
    ("FUN_2F3A2", "win_lose_check",                 "iterate colonies of player"),
    ("FUN_3A9C0", "score_formula",                  "964-byte stack frame"),
    ("FUN_3ADA6", "hall_of_fame_writer",            "HALLFAME.DAT writer"),
    ("FUN_5A20E", "scout_interactions",             "SCOUTCOLONY events"),
    ("FUN_4A37C", "wagon_train_kill",               "KILLWAGONS"),
    ("FUN_749E0", "scenario_loader",                "reads 40 NAMES.TXT sections"),
    ("FUN_2B744", "buy_commodity",                  "BUYME0"),
    ("FUN_305A8", "market_price_drift",             "PRICEUP/PRICEDOWN"),
    ("FUN_20F50", "tutorial_dispatcher",            "TUTORIAL1..19"),
    # RTLink dispatch
    ("FUN_11D91", "rtlink_dispatcher_main",         "353 callers"),
    ("FUN_11DAB", "rtlink_dispatcher_partner",      "smart vectoring"),
    ("FUN_13BED", "entry_point",                    "MZ entry"),
    ("FUN_1072A", "cstart",                         "C startup"),
    ("FUN_12CF7", "startup_helper",                 "DGROUP setup"),
    ("FUN_1A5F0", "_main",                          "first overlay thunk"),
]


DAT_RENAMES = [
    # Game-state globals (from DATA_MODEL.md, BYTE_VERIFIED)
    ("DAT_18E",   "g_terrain_display_mode",         "auto-forest function"),
    ("DAT_28EE",  "g_rand_seed_low",                "RNG seed low word"),
    ("DAT_28F0",  "g_rand_seed_high",               "RNG seed high word"),
    ("DAT_372",   "g_score_accumulator",            "from func_03A9C0"),
    ("DAT_5382",  "g_game_flags",                   "bit 0 = endgame"),
    ("DAT_538A",  "g_turn_alt_counter",             "alt turn counter"),
    ("DAT_538E",  "g_turn_counter",                 "main turn counter"),
    ("DAT_5398",  "g_current_human_player",         "self-marker"),
    ("DAT_53A6",  "g_difficulty_or_player",         "0..4 difficulty / current player"),
    ("DAT_53D2",  "g_self_power",                   "SOL display"),
    ("DAT_84FC",  "g_king_record_ptr",              "king/payer record"),
    ("DAT_8542",  "g_active_colony_ptr",            "current colony"),
    ("DAT_853A",  "g_map_width",                    ""),
    ("DAT_853C",  "g_map_height",                   ""),
    ("DAT_8D4E",  "g_active_tribe_record_ptr",      "set by set_active_tribe"),
    ("DAT_8D50",  "g_active_tribe_power_idx",       "= tribe_idx + 4"),
    ("DAT_8D52",  "g_active_tribe_idx",             "0..7"),
    # Tables (base addresses)
    ("DAT_3146",  "g_unit_table",                   "UnitRecord[N], stride 0x1C"),
    ("DAT_540E",  "g_aipersonality_table",          "AIPersonality[N], stride 0x34"),
    ("DAT_5AD6",  "g_tribe_data_table",             "TribeData[N], stride 78"),
    ("DAT_8809",  "g_powerrecord_table",            "PowerRecord[N], stride 0x13C"),
    ("DAT_8904",  "g_market_state_table",           "stride 79*4 = 316 bytes"),
    ("DAT_8CFC",  "g_per_power_unit_count",         "byte per power"),
    ("DAT_9298",  "g_per_power_active_flag",        "byte per power"),
    ("DAT_940C",  "g_per_power_stockpile",          "byte per power"),
    ("DAT_941C",  "g_per_power_word_factor",        "word table (SMITE)"),
    ("DAT_942C",  "g_per_power_byte_factor",        "byte table (SMITE)"),
]


# LCALL helpers — a Ghidra C export shows these as bare LCALL or thunk
# calls; we replace with named function calls.
LCALL_HELPERS = [
    ("0x181F:0x07B4", "power_attribute_bit"),
    ("0x181F:0x04D4", "random_int"),
    ("0x181F:0x035C", "clamp_value_lo_hi"),
    ("0x181F:0x04B6", "output_flush_helper"),
    ("0x181F:0x048E", "set_message_context"),
    ("0x181F:0x09A4", "get_power_name_word"),
    ("0x181F:0x0808", "decrement_power_unit_count"),
    ("0x181F:0x0A38", "get_per_power_byte"),
    ("0xD1D:0x07E4",  "strcpy_near"),
    ("0xD1D:0x07A4",  "strcat_near"),
    ("0xD1D:0x0F60",  "_aFlmul"),
    ("0xD1D:0x0EC6",  "_aFldiv"),
    ("0xD1D:0x0E04",  "rand"),
    ("0xD1D:0x0DF2",  "srand"),
]


def main():
    table = {
        "FUN_renames": [
            {"original": orig.upper(), "rename_to": new, "role": role,
             "case_variants": [orig.upper(), orig.lower()]}
            for orig, new, role in FUN_RENAMES
        ],
        "DAT_renames": [
            {"original": orig.upper(), "rename_to": new, "role": role,
             "case_variants": [orig.upper(), orig.lower()]}
            for orig, new, role in DAT_RENAMES
        ],
        "LCALL_helpers": [
            {"original": orig, "rename_to": new}
            for orig, new in LCALL_HELPERS
        ],
        "metadata": {
            "fun_count": len(FUN_RENAMES),
            "dat_count": len(DAT_RENAMES),
            "lcall_count": len(LCALL_HELPERS),
            "source": "FUNCTION_INVENTORY.md + DATA_MODEL.md (BYTE_VERIFIED entries)",
        }
    }
    out = ROOT / "tools" / "rename_table.json"
    out.write_text(json.dumps(table, indent=2))
    print(f"Wrote rename table to {out}")
    print(f"  {len(FUN_RENAMES)} FUN_ renames")
    print(f"  {len(DAT_RENAMES)} DAT_ renames")
    print(f"  {len(LCALL_HELPERS)} LCALL helper renames")


if __name__ == "__main__":
    sys.exit(main())
