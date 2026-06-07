"""
overlay_rename_by_role.py -- bulk-rename overlay functions based on their
@inferred_role tag. Generates more meaningful function names while keeping
the file-offset prefix for traceability.

Naming scheme:
  func_NNNNNN_unknown -> func_NNNNNN_<role_short>

Role short names:
  COLONY_TOUCHED        -> colony_op
  COLONY_OP             -> colony_load
  PER_POWER_OP          -> power_op
  RANDOM_DECISION       -> rng_decide
  DIALOG_DRAW           -> dlg
  TEXT_DRAW             -> text
  SCREEN_DRAW           -> draw
  SCREEN_CLEAR          -> clear
  SOUND_OR_MUSIC        -> sound
  SAVE_LOAD             -> sav
  C_RUNTIME             -> rtl
  C_RUNTIME_NUMERIC     -> num
  DISPATCH_VIA_OVERLAY  -> dispatch
  INPUT_POLL            -> input
  MEMSET_OR_MEMCPY      -> mem
"""

import json
import os
import re

PROJECT = str(__import__("pathlib").Path(__file__).resolve().parents[1])
OVERLAY_DIR = os.path.join(PROJECT, "viceroy_source", "src", "overlay")

ROLE_SHORT = {
    'COLONY_TOUCHED':        'colony_op',
    'COLONY_OP':             'colony_load',
    'PER_POWER_OP':          'power_op',
    'RANDOM_DECISION':       'rng_decide',
    'DIALOG_DRAW':           'dlg',
    'TEXT_DRAW':             'text',
    'SCREEN_DRAW':           'draw',
    'SCREEN_CLEAR':          'clear',
    'SCREEN_CLEAR_OR_PALETTE': 'clear',
    'SOUND_OR_MUSIC':        'sound',
    'SAVE_LOAD':             'sav',
    'C_RUNTIME':             'rtl',
    'C_RUNTIME_NUMERIC':     'num',
    'DISPATCH_VIA_OVERLAY':  'dispatch',
    'INPUT_POLL':            'input',
    'MEMSET_OR_MEMCPY':      'mem',
}


def main():
    files = {}
    for name in sorted(os.listdir(OVERLAY_DIR)):
        if name.startswith('overlay_') and name.endswith('.c'):
            path = os.path.join(OVERLAY_DIR, name)
            with open(path, 'r', encoding='utf-8') as f:
                files[path] = f.read()

    renames = 0
    for path in list(files):
        content = files[path]
        # Find each function block: citation + signature
        pattern = (
            r'(\* @inferred_role\s+([A-Z_]+(?:\s*/\s*[A-Z_]+)*)\s+\(([A-Z]+)\)\n'
            r'(?: \*[^\n]*\n)*?'
            r' \* @status[^\n]*\n'
            r' \*/\n)'
            r'int (func_([0-9A-F]+))_unknown\((.*?)\)'
        )
        def replace(m):
            nonlocal renames
            citation_block = m.group(1)
            roles = m.group(2)
            confidence = m.group(3)
            full_name = m.group(4)
            offset = m.group(5)
            args = m.group(6)
            primary_role = roles.split(' / ')[0].strip()
            short = ROLE_SHORT.get(primary_role, 'op')
            new_name = f"func_{offset}_{short}"
            renames += 1
            return f"{citation_block}int {new_name}({args})"

        new_content = re.sub(pattern, replace, content)
        if new_content != content:
            files[path] = new_content

    for path, content in files.items():
        with open(path, 'w', encoding='utf-8') as f:
            f.write(content)

    print(f"[role_rename] renamed {renames} functions")


if __name__ == '__main__':
    main()
