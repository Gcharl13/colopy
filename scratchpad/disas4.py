import capstone
path = "/home/user/colopy/raw/COLONIZE/VICEROY.EXE"
with open(path, "rb") as f:
    data = f.read()
load_base = 0x2400
md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_16)

# The 0x48 branch loop calls these (from main disas):
# 0x22E7D lcall 0x191f,0x2a4
# 0x22E82 lcall 0x191f,0x296
# 0x22E87 lcall 0x191f,0x288
for seg,off,label in [(0x191f,0x2a4,"A"),(0x191f,0x296,"B"),(0x191f,0x288,"C")]:
    foff = 0x2400 + seg*16 + off
    print(f"=== call {label}: seg=0x{seg:X} off=0x{off:X} -> file_off=0x{foff:X} ===")
    code = data[foff:foff+16]
    for insn in md.disasm(code, foff-load_base):
        f = insn.address + load_base
        raw = ' '.join(f'{b:02X}' for b in insn.bytes)
        print(f"  file=0x{f:05X}: {raw:<16} {insn.mnemonic} {insn.op_str}")
