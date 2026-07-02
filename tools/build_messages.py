#!/usr/bin/env python3
"""Build the message catalog: every GAME.TXT @KEY as a record {key, text, box_w, x, y, sprite}.

The message IS the data. A ShowPopup/Notify carries only the @KEY; the displayed text is the
verbatim GAME.TXT body (no authored title/body), sized to the box the original used, with its
associated sprite. Text + geometry come byte-accurately from GAME.full.json (the @width/@x/@y
directives); the woodcut/scene sprite comes from the spec/ui/popups.md associations.

box_h is not stored -- it's computed at render from the line count (popups.md content_h). box_w
is the @width floor (0 = auto-fit to the longest line). x/y = -1 means centered. sprite is a
sprite-catalog id (woodcut.*) or "" (unknown/none). Usage: python3 tools/build_messages.py
"""
import json, os

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Woodcut <-> key associations, grounded in spec/ui/popups.md (lines 268/305/333/383/400/463).
WOODCUT = {
    "woodcut.wdcut04": ["@CASHTREASURE", "@KINGGALLEON2", "@KINGGALLEON3", "@LOOT", "@LOOT2",
                        "@LOOTCAPTURE", "@LOOTCASH", "@LOOTFOREIGN", "@NOLOOT", "@BURIAL", "@BURIAL2",
                        "@BURIAL3", "@LOSTCITY", "@TREASURE"],
    "woodcut.wdcut10": ["@ARTILLERY", "@ARTILLERY2", "@CARGOCAPTURE", "@COLONISTCAPTURE",
                        "@COLONISTCAPTURE2", "@DEMOTE", "@SHIPDAMAGE", "@VALOR", "@VETERAN",
                        "@WAGONCAPTURE", "@WELLSEASONED"],
    "woodcut.wdcut11": ["@BURNED", "@BURNED2", "@BURNED3", "@CAPTURED", "@CAPTURED2", "@CAPTURED3",
                        "@EUROPELOSE", "@EUROPEWIN", "@INDIANBURNCOLONY", "@INDIANBURNCOLONY2",
                        "@INDIANWINCOLONY", "@INDIANWINCOLONY2"],
    "woodcut.wdcut12": ["@CHIEFKILL", "@INDIANBURN", "@INDIANGOLD"],
    "woodcut.wdcut13": ["@INDIAN", "@INDIANGRUDGE", "@INDIANSURPRISE", "@INDIANWAR", "@INDIANWARFARE",
                        "@INDIANWARPATH", "@INDIANWARPATH2"],
}
KEY2WOODCUT = {}
for wc, keys in WOODCUT.items():
    for k in keys: KEY2WOODCUT[k] = wc

# Speaker-portrait channels (spec/ui/popups.md 2.7 + the per-section Speaker lines,
# byte-cited): "KING1" = the king channel [0x1F5C]=8 (func_06F5DA / func_06BE92's
# >7 branch -> KING1.SS); "IND" = the tribe channel (value = the tribe index at
# fire time -> IND<n>A<pose>.SS); "MYR" = the missionary channel [0x1F60] ->
# MYR<n>.SS. Keys not listed carry no speaker (channel 0xFFFF).
SPEAKER = {
    "KING1": [  # 3 king tax demand + 16 treasure delivery
        "@KINGTAX", "@KINGRAISE", "@KINGLOWER", "@KINGNOTHING", "@MERCANTILISM",
        "@PURCHASETAX", "@KINGNAVACT", "@KINGSTAMPACT", "@KINGWAR", "@KINGWIFE",
        "@TAXOPTIONS", "@TEAPARTY", "@CASHTREASURE", "@KINGGALLEON2", "@KINGGALLEON3",
        "@LOOTCASH", "@KINGNEWWAR",
    ],
    "IND": [    # 4/5/6/7 native raze/attitude/gift/raid + village teaching
        "@CHIEFKILL", "@INDIANGOLD", "@INDIANBURN", "@VILLAGEWAR", "@MADATSHIPS",
        "@MADATWAGONS", "@DONTKNOWSHIPS", "@INDIANGIVEFOOD", "@INDIANGIVESTUFF",
        "@INDIANSCONVERT", "@CHIEFGIFT", "@CHIEFGUIDES", "@CHIEFAREA", "@CHIEFHOWDY",
        "@CHIEFBORED", "@TRADE0", "@TRADE1", "@TRADEWITH", "@TRADENOCARGO",
        "@TRADENOWANT", "@RAIDWREAK", "@RAIDSTORES", "@RAIDBURN", "@RAIDSHIP",
        "@RAIDGOLD", "@RAIDNOTHING", "@INDIANWARPATH", "@INDIANWARPATH2",
        "@INDIANWARFARE", "@INDIANWAR", "@INDIANGRUDGE", "@INDIANSURPRISE",
        "@LEARNDONE", "@LEARNSLOW", "@LEARNCRIMINAL", "@LEARNMASTER", "@LEARNALREADY",
    ],
    "MYR": [    # 11 heresy denunciation
        "@HERESY0", "@HERESY1", "@MISSION0", "@MISSION1", "@MISSION2", "@MISSION3",
    ],
}
KEY2SPEAKER = {}
for sp, keys in SPEAKER.items():
    for k in keys: KEY2SPEAKER[k] = sp
# Advisor-portrait channel (MSS0..MSS5), extracted from the EXE emit sites
# (data_extracted/engine/speaker_advisor.json: the emit wrapper's ARG ->
# [0x1F5E], popups.md 2.7). The KING/IND/MYR channels above take precedence
# where both are set (the dispatcher fires every channel >= 0; the renderer
# shows the primary).
try:
    with open(os.path.join(ROOT, "data_extracted/engine/speaker_advisor.json")) as f:
        _adv = json.load(f).get("channels", {})
    for k, ch in _adv.items():
        KEY2SPEAKER.setdefault(k, "MSS%d" % ch)
except FileNotFoundError:
    pass

def to_int(v, default):
    try: return int(v)
    except (ValueError, TypeError): return default

def main():
    full = json.load(open(os.path.join(ROOT, "data_extracted/text/GAME.full.json")))
    sections = full["sections"]
    rows = []
    for key, sec in sections.items():
        dv = sec.get("directives", {})
        rows.append({
            "key": key,
            "text": sec.get("body", ""),
            "box_w": to_int(dv.get("width"), 0),      # @width floor; 0 = auto-fit
            "x": to_int(dv.get("x"), -1),             # -1 = centered
            "y": to_int(dv.get("y"), -1),
            "sprite": KEY2WOODCUT.get(key, ""),       # woodcut/scene sprite id or ""
            "speaker": KEY2SPEAKER.get(key, ""),      # portrait channel: KING1/IND/MYR or ""
            "default": dv.get("default", ""),         # @default: pre-highlighted choice
        })                                            #   (1-based index, or a text default)
    with_w = sum(1 for r in rows if r["box_w"])
    with_d = sum(1 for r in rows if r["default"])
    with_s = sum(1 for r in rows if r["sprite"])
    with_sp = sum(1 for r in rows if r["speaker"])
    out = {"_note": ("The message catalog: each GAME.TXT @KEY -> its verbatim text + the box size / "
                     "placement the original used (@width/@x/@y from GAME.full.json) + associated "
                     "sprite (sprite-catalog id). ShowPopup/Notify reference only the key; the runtime "
                     "renders this record. Generated by tools/build_messages.py."),
           "count": len(rows), "with_box_w": with_w, "with_sprite": with_s,
           "with_speaker": with_sp, "with_default": with_d, "messages": rows}
    json.dump(out, open(os.path.join(ROOT, "data_extracted/engine/messages.json"), "w"), indent=1)
    print(f"messages.json: {len(rows)} messages, {with_w} with @width, {with_s} with a sprite, "
          f"{with_sp} with a speaker, {with_d} with @default")

if __name__ == "__main__":
    main()
