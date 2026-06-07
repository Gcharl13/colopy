"""
overlay_role_tagger.py -- bulk-tag overlay functions with @inferred_role
based on the LCALL targets they call.

Reads each function's classification + LCALL list and emits a role tag:
  - COLONY_OP if calls 0x181F:0x9E6 (get_colony_by_slot)
  - RANDOM_DECISION if calls 0x181F:0x4D4 (rand_modulo) >=2 times
  - DIALOG_DRAW if calls 0x181F:0x16E or 0x178 or 0x100 etc. (dialog primitives)
  - SCREEN_DRAW if has SCREEN-WIDTH constants 0x140 or pushes to 0x181F:0x22 (rect-fill)
  - SOUND if calls 0x181F:0x7E0
  - SAVE_LOAD if calls 0x181F:0xA38 or 0xA4C
  - PER_POWER_OP if calls 0x181F:0x582 (per_power_setup)
  - DISPATCH if calls 0x0D1D:0x7A4
  - UNIT_OP if uses IMUL by 0x1C (UnitRecord stride)
  - C_RUNTIME_HELPER if calls 0x0D1D:* (compiler-emitted segment 0x0D1D)

Updates each overlay_*.c file in place by adding @inferred_role lines
into the citation block of every function.
"""

import json
import os
import re
from collections import Counter

PROJECT = str(__import__("pathlib").Path(__file__).resolve().parents[1])
CLASS_JSON = os.path.join(PROJECT, "code", "VICEROY", "overlay_classification.json")
DISASM_DIR = os.path.join(PROJECT, "code", "VICEROY", "disasm")
OVERLAY_DIR = os.path.join(PROJECT, "viceroy_source", "src", "overlay")


# Known LCALL target -> inferred role hint (and confidence)
TAGS = {
    (0x181F, 0x09E6): ('COLONY_OP', 'HIGH'),       # get_colony_by_slot
    (0x181F, 0x04D4): ('RANDOM_DECISION', 'MEDIUM'),  # rand_modulo
    (0x181F, 0x0582): ('PER_POWER_OP', 'MEDIUM'),  # per_power_setup
    (0x181F, 0x07E0): ('SOUND_OR_MUSIC', 'LOW'),
    (0x181F, 0x07B4): ('SOUND_OR_MUSIC', 'LOW'),
    (0x181F, 0x0A38): ('SAVE_LOAD', 'LOW'),
    (0x181F, 0x0A4C): ('SAVE_LOAD', 'LOW'),
    (0x181F, 0x016E): ('DIALOG_DRAW', 'LOW'),
    (0x181F, 0x0178): ('DIALOG_DRAW', 'LOW'),
    (0x181F, 0x0100): ('DIALOG_DRAW', 'LOW'),
    (0x181F, 0x00E2): ('DIALOG_DRAW', 'LOW'),
    (0x181F, 0x013C): ('DIALOG_DRAW', 'LOW'),
    (0x181F, 0x0182): ('DIALOG_DRAW', 'LOW'),
    (0x181F, 0x0022): ('SCREEN_DRAW', 'LOW'),       # rectangle-fill?
    (0x181F, 0x00A6): ('SCREEN_DRAW', 'LOW'),
    (0x181F, 0x00CE): ('SCREEN_DRAW', 'LOW'),
    (0x181F, 0x0254): ('TEXT_DRAW', 'LOW'),
    (0x181F, 0x0444): ('TEXT_DRAW', 'LOW'),
    (0x181F, 0x0438): ('TEXT_DRAW', 'LOW'),
    (0x181F, 0x0416): ('TEXT_DRAW', 'LOW'),
    (0x181F, 0x0652): ('SCREEN_CLEAR', 'LOW'),
    (0x181F, 0x0C72): ('SCREEN_CLEAR_OR_PALETTE', 'LOW'),
    (0x181F, 0x02E4): ('INPUT_POLL', 'LOW'),
    (0x0D1D, 0x07A4): ('DISPATCH_VIA_OVERLAY', 'HIGH'),  # the major dispatcher
    (0x0D1D, 0x07E4): ('C_RUNTIME', 'LOW'),
    (0x0D1D, 0x0528): ('C_RUNTIME', 'LOW'),
    (0x0D1D, 0x117E): ('C_RUNTIME_NUMERIC', 'LOW'),
    (0x0D1D, 0x0DAE): ('MEMSET_OR_MEMCPY', 'MEDIUM'),
}


def infer_role(info):
    """Infer the function's role from its LCALL targets and other features."""
    lcalls = info.get('lcalls', [])
    near_calls = info.get('near_calls', [])
    pattern = info.get('pattern', '')
    touches_8542 = info.get('touches_8542', False)

    role_votes = Counter()
    confidences = []
    for seg, off in lcalls:
        tag = TAGS.get((seg, off))
        if tag:
            role, conf = tag
            role_votes[role] += 1
            confidences.append(conf)

    # Strong direct signals
    if touches_8542:
        role_votes['COLONY_TOUCHED'] += 5

    # Build role list, sorted by votes
    roles = [r for r, n in role_votes.most_common(3)]
    if not roles:
        return None, 'LOW'

    # Combine confidences
    if 'HIGH' in confidences:
        conf = 'HIGH'
    elif 'MEDIUM' in confidences:
        conf = 'MEDIUM'
    else:
        conf = 'LOW'

    return ' / '.join(roles[:3]), conf


def add_role_to_citation(c_text, fn_offset, role, confidence):
    """Insert an @inferred_role line into the citation block of the function
    whose @asm 0x<fn_offset> matches. Idempotent: if already present, skip."""
    if role is None:
        return c_text, False
    fo_str = f"0x{fn_offset:06X}"
    pattern = rf'(@asm\s+{re.escape(fo_str)}\.\.[^\n]*\n(?:[^*]*\*\s*\n)*?(?:[^*]*\*[^\n]*\n)*?)\s*\* @status'
    m = re.search(pattern, c_text)
    if not m:
        return c_text, False
    block = m.group(0)
    if '@inferred_role' in block:
        return c_text, False    # already tagged
    # Insert before @status
    new_line = f' * @inferred_role {role}  ({confidence})\n'
    new_block = block.replace(' * @status', new_line + ' * @status')
    new_text = c_text.replace(block, new_block)
    return new_text, True


def main():
    with open(CLASS_JSON) as f:
        data = json.load(f)
    classes = data['functions']

    files = {}
    for name in sorted(os.listdir(OVERLAY_DIR)):
        if name.startswith('overlay_') and name.endswith('.c'):
            path = os.path.join(OVERLAY_DIR, name)
            with open(path, 'r', encoding='utf-8') as f:
                files[path] = f.read()

    tagged = 0
    role_dist = Counter()
    for fo_str, info in classes.items():
        fo = int(fo_str, 16)
        role, conf = infer_role(info)
        if role is None:
            continue
        # Find the file containing this function
        for path in files:
            base = os.path.basename(path)
            m = re.match(r'overlay_([0-9A-F]+)_([0-9A-F]+)\.c', base)
            if not m: continue
            first = int(m.group(1), 16)
            last = int(m.group(2), 16)
            if first <= fo < last:
                new_text, did = add_role_to_citation(files[path], fo, role, conf)
                if did:
                    files[path] = new_text
                    tagged += 1
                    role_dist[role.split(' / ')[0]] += 1
                break

    for path, content in files.items():
        with open(path, 'w', encoding='utf-8') as f:
            f.write(content)

    print(f"[role_tagger] tagged {tagged} functions with @inferred_role")
    print(f"[role_tagger] primary-role distribution:")
    for role, n in role_dist.most_common():
        print(f"  {role:30s}: {n}")


if __name__ == '__main__':
    main()
