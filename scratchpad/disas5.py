import capstone
path = "/home/user/colopy/raw/COLONIZE/VICEROY.EXE"
with open(path, "rb") as f:
    data = f.read()
load_base = 0x2400
md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_16)
# Re-dump 0x22E6D..0x22EB0 with file-offset jump targets
start=0x22E6D
code=data[start:start+0x44]
for insn in md.disasm(code, start-load_base):
    f = insn.address + load_base
    raw=' '.join(f'{b:02X}' for b in insn.bytes)
    note=""
    if insn.mnemonic.startswith('j') or insn.mnemonic=='jmp':
        try:
            tgt=int(insn.op_str,16)
            note=f"  -> file=0x{tgt+load_base:05X}"
        except: pass
    print(f"file=0x{f:05X}: {raw:<18} {insn.mnemonic} {insn.op_str}{note}")
