import capstone
path = "/home/user/colopy/raw/COLONIZE/VICEROY.EXE"
with open(path, "rb") as f:
    data = f.read()
load_base = 0x2400
md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_16)
# Disassemble from the function start 0x22E50 backwards context and forward enough
start = 0x22E40
code = data[start:start+30]
print("=== context before 0x22E50 ===")
for insn in md.disasm(code, start-load_base):
    foff = insn.address + load_base
    raw = ' '.join(f'{b:02X}' for b in insn.bytes)
    print(f"file=0x{foff:05X}: {raw:<18} {insn.mnemonic} {insn.op_str}")
