"""
overlay_pattern_fillers.py -- post-process overlay_*.c files to fill in
patterns we can identify automatically:

  1. TINY_ACCESSOR: identify the single struct field or DGROUP global being read.
  2. TINY_RETURN: identify the return constant.
  3. WRAPPER_LCALL: keep the auto-generated body (already good).
  4. BIT_ACCESSOR / NIBBLE_ACCESSOR: identify the array offset and direction.
  5. PROLOGUE_HEAVY: detect "save/restore registers + return X" patterns.

This tool reads each function's .asm, parses the body for the SINGLE READ
operation it likely performs, and rewrites the body in the .c file.

Outputs progress to STDOUT and updates files in place.
"""

import json
import os
import re
from collections import defaultdict, Counter

PROJECT = r"c:\Users\gregc\OneDrive\Desktop\COLOPY\reverse_engineered"
DISASM_DIR = os.path.join(PROJECT, "code", "VICEROY", "disasm")
FUNCTIONS_JSON = os.path.join(PROJECT, "code", "VICEROY", "functions.json")
CLASS_JSON = os.path.join(PROJECT, "code", "VICEROY", "overlay_classification.json")
OVERLAY_DIR = os.path.join(PROJECT, "viceroy_source", "src", "overlay")


# Patterns
RE_INSTR_LINE = re.compile(r'^([0-9A-Fa-f]+)\s+([0-9A-F ]{1,30}?)\s+([A-Z][A-Z0-9_]*)\s*(.*?)$')
RE_DGROUP = re.compile(r'\[0x([0-9a-fA-F]+)\]')
RE_BX_DISP = re.compile(r'\[bx\s*\+\s*0x([0-9a-fA-F]+)\]')
RE_BP_ARG = re.compile(r'\[bp\s*\+\s*(0x[0-9a-fA-F]+|\d+)\]')
RE_IMM = re.compile(r'\b0x([0-9a-fA-F]+)\b')


def parse_asm(asm_path):
    if not os.path.isfile(asm_path):
        return []
    with open(asm_path, 'r', encoding='utf-8', errors='replace') as f:
        content = f.read()
    instrs = []
    for line in content.splitlines():
        line = line.rstrip()
        if line.startswith(';') or not line.strip():
            continue
        m = re.match(r'^([0-9A-Fa-f]+)\s+([0-9A-F ]{1,30}?)\s{2,}([A-Z][A-Z0-9_]*)\s*(.*?)(?:\s*;.*)?$', line)
        if m:
            instrs.append({
                'addr': int(m.group(1), 16),
                'mnemonic': m.group(3).upper(),
                'operands': (m.group(4) or '').strip(),
                'full': f"{m.group(3)} {m.group(4) or ''}".strip(),
            })
    return instrs


def identify_tiny_accessor_field(instrs):
    """For a tiny accessor, find the SINGLE field read that becomes the return value.
    Returns:
      ('global', 0xNNNN, 'word'|'byte') for direct DGROUP reads
      ('global_indexed', 0xNNNN, idx_arg) for [BX + 0xNNNN] reads
      ('via_8542', 0xNNNN) for *(0x8542)+offset reads
      None if not identifiable.
    """
    # Look at the body — strip prologue (ENTER, PUSH BP, MOV BP SP, PUSH SI/DI)
    # and epilogue (LEAVE/POP/RETF/CWDE/SUB AH,AH).
    body = []
    for ins in instrs:
        m = ins['mnemonic']
        if m in ('ENTER', 'LEAVE', 'RETF', 'RETN', 'POP', 'PUSH', 'CWDE', 'CWD'):
            continue
        body.append(ins)

    # Was 0x8542 loaded? (i.e. *(0x8542) dereference)
    saw_8542 = False
    field_offset = None
    for ins in body:
        if '0x8542' in ins['full']:
            saw_8542 = True
        if saw_8542:
            m = RE_BX_DISP.search(ins['full'])
            if m:
                field_offset = int(m.group(1), 16)
                width = 'byte' if 'byte ptr' in ins['full'] else 'word'
                return ('via_8542', field_offset, width)

    # Direct DGROUP global: MOV AX, [0xNNNN] (no BX involvement)
    for ins in body:
        if ins['mnemonic'] != 'MOV':
            continue
        if 'bx' in ins['operands'].lower() or 'si' in ins['operands'].lower():
            continue
        m = RE_DGROUP.search(ins['full'])
        if m:
            addr = int(m.group(1), 16)
            width = 'byte' if 'byte ptr' in ins['full'] else 'word'
            return ('global', addr, width)

    return None


def identify_tiny_return_value(instrs):
    """For a tiny return, find the constant being returned."""
    for ins in instrs:
        if ins['mnemonic'] == 'MOV':
            # MOV AX, imm
            if re.search(r'\bax\s*,\s*0x[0-9a-fA-F]+', ins['operands']):
                m = RE_IMM.search(ins['operands'])
                if m:
                    return int(m.group(1), 16)
            elif re.search(r'\bax\s*,\s*-?\d+', ins['operands']):
                m = re.search(r'\bax\s*,\s*(-?\d+)', ins['operands'])
                if m:
                    return int(m.group(1))
        elif ins['mnemonic'] == 'XOR' or ins['mnemonic'] == 'SUB':
            if re.search(r'\bax\s*,\s*ax', ins['operands']):
                return 0
    return None


def identify_bit_accessor(instrs):
    """For a bit-accessor, find the byte-array offset + bit-position computation."""
    # Pattern: SHL / SAR by 3 (idx>>3 = byte offset within bit array)
    saw_shr3 = False
    saw_8542 = False
    base_offset = None
    is_set = False
    is_clear = False
    for ins in instrs:
        full = ins['full']
        if '0x8542' in full:
            saw_8542 = True
        if ins['mnemonic'] in ('SAR', 'SHR') and ', 3' in full:
            saw_shr3 = True
        if saw_8542 and saw_shr3:
            m = RE_BX_DISP.search(full)
            if m:
                base_offset = int(m.group(1), 16)
                break
            # Or [bx + si + 0xN]
            m = re.search(r'\[bx\s*\+\s*si\s*\+\s*0x([0-9a-fA-F]+)\]', full)
            if m:
                base_offset = int(m.group(1), 16)
                break
        if 'OR' == ins['mnemonic'] and '[bx]' in full:
            is_set = True
        elif 'AND' == ins['mnemonic'] and '[bx]' in full and 'NOT' in full:
            is_clear = True
    if base_offset is None:
        return None
    return ('bit_at', base_offset, 'set_or_clear' if is_set or is_clear else 'test')


def parse_overlay_c_files(overlay_dir):
    """Read each overlay_*.c file, return a list of (path, content)."""
    out = []
    for name in sorted(os.listdir(overlay_dir)):
        if name.startswith('overlay_') and name.endswith('.c'):
            path = os.path.join(overlay_dir, name)
            with open(path, 'r', encoding='utf-8') as f:
                content = f.read()
            out.append((path, content))
    return out


def fill_tiny_accessor(c_text, fn_name, accessor_info):
    """Replace the body of fn_name in c_text with a tiny-accessor body."""
    if accessor_info is None:
        return c_text, False

    kind = accessor_info[0]
    if kind == 'via_8542':
        offset = accessor_info[1]
        width = accessor_info[2]
        if width == 'byte':
            new_body = f'    /* @auto: byte read at *(0x8542)+0x{offset:02X} (colony field). */\n    return ctx->_byte_at_{offset:02X};  /* TODO: identify named field in colony.h */'
        else:
            new_body = f'    /* @auto: word read at *(0x8542)+0x{offset:02X} (colony field). */\n    return ctx->_word_at_{offset:02X};  /* TODO: identify named field in colony.h */'
    elif kind == 'global':
        addr, width = accessor_info[1], accessor_info[2]
        if width == 'byte':
            new_body = f'    /* @auto: read DGROUP byte at 0x{addr:04X}. */\n    return *(uint8_t near*)0x{addr:04X};'
        else:
            new_body = f'    /* @auto: read DGROUP word at 0x{addr:04X}. */\n    return *(uint16_t near*)0x{addr:04X};'
    else:
        return c_text, False

    # Find the function definition and replace its body.
    pattern = r'(int ' + re.escape(fn_name) + r'\([^)]*\)\s*\{\s*)(/\*\s*@auto:[^}]*?return [^;]*;[^}]*?)(\n\})'
    new_text, n = re.subn(pattern, r'\1' + new_body.replace('\\', '\\\\') + r'\3', c_text, count=1, flags=re.DOTALL)
    if n == 0:
        return c_text, False
    return new_text, True


def fill_tiny_return(c_text, fn_name, value):
    """Replace the body of fn_name with `return <value>`."""
    new_body = f'    /* @auto: returns constant 0x{value:X}. */\n    return 0x{value:X};'
    pattern = r'(int ' + re.escape(fn_name) + r'\([^)]*\)\s*\{\s*)(/\*\s*@auto:[^}]*?return [^;]*;[^}]*?)(\n\})'
    new_text, n = re.subn(pattern, r'\1' + new_body + r'\3', c_text, count=1, flags=re.DOTALL)
    return new_text, n > 0


def main():
    with open(FUNCTIONS_JSON) as f:
        funcs_data = json.load(f)
    with open(CLASS_JSON) as f:
        classes_data = json.load(f)
    overlay_funcs = [f for f in funcs_data['functions'] if f['region'] == 'overlay']
    classes = classes_data['functions']

    # Group functions by .c file (use file_offset chunks)
    print(f"[pattern_fillers] processing {len(overlay_funcs)} overlay functions...")

    # Read all overlay .c files
    files = parse_overlay_c_files(OVERLAY_DIR)
    file_contents = {p: c for p, c in files}

    filled_tiny_acc = 0
    filled_tiny_ret = 0

    for func in overlay_funcs:
        info = classes.get(func['file_offset'], {})
        pattern = info.get('pattern')
        fn_name = os.path.basename(func['asm_file']).replace('.asm', '')
        asm_path = os.path.join(DISASM_DIR, os.path.basename(func['asm_file']))

        # Find which .c file owns this function (based on file_offset chunk)
        fo_int = int(func['file_offset'], 16)
        owner_path = None
        for path in file_contents:
            base = os.path.basename(path)
            m = re.match(r'overlay_([0-9A-F]+)_([0-9A-F]+)\.c', base)
            if m:
                first = int(m.group(1), 16)
                last = int(m.group(2), 16)
                if first <= fo_int < last:
                    owner_path = path
                    break

        if not owner_path:
            continue

        if pattern == 'TINY_ACCESSOR':
            instrs = parse_asm(asm_path)
            ai = identify_tiny_accessor_field(instrs)
            if ai:
                new_text, did = fill_tiny_accessor(file_contents[owner_path], fn_name, ai)
                if did:
                    file_contents[owner_path] = new_text
                    filled_tiny_acc += 1
        elif pattern == 'TINY_RETURN':
            instrs = parse_asm(asm_path)
            val = identify_tiny_return_value(instrs)
            if val is not None:
                new_text, did = fill_tiny_return(file_contents[owner_path], fn_name, val)
                if did:
                    file_contents[owner_path] = new_text
                    filled_tiny_ret += 1

    # Write back
    for path, content in file_contents.items():
        with open(path, 'w', encoding='utf-8') as f:
            f.write(content)

    print(f"[pattern_fillers] filled {filled_tiny_acc} TINY_ACCESSORs")
    print(f"[pattern_fillers] filled {filled_tiny_ret} TINY_RETURNs")


if __name__ == '__main__':
    main()
