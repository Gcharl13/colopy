#!/usr/bin/env python3
"""Build the VICEROY module map: data_extracted/viceroy_modules.json.

VICEROY.EXE shipped without CodeView debug info, so its source-module
structure has to be reconstructed. Three evidence layers:

  B-tier anchors  - functions carrying a REAL 1994 name + module from the
                    MAPEDIT CodeView fingerprint match
                    (data_extracted/viceroy_named_from_mapedit.json,
                    'exact' matches).
  A-tier runs     - unanchored functions lying BETWEEN two anchors of the
                    same module are assigned to that module (MSC/RTLink
                    lay modules out contiguously; order inversions between
                    the two EXEs mean runs are trusted only locally, never
                    interpolated across different-module anchors).
  A-tier pages    - overlay functions with no engine anchor take their
                    PAGE's game-module identity from PAGE_LABELS below,
                    which is curated from the GAME.TXT emitter evidence
                    (tools/rtlink/event_emitters.json: which message keys
                    a page emits) and the prose screen attributions
                    (docs/UI_PHASE1_ATTRIBUTION.md, docs/UI_AUDIT_TRACKER.md,
                    notes/ATTRIBUTION_OVERLAY.md). Inferred game-module
                    names are marked inferred=true - the real .obj names
                    are unrecoverable without symbols.

Output feeds docs/VICEROY_MODULES.md.
"""
import json
import re
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]

# Game-module identity per overlay page. name/definition are INFERRED (the
# real 1994 .obj names shipped only in MAPEDIT); evidence cites what pins the
# page's mechanic: the GAME.TXT keys its code emits and/or a doc read.
PAGE_LABELS = {
    '01': ('map_input*', 'Main map-screen input dispatcher and unit-order '
           'guards: movement vetoes, colony-siting checks, trade-route '
           'selection, disband.',
           'emits NOPLOW/NOROAD/TOONEAR/SEACOLONY/TUTNO*/TRADESELECT; '
           'func_0246E2 = main map input dispatcher '
           '(docs/UI_PHASE1_ATTRIBUTION.md #5)'),
    '02': ('colony_ui*', 'Colony-screen interaction: rush-buy, schooling, '
           'jobs caps, abandon/stockade guards.',
           'emits BUYME0/1, SCHOOL1, COLLEGE2, MORETHANTHREE, LOBOTOMIZE, '
           'ABANDON, KEEPSTOCKADE, FULL'),
    '03': ('colony_econ*', 'The colony per-turn economy: production, food, '
           'depletion, construction completion, cargo-ready.',
           'emits BUILT/FOOD1/FOOD2/FOODLOW/DEPLETION/CANESUGAR/CARGOREADY0'),
    '04': ('europe_king*', 'Europe harbour screen and the King: tax '
           'audience, back-tax (KISSUP), royal acts, arming options.',
           'emits KINGLOWER/KINGRAISE/KISSUP/KISSSORRY/EUROPESHIPOPTIONS/'
           'ARMOPTIONS/KINGWAR'),
    '05': ('reports*', 'Advisor reports and scoring.',
           'emits EXPLOITS/SCORE/FOREIGNNOTAVAIL'),
    '06': ('revolution*', 'Independence: declaration, intervention, REF '
           'mobilisation, mercenaries.',
           'emits DECLARE/INDEPENDENCE/INTERVENE/KINGMOBILIZE/MERCENARIES'),
    '07': ('naval*', 'Naval movement and war at sea: landfall, sailing '
           'home, ship combat, lakes.',
           'emits LANDFALL/LANDFALL2/SAILHOME/SHIPCOMBAT/SHIPLAKE/'
           'DECLAREWAR'),
    '08': ('pioneer_routes*', 'Pioneer terrain work, trade-route '
           'execution, treasure/loot pickup.',
           'emits CLEARCUT/USEDUPTOOLS/ROUTELOOP/LOOTCASH'),
    '0B': ('native_raid*', 'Native raid execution.', 'emits INDIANBURN'),
    '0C': ('village_trade*', 'Village interaction: trade haggle, chief, '
           'gifts.',
           'emits BADHAGGLE0-3/BUYWHICH/CHIEF*/BRING; func_049600 haggle + '
           'func_04B308 speak-with-chief live here'),
    '0D': ('foreign_loot*', 'Foreign colony capture loot.',
           'emits LOOTFOREIGN'),
    '0F': ('natives*', 'Native relations: alarm, missions, converts, '
           'gifts, USA-era variants.',
           'emits APOSTATES/HEATHEN/INDIAN*/GIVECASH/GIFTS'),
    '10': ('combat_aftermath*', 'Combat aftermath and bulletins: '
           'promotion/demotion, capture, burning, treasure trains.',
           'emits ARTILLERY/BURNED*/CAPTURED*/DEMOTE/CASHTREASURE/'
           'CONTINENTAL'),
    '11': ('combat_ui*', 'Combat Analysis dialog and the two-column '
           'unit-roster modal family.',
           'func_05E9B0 = Combat Analysis (docs/UI_PHASE1_ATTRIBUTION.md #1)'),
    '12': ('trade_editor*', 'Trade-route editor dialogs.',
           'emits CARGOLOAD/CARGOUNLOAD/TRADEDELETE/TRADENAMES'),
    '13': ('pathfind*', 'Pathfinding: the 16x16-window close-moves solver '
           'and the colony-to-colony route walker.',
           'func_061F02 read (docs/UI_PHASE1_ATTRIBUTION.md #2)'),
    '16': ('dialog_pedia*', 'The dialog/popup framework plus the '
           'Colonizopedia browser and context help.',
           'popup.obj/text.obj anchors land here; func_06B398 = pedia '
           'browser (docs/UI_PHASE1_ATTRIBUTION.md); func_06C520 frame '
           'engine (spec/ui/popups.md)'),
    '09': ('map_input_2*', 'Second map-input/order-helper page (continuation '
           'of the map-screen input band).',
           'load-image map/stuff anchors band; no distinct emitter set'),
    '0A': ('menu_bar*', 'The in-game menu-bar pulldown engine: open, track, '
           'select for GAME/VIEW/ORDERS/REPORTS/TRADE.',
           'menu.obj CodeView anchors (_menu_bar_item, _menu_item, '
           '_menu_add_item); func_0452D4 tracking loop '
           '(docs/UI_PHASE1_ATTRIBUTION.md #5)'),
    '0E': ('colony_enter*', 'Colony-screen entry and the colony->colony '
           'route trigger into the pathfinder.',
           'colony_helper_181f_c0e/cd6; routes to page 0x13 pathfinder '
           '(docs/UI_PHASE1_ATTRIBUTION.md #2)'),
    '14': ('mapgen*', 'Map generation: the new-world procedural generator '
           'and continent labelling.',
           'map_generate_new_world (func_064A10) + map_6.obj '
           '_map_find_continents anchor (spec/systems/map_generation.md)'),
    '15': ('map_render*', 'The tile render chain: subcell composition, '
           'terrain/feature sprite emit, minimap, view conform.',
           'emit_ground_sprite/tile_compose_subcells_O512 role names + '
           'map_2.obj/me_mini.obj CodeView anchors '
           '(docs/COLONY_RENDER_CHAIN.md)'),
    '17': ('popup_engine*', 'The shared popup/dialog widget engine: check '
           'items, grey/active state, numeric entry, font.',
           'popup.obj CodeView anchors (_popup_num, _popup_set_font, '
           '_popup_read_check)'),
    '18': ('text_widget*', 'Text list/search widget helpers.',
           'text.obj anchors (_text_item_binary, _text_search)'),
    '19': ('multiplayer*', 'Multiplayer hooks.', 'emits MULTI'),
    '1A': ('boot_save*', 'Boot menu, new-game setup (incl. the customize '
           'screen caller and map load), save/load, the King intro.',
           'emits LOADGAME/SAVEGAME/MAPTOLOAD/VICEROY; func_0759E8 menu '
           'ladder + func_0734F8 serializer (spec/systems/save.md)'),
    '1B': ('engine_io*', 'Engine I/O overlay band (file/loader helpers).',
           'load-image runtime/loader anchors band'),
    '1C': ('engine_loader*', 'Asset loader + packer overlay: MADSPACK '
           'data, file reads, priority.',
           'loader_1.c/pack_6.c/fileio_9.c CodeView anchors'),
    '1D': ('engine_error*', 'Error reporting overlay.',
           'error_1.c _error_report anchor'),
    '1E': ('engine_video*', 'Video/palette overlay: palette cycling and '
           'get, cursor input helper.',
           'mcga_c.c/mcga_8.c CodeView anchors'),
    '1F': ('engine_overlay*', 'Engine-library tail packed as an overlay: '
           'MADSPACK unpack, palette get, memory/heap.',
           'pack_5/pack_6/mcga_8/mem_2/heap_1 CodeView anchors land here'),
}


def norm_module(name):
    # xmatch writes 'dos_d_find.asm.obj' for CodeView 'dos\\d_find.asm',
    # and 'output.asm.obj' for 'output.asm'.
    n = name
    if n.endswith('.obj') and n[:-4].endswith(('.asm', '.c', '.ASM', '.C')):
        n = n[:-4]
    n = n.replace('dos_', 'dos\\', 1) if n.startswith('dos_') else n
    return n


def main():
    me = json.loads((ROOT / 'data_extracted/mapedit_symbols.json').read_text())
    xm = json.loads((ROOT / 'data_extracted/viceroy_named_from_mapedit.json')
                    .read_text())
    rt = json.loads((ROOT / 'tools/rtlink/viceroy_rtlink_map.json').read_text())
    reseg = json.loads((ROOT / 'code/VICEROY/overlay_functions_reseg.json')
                       .read_text())
    funcs = json.loads((ROOT / 'code/VICEROY/functions.json').read_text())
    if not isinstance(funcs, list):
        funcs = funcs['functions']

    me_mod_names = {m['name'] for m in me['modules']}

    # --- page ranges -------------------------------------------------------
    pages = {}
    for s in rt['segments']:
        pid = f"{s['page_id']:02X}"
        pages[pid] = (s['code_offset'], s['code_offset'] + s['code_size'])

    def page_of(off):
        for pid, (a, b) in pages.items():
            if a <= off < b:
                return pid
        return None

    # --- overlay reseg: offset -> page ------------------------------------
    reseg_funcs = reseg['functions'] if isinstance(reseg, dict) else reseg
    reseg_page = {}
    for f in reseg_funcs:
        off = int(str(f['file_offset']), 16) if isinstance(f['file_offset'], str) \
            else f['file_offset']
        pid = f.get('page_id')
        if isinstance(pid, int):
            pid = f'{pid:02X}'
        else:
            pid = f'{int(str(pid), 16):02X}'
        reseg_page[off] = pid

    # --- layer classification for MAPEDIT-named modules --------------------
    SHARED_GAME = {'write.obj', 'tile.obj', 'stuff.obj', 'map.obj',
                   'terrain.obj', 'map_2.obj', 'map_5.obj', 'map_6.obj',
                   'map_9.obj', 'map_a.obj', 'menu.obj', 'popup.obj',
                   'text.obj', 'vicemisc.obj', 'env_1.obj', 'strings.obj'}
    RUNTIME_PAT = re.compile(
        r'^(dos\\|crt0|chkstk|chksum|f(open|close|read|write|gets|seek|'
        r'setpos|getpos|flush|length|tell)|printf|sprintf|rewind|setv?buf|'
        r'str[a-z]*\.asm|atoi|itoa|ltoa|atox|xtoa|ctype|ldiv|lmul|'
        r'hmem|memcpy|output\.asm|stream|_f|_open|_sftbuf|_getbuf|_cflush|'
        r'write\.asm|malloc|free|nmalloc|growseg|searchsg|stackava|'
        r'cmiscdat|txtmode|crt0fp)', re.IGNORECASE)

    def layer_of(mod):
        if mod in SHARED_GAME:
            return 'shared-game'
        if RUNTIME_PAT.match(mod):
            return 'runtime'
        return 'engine'

    # --- anchors -----------------------------------------------------------
    anchors = {}                                    # offset -> (module, tier, name)
    for kind, tier in (('exact', 'B'), ('partial', 'A')):
        for e in xm.get(kind, []):
            off = int(e['viceroy']['file_offset'], 16)
            mod = norm_module(e['mapedit']['module'])
            if mod not in me_mod_names:
                mod = e['mapedit']['module']
            # exact anchors always win over partial at the same offset
            if off not in anchors or tier == 'B':
                anchors[off] = (mod, tier, e['mapedit']['name'])

    # --- assign every function --------------------------------------------
    rows = []
    ordered = sorted(funcs, key=lambda f: int(str(f['file_offset']), 16))
    offs = [int(str(f['file_offset']), 16) for f in ordered]
    b_anchor_offs = sorted(o for o, a in anchors.items() if a[1] == 'B')

    def neighbours(off):
        import bisect
        i = bisect.bisect_left(b_anchor_offs, off)
        prev = b_anchor_offs[i - 1] if i > 0 else None
        nxt = b_anchor_offs[i] if i < len(b_anchor_offs) else None
        return prev, nxt

    for f, off in zip(ordered, offs):
        region = f.get('region')
        pid = reseg_page.get(off) or page_of(off) if region == 'overlay' else None
        rec = {'file_offset': f'0x{off:06X}', 'size': f.get('size'),
               'region': region, 'page': pid, 'name': f.get('name'),
               'status': f.get('status')}
        if off in anchors:
            mod, tier, real = anchors[off]
            rec.update(module=mod, tier=tier, real_name=real)
        else:
            prev, nxt = neighbours(off)
            pm = anchors[prev][0] if prev is not None else None
            nm = anchors[nxt][0] if nxt is not None else None
            same_region = (prev is not None and nxt is not None and
                           page_of(prev) == page_of(off) == page_of(nxt)
                           if region == 'overlay' else True)
            if pm and pm == nm and same_region:
                rec.update(module=pm, tier='A')      # inside a same-module run
            elif region == 'overlay' and pid in PAGE_LABELS:
                rec.update(module=PAGE_LABELS[pid][0], tier='A')
            elif region == 'overlay' and pid is None:
                # Falls in an inter-page gap = an RTLink page header /
                # relocation table the auto-segmenter mis-split as a
                # function (RAW_FUNCTION_AUDIT: "not code at all").
                rec.update(module='(overlay-metadata)', tier='DATA')
            elif region == 'overlay':
                rec.update(module=f'page_{pid}*', tier='TBD')
            else:
                # Module unknown, but when both neighbouring anchors share a
                # LAYER the function is inside that layer's band (A-tier).
                rec.update(module=None, tier='TBD',
                           between=[m for m in (pm, nm) if m])
                if pm and nm and layer_of(pm) == layer_of(nm):
                    rec['layer'] = layer_of(pm)
                    rec['tier'] = 'A-layer'
                    rec['module'] = f'{layer_of(pm)}-band'
                else:
                    rec['module'] = '(resident, unattributed)'
        rows.append(rec)

    # --- fold into module records -----------------------------------------
    mods = defaultdict(lambda: {'functions': [], 'pages': set(),
                                'regions': set(), 'tiers': set()})
    for r in rows:
        m = r['module'] or '(unattributed)'
        mm = mods[m]
        mm['functions'].append(r['file_offset'])
        if r['page']:
            mm['pages'].add(r['page'])
        mm['regions'].add(r['region'])
        mm['tiers'].add(r['tier'])

    me_by_name = {m['name']: m for m in me['modules']}
    out_mods = []
    for name, mm in sorted(mods.items()):
        inferred = name.endswith('*') or name == '(unattributed)'
        rec = {
            'name': name,
            'inferred': inferred,
            'layer': ('game' if inferred or name in
                      ('mapedit.obj',) else
                      'engine' if name not in
                      ('write.obj', 'tile.obj', 'stuff.obj', 'map.obj',
                       'terrain.obj', 'map_2.obj', 'map_9.obj', 'menu.obj',
                       'popup.obj', 'text.obj', 'vicemisc.obj')
                      else 'shared-game'),
            'function_count': len(mm['functions']),
            'functions': mm['functions'],
            'pages': sorted(mm['pages']),
            'regions': sorted(x for x in mm['regions'] if x),
            'anchor_tier': 'B' if 'B' in mm['tiers'] else
                           ('A' if 'A' in mm['tiers'] else 'TBD'),
        }
        if name in me_by_name:
            rec['mapedit_extent'] = {
                'file_offset': me_by_name[name]['file_offset'],
                'size': me_by_name[name]['size']}
        if inferred and name != '(unattributed)':
            pid = name if not name.endswith('*') else None
            for p, (n, definition, ev) in PAGE_LABELS.items():
                if n == name:
                    rec['definition'] = definition
                    rec['evidence'] = ev
        out_mods.append(rec)

    out = {
        '_doc': 'VICEROY.EXE source-module reconstruction. B = named CodeView '
                'anchor (real 1994 name via MAPEDIT fingerprint match); A = '
                'inferred (same-module anchor run, or page-level mechanic '
                'identity from GAME.TXT emitters + screen attributions); '
                'TBD = unattributed. Inferred game-module names end in *.',
        'generator': 'tools/rtlink/make_module_map.py',
        'page_labels': {p: {'module': n, 'definition': d, 'evidence': e}
                        for p, (n, d, e) in PAGE_LABELS.items()},
        'counts': {
            'functions': len(rows),
            'anchored_B': sum(1 for r in rows if r['tier'] == 'B'),
            'run_or_page_A': sum(1 for r in rows if r['tier'] == 'A'),
            'unattributed': sum(1 for r in rows if r['tier'] == 'TBD'),
            'modules': len(out_mods),
        },
        'modules': out_mods,
        'functions': rows,
    }
    dst = ROOT / 'data_extracted/viceroy_modules.json'
    dst.write_text(json.dumps(out, indent=1))
    print(json.dumps(out['counts'], indent=1))
    print('->', dst)


if __name__ == '__main__':
    main()
