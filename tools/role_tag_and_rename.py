"""
role_tag_and_rename.py -- universal role-tagger + renamer for any source directory.

Usage:
  python role_tag_and_rename.py <classification.json> <src_dir> [<file_prefix>]

Walks the .c files in <src_dir> (matching <file_prefix>*.c if given), and:
  1. Adds @inferred_role to each function's citation block based on the
     classifier output.
  2. Renames functions from func_NNNNNN_unknown to func_NNNNNN_<role_short>.
"""

import json
import os
import re
import sys
from collections import Counter


# Known LCALL targets -> role
TAGS = {
    (0x181F, 0x09E6): ('COLONY_OP', 'HIGH'),
    (0x181F, 0x04D4): ('RANDOM_DECISION', 'MEDIUM'),
    (0x181F, 0x0582): ('PER_POWER_OP', 'MEDIUM'),
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
    (0x181F, 0x0022): ('SCREEN_DRAW', 'LOW'),
    (0x181F, 0x00A6): ('SCREEN_DRAW', 'LOW'),
    (0x181F, 0x00CE): ('SCREEN_DRAW', 'LOW'),
    (0x181F, 0x0254): ('TEXT_DRAW', 'LOW'),
    (0x181F, 0x0444): ('TEXT_DRAW', 'LOW'),
    (0x181F, 0x0438): ('TEXT_DRAW', 'LOW'),
    (0x181F, 0x0416): ('TEXT_DRAW', 'LOW'),
    (0x181F, 0x0652): ('SCREEN_CLEAR', 'LOW'),
    (0x181F, 0x0C72): ('SCREEN_CLEAR_OR_PALETTE', 'LOW'),
    (0x181F, 0x02E4): ('INPUT_POLL', 'LOW'),
    (0x0D1D, 0x07A4): ('DISPATCH_VIA_OVERLAY', 'HIGH'),
    (0x0D1D, 0x07E4): ('C_RUNTIME', 'LOW'),
    (0x0D1D, 0x0528): ('C_RUNTIME', 'LOW'),
    (0x0D1D, 0x117E): ('C_RUNTIME_NUMERIC', 'LOW'),
    (0x0D1D, 0x0DAE): ('MEMSET_OR_MEMCPY', 'MEDIUM'),
}

ROLE_SHORT = {
    'COLONY_TOUCHED':         'colony_op',
    'COLONY_OP':              'colony_load',
    'PER_POWER_OP':           'power_op',
    'RANDOM_DECISION':        'rng_decide',
    'DIALOG_DRAW':            'dlg',
    'TEXT_DRAW':              'text',
    'SCREEN_DRAW':            'draw',
    'SCREEN_CLEAR':           'clear',
    'SCREEN_CLEAR_OR_PALETTE': 'clear',
    'SOUND_OR_MUSIC':         'sound',
    'SAVE_LOAD':              'sav',
    'C_RUNTIME':              'rtl',
    'C_RUNTIME_NUMERIC':      'num',
    'DISPATCH_VIA_OVERLAY':   'dispatch',
    'INPUT_POLL':             'input',
    'MEMSET_OR_MEMCPY':       'mem',
}


def infer_role(info):
    lcalls = info.get('lcalls', [])
    role_votes = Counter()
    confidences = []
    for seg, off in lcalls:
        tag = TAGS.get((seg, off))
        if tag:
            role, conf = tag
            role_votes[role] += 1
            confidences.append(conf)
    if info.get('touches_8542'):
        role_votes['COLONY_TOUCHED'] += 5
    if not role_votes:
        return None, 'LOW'
    roles = [r for r, n in role_votes.most_common(3)]
    conf = 'HIGH' if 'HIGH' in confidences else ('MEDIUM' if 'MEDIUM' in confidences else 'LOW')
    return ' / '.join(roles[:3]), conf


def add_role_to_citation(c_text, fn_offset, role, confidence):
    if role is None:
        return c_text, False
    fo_str = f"0x{fn_offset:06X}"
    pattern = rf'(@asm\s+{re.escape(fo_str)}\.\.[^\n]*\n(?:[^*]*\*\s*\n)*?(?:[^*]*\*[^\n]*\n)*?)\s*\* @status'
    m = re.search(pattern, c_text)
    if not m:
        return c_text, False
    block = m.group(0)
    if '@inferred_role' in block:
        return c_text, False
    new_line = f' * @inferred_role {role}  ({confidence})\n'
    new_block = block.replace(' * @status', new_line + ' * @status')
    new_text = c_text.replace(block, new_block)
    return new_text, True


def rename_by_role(c_text):
    """Rename functions from _unknown to role-based name."""
    pattern = (
        r'(\* @inferred_role\s+([A-Z_/\s]+)\s+\(([A-Z]+)\)\n'
        r'(?: \*[^\n]*\n)*?'
        r' \* @status[^\n]*\n'
        r' \*/\n)'
        r'int (func_([0-9A-F]+))_unknown\((.*?)\)'
    )
    renames = [0]
    def repl(m):
        cit = m.group(1)
        roles = m.group(2).strip()
        offset = m.group(5)
        args = m.group(6)
        primary = roles.split(' / ')[0].strip()
        short = ROLE_SHORT.get(primary, 'op')
        renames[0] += 1
        return f"{cit}int func_{offset}_{short}({args})"
    new_text = re.sub(pattern, repl, c_text)
    return new_text, renames[0]


def main(class_json, src_dir, prefix=None):
    with open(class_json) as f:
        classes = json.load(f)['functions']

    files = {}
    for name in sorted(os.listdir(src_dir)):
        if not name.endswith('.c'): continue
        if prefix and not name.startswith(prefix): continue
        path = os.path.join(src_dir, name)
        with open(path, 'r', encoding='utf-8') as f:
            files[path] = f.read()

    tagged = 0
    renamed_total = 0
    role_dist = Counter()

    for fo_str, info in classes.items():
        fo = int(fo_str, 16)
        role, conf = infer_role(info)
        if role is None:
            continue
        for path in files:
            if f'0x{fo:06X}' not in files[path]:
                continue
            new_text, did = add_role_to_citation(files[path], fo, role, conf)
            if did:
                files[path] = new_text
                tagged += 1
                role_dist[role.split(' / ')[0]] += 1
                break

    # Now do renames
    for path in files:
        new_text, n = rename_by_role(files[path])
        if n > 0:
            files[path] = new_text
            renamed_total += n

    for path, content in files.items():
        with open(path, 'w', encoding='utf-8') as f:
            f.write(content)

    print(f"[role_tag_and_rename] tagged {tagged} functions with @inferred_role")
    print(f"[role_tag_and_rename] renamed {renamed_total} functions")
    print(f"[role_tag_and_rename] role distribution:")
    for role, n in role_dist.most_common():
        print(f"  {role:30s}: {n}")


if __name__ == '__main__':
    if len(sys.argv) < 3:
        print(__doc__)
        sys.exit(1)
    cj = sys.argv[1]
    sd = sys.argv[2]
    pf = sys.argv[3] if len(sys.argv) > 3 else None
    main(cj, sd, pf)
